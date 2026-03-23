import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class RadarChartWidget extends StatelessWidget {
  final List<String> axes;
  final List<List<double>> dataSets;
  final List<Color> colors;
  final List<String>? legends;
  final double height;
  final Color? backgroundColor;

  const RadarChartWidget({
    super.key,
    required this.axes,
    required this.dataSets,
    required this.colors,
    this.legends,
    this.height = 260,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (legends != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Wrap(
              spacing: 12,
              runSpacing: 4,
              children: List.generate(legends!.length, (i) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: colors[i % colors.length],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      legends![i],
                      style: const TextStyle(fontSize: 11, color: AppColors.textSub),
                    ),
                  ],
                );
              }),
            ),
          ),
        Container(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: CustomPaint(
            size: Size.infinite,
            painter: _RadarPainter(
              axes: axes,
              dataSets: dataSets,
              colors: colors,
              isDark: backgroundColor != null,
            ),
          ),
        ),
      ],
    );
  }
}

class _RadarPainter extends CustomPainter {
  final List<String> axes;
  final List<List<double>> dataSets;
  final List<Color> colors;
  final bool isDark;

  _RadarPainter({
    required this.axes,
    required this.dataSets,
    required this.colors,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (axes.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 36;
    final n = axes.length;
    final angleStep = 2 * math.pi / n;

    // Grid rings
    final gridColor = isDark ? Colors.white.withValues(alpha: 0.15) : AppColors.border;
    final gridPaint = Paint()
      ..color = gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (int ring = 1; ring <= 4; ring++) {
      final r = radius * ring / 4;
      final path = Path();
      for (int i = 0; i <= n; i++) {
        final angle = -math.pi / 2 + angleStep * (i % n);
        final p = Offset(center.dx + r * math.cos(angle), center.dy + r * math.sin(angle));
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      canvas.drawPath(path, gridPaint);
    }

    // Spokes + labels
    for (int i = 0; i < n; i++) {
      final angle = -math.pi / 2 + angleStep * i;
      final end = Offset(center.dx + radius * math.cos(angle), center.dy + radius * math.sin(angle));
      canvas.drawLine(center, end, gridPaint);

      final labelOffset = Offset(
        center.dx + (radius + 18) * math.cos(angle),
        center.dy + (radius + 18) * math.sin(angle),
      );
      final tp = TextPainter(
        text: TextSpan(
          text: axes[i],
          style: TextStyle(
            fontSize: 10,
            color: isDark ? Colors.white.withValues(alpha: 0.8) : AppColors.textSub,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(labelOffset.dx - tp.width / 2, labelOffset.dy - tp.height / 2));
    }

    // Data polygons
    for (int d = 0; d < dataSets.length; d++) {
      final data = dataSets[d];
      final color = colors[d % colors.length];
      final path = Path();

      for (int i = 0; i < n; i++) {
        final val = i < data.length ? data[i].clamp(0, 1) : 0.0;
        final angle = -math.pi / 2 + angleStep * i;
        final r = radius * val;
        final p = Offset(center.dx + r * math.cos(angle), center.dy + r * math.sin(angle));
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      path.close();

      final fillPaint = Paint()
        ..color = color.withValues(alpha: 0.15)
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, fillPaint);

      final strokePaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawPath(path, strokePaint);

      for (int i = 0; i < n; i++) {
        final val = i < data.length ? data[i].clamp(0, 1) : 0.0;
        final angle = -math.pi / 2 + angleStep * i;
        final r = radius * val;
        final p = Offset(center.dx + r * math.cos(angle), center.dy + r * math.sin(angle));
        canvas.drawCircle(p, 3, Paint()..color = color);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
