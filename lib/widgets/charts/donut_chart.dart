import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class DonutChartWidget extends StatelessWidget {
  final List<double> values;
  final List<Color> colors;
  final List<String> labels;
  final String? centerLabel;
  final String? centerValue;
  final double size;

  const DonutChartWidget({
    super.key,
    required this.values,
    required this.colors,
    required this.labels,
    this.centerLabel,
    this.centerValue,
    this.size = 160,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _DonutPainter(
              values: values,
              colors: colors,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (centerLabel != null)
                    Text(
                      centerLabel!,
                      style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                    ),
                  if (centerValue != null)
                    Text(
                      centerValue!,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.text),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: List.generate(labels.length, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: colors[i % colors.length],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        labels[i],
                        style: const TextStyle(fontSize: 12, color: AppColors.text),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${values[i].toStringAsFixed(0)}%',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.text),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;

  _DonutPainter({required this.values, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    const strokeWidth = 24.0;
    final total = values.fold<double>(0, (a, b) => a + b);
    if (total == 0) return;

    double startAngle = -math.pi / 2;

    for (int i = 0; i < values.length; i++) {
      final sweepAngle = (values[i] / total) * 2 * math.pi;
      final paint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle - 0.02,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
