import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class BarChartWidget extends StatelessWidget {
  final List<List<double>> dataSets;
  final List<Color> colors;
  final List<String> labels;
  final List<String>? legends;
  final double height;

  const BarChartWidget({
    super.key,
    required this.dataSets,
    required this.colors,
    required this.labels,
    this.legends,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (legends != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: List.generate(legends!.length, (i) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: colors[i],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        legends![i],
                        style: const TextStyle(fontSize: 11, color: AppColors.textSub),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        SizedBox(
          height: height,
          child: CustomPaint(
            size: Size.infinite,
            painter: _BarChartPainter(
              dataSets: dataSets,
              colors: colors,
              labels: labels,
            ),
          ),
        ),
      ],
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<List<double>> dataSets;
  final List<Color> colors;
  final List<String> labels;

  _BarChartPainter({
    required this.dataSets,
    required this.colors,
    required this.labels,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dataSets.isEmpty || dataSets.first.isEmpty) return;

    const leftPad = 40.0;
    const bottomPad = 24.0;
    const topPad = 8.0;
    final chartW = size.width - leftPad;
    final chartH = size.height - bottomPad - topPad;

    // Find min and max values
    double maxVal = 0;
    double minVal = 0;
    for (final ds in dataSets) {
      for (final v in ds) {
        if (v > maxVal) maxVal = v;
        if (v < minVal) minVal = v;
      }
    }
    // Add padding
    if (maxVal > 0) maxVal *= 1.15;
    if (minVal < 0) minVal *= 1.15;
    if (maxVal == 0 && minVal == 0) maxVal = 1;
    final range = maxVal - minVal;
    if (range == 0) return;

    // Zero line Y position
    final zeroY = topPad + (maxVal / range) * chartH;

    // Grid
    final gridPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 0.5;
    const gridCount = 4;
    for (int i = 0; i <= gridCount; i++) {
      final y = topPad + chartH - (chartH / gridCount * i);
      canvas.drawLine(Offset(leftPad, y), Offset(size.width, y), gridPaint);
      final val = minVal + (range / gridCount * i);
      final label = val.abs() >= 1000 ? '${(val / 1000).toStringAsFixed(0)}K' : val.toInt().toString();
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(leftPad - tp.width - 6, y - tp.height / 2));
    }

    // Draw zero line if we have negative values
    if (minVal < 0 && maxVal > 0) {
      final zeroPaint = Paint()
        ..color = AppColors.slate300
        ..strokeWidth = 1;
      canvas.drawLine(Offset(leftPad, zeroY), Offset(size.width, zeroY), zeroPaint);
    }

    final count = dataSets.first.length;
    final setCount = dataSets.length;
    final groupW = chartW / count;
    final barW = (groupW * 0.6) / setCount;
    final gap = groupW * 0.4;

    for (int i = 0; i < count; i++) {
      // X label
      if (i < labels.length) {
        final tp = TextPainter(
          text: TextSpan(
            text: labels[i],
            style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(leftPad + groupW * i + groupW / 2 - tp.width / 2, size.height - bottomPad + 6));
      }

      for (int d = 0; d < setCount; d++) {
        final val = dataSets[d][i];
        final barH = (val.abs() / range) * chartH;
        final x = leftPad + groupW * i + gap / 2 + barW * d;

        double barTop;
        if (val >= 0) {
          barTop = zeroY - barH;
        } else {
          barTop = zeroY;
        }

        final paint = Paint()..color = colors[d % colors.length];
        final rect = RRect.fromRectAndCorners(
          Rect.fromLTWH(x, barTop, barW, barH),
          topLeft: val >= 0 ? const Radius.circular(3) : Radius.zero,
          topRight: val >= 0 ? const Radius.circular(3) : Radius.zero,
          bottomLeft: val < 0 ? const Radius.circular(3) : Radius.zero,
          bottomRight: val < 0 ? const Radius.circular(3) : Radius.zero,
        );
        canvas.drawRRect(rect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
