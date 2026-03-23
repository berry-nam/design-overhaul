import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/mock_data.dart';

class WaterfallChartWidget extends StatelessWidget {
  final List<WaterfallSegment> data;
  final double height;

  const WaterfallChartWidget({
    super.key,
    required this.data,
    this.height = 220,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(
        size: Size.infinite,
        painter: _WaterfallPainter(data: data),
      ),
    );
  }
}

class _WaterfallPainter extends CustomPainter {
  final List<WaterfallSegment> data;

  _WaterfallPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    const leftPad = 10.0;
    const rightPad = 10.0;
    const bottomPad = 36.0;
    const topPad = 16.0;
    final chartW = size.width - leftPad - rightPad;
    final chartH = size.height - bottomPad - topPad;

    double maxVal = 0;
    for (final s in data) {
      if (s.value > maxVal) maxVal = s.value;
    }
    double running = 0;
    for (final s in data) {
      if (!s.isTotal) {
        running += s.value;
        if (running > maxVal) maxVal = running;
      } else {
        if (s.value > maxVal) maxVal = s.value;
      }
    }
    maxVal = (maxVal * 1.15).ceilToDouble();
    if (maxVal == 0) maxVal = 1;

    final count = data.length;
    final barW = (chartW / count) * 0.6;
    final stepX = chartW / count;

    double cumulative = 0;

    for (int i = 0; i < count; i++) {
      final seg = data[i];
      final centerX = leftPad + stepX * i + stepX / 2;

      double barH;
      double barTop;

      if (seg.isTotal) {
        barH = (seg.value / maxVal) * chartH;
        barTop = topPad + chartH - barH;
      } else {
        barH = (seg.value / maxVal) * chartH;
        barTop = topPad + chartH - ((cumulative + seg.value) / maxVal) * chartH;
        cumulative += seg.value;
      }

      final color = seg.isTotal ? AppColors.brand : AppColors.blue300;
      final paint = Paint()..color = color;
      final rect = RRect.fromRectAndCorners(
        Rect.fromLTWH(centerX - barW / 2, barTop, barW, barH),
        topLeft: const Radius.circular(3),
        topRight: const Radius.circular(3),
      );
      canvas.drawRRect(rect, paint);

      // Value label on top
      final valText = '${seg.value.toInt()}';
      final tp = TextPainter(
        text: TextSpan(
          text: valText,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: seg.isTotal ? AppColors.brand : AppColors.text,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(centerX - tp.width / 2, barTop - tp.height - 3));

      // X label
      final labelTp = TextPainter(
        text: TextSpan(
          text: seg.label,
          style: const TextStyle(fontSize: 9, color: AppColors.textSub),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      labelTp.paint(canvas, Offset(centerX - labelTp.width / 2, size.height - bottomPad + 6));

      // Connector line
      if (!seg.isTotal && i < count - 1) {
        final lineY = topPad + chartH - (cumulative / maxVal) * chartH;
        final lineEnd = leftPad + stepX * (i + 1) + stepX / 2 - barW / 2;
        final dashPaint = Paint()
          ..color = AppColors.textMuted
          ..strokeWidth = 0.8
          ..style = PaintingStyle.stroke;
        canvas.drawLine(
          Offset(centerX + barW / 2, lineY),
          Offset(lineEnd, lineY),
          dashPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
