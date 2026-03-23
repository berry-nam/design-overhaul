import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

class AreaChartWidget extends StatelessWidget {
  final List<String> labels;
  final List<double> values;
  final List<double>? secondaryValues;
  final Color primaryColor;
  final Color? secondaryColor;
  final String? primaryLabel;
  final String? secondaryLabel;
  final double height;

  const AreaChartWidget({
    super.key,
    required this.labels,
    required this.values,
    this.secondaryValues,
    this.primaryColor = const Color(0xFF3B82F6),
    this.secondaryColor,
    this.primaryLabel,
    this.secondaryLabel,
    this.height = 300,
  });

  @override
  Widget build(BuildContext context) {
    if (labels.isEmpty || values.isEmpty) {
      return SizedBox(
        height: height,
        child: const Center(child: Text('No data')),
      );
    }

    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return CustomPaint(
            size: Size(constraints.maxWidth, height),
            painter: _AreaChartPainter(
              labels: labels,
              values: values,
              secondaryValues: secondaryValues,
              primaryColor: primaryColor,
              secondaryColor: secondaryColor ?? const Color(0xFF10B981),
              primaryLabel: primaryLabel,
              secondaryLabel: secondaryLabel,
              textColor: Theme.of(context).textTheme.bodyMedium?.color ??
                  const Color(0xFF374151),
            ),
          );
        },
      ),
    );
  }
}

class _AreaChartPainter extends CustomPainter {
  final List<String> labels;
  final List<double> values;
  final List<double>? secondaryValues;
  final Color primaryColor;
  final Color secondaryColor;
  final String? primaryLabel;
  final String? secondaryLabel;
  final Color textColor;

  _AreaChartPainter({
    required this.labels,
    required this.values,
    this.secondaryValues,
    required this.primaryColor,
    required this.secondaryColor,
    this.primaryLabel,
    this.secondaryLabel,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bool hasSecondary =
        secondaryValues != null && secondaryValues!.isNotEmpty;

    // Compute max
    double maxVal = values.fold(0.0, (a, b) => math.max(a, b));
    if (hasSecondary) {
      final secMax = secondaryValues!.fold(0.0, (a, b) => math.max(a, b));
      maxVal = math.max(maxVal, secMax);
    }
    if (maxVal == 0) maxVal = 1;
    final double niceMax = _niceNumber(maxVal);
    const int yTickCount = 5;

    // Layout
    const double legendHeight = 28;
    const double topPadding = 8;
    const double bottomPadding = 32;
    const double leftPadding = 56;
    const double rightPadding = 16;

    final double chartTop =
        hasSecondary ? legendHeight + topPadding : topPadding + 16;
    final double chartBottom = size.height - bottomPadding;
    final double chartLeft = leftPadding;
    final double chartRight = size.width - rightPadding;
    final double chartHeight = chartBottom - chartTop;
    final double chartWidth = chartRight - chartLeft;

    // Legend
    if (hasSecondary && primaryLabel != null && secondaryLabel != null) {
      _drawLegend(canvas, size, chartRight);
    }

    // Y-axis grid lines (dashed)
    for (int i = 0; i <= yTickCount; i++) {
      final double ratio = i / yTickCount;
      final double y = chartBottom - ratio * chartHeight;
      final double val = niceMax * ratio;

      _drawDashedLine(
        canvas,
        Offset(chartLeft, y),
        Offset(chartRight, y),
        Paint()
          ..color = const Color(0xFFE5E7EB)
          ..strokeWidth = 1,
        dashLength: 4,
        gapLength: 3,
      );

      final tp = _makeTextPainter(
          _formatNumber(val), textColor.withValues(alpha: 0.5), 10);
      tp.layout();
      tp.paint(canvas, Offset(chartLeft - tp.width - 8, y - tp.height / 2));
    }

    final int count = math.min(labels.length, values.length);
    if (count == 0) return;

    double xForIndex(int i) {
      if (count == 1) return chartLeft + chartWidth / 2;
      return chartLeft + (i / (count - 1)) * chartWidth;
    }

    double yForValue(double val) {
      return chartBottom - (val / niceMax) * chartHeight;
    }

    // Helper to build points and draw area + line
    void drawSeries(List<double> data, Color color, int dataCount) {
      if (dataCount == 0) return;

      final List<Offset> points = [];
      for (int i = 0; i < dataCount; i++) {
        points.add(Offset(xForIndex(i), yForValue(data[i])));
      }

      // Build smooth path
      final linePath = Path();
      linePath.moveTo(points[0].dx, points[0].dy);

      if (points.length > 1) {
        for (int i = 1; i < points.length; i++) {
          final p0 = points[i - 1];
          final p1 = points[i];
          final controlX1 = p0.dx + (p1.dx - p0.dx) * 0.4;
          final controlX2 = p0.dx + (p1.dx - p0.dx) * 0.6;
          linePath.cubicTo(controlX1, p0.dy, controlX2, p1.dy, p1.dx, p1.dy);
        }
      }

      // Area fill (gradient)
      if (points.length > 1) {
        final areaPath = Path.from(linePath);
        areaPath.lineTo(points.last.dx, chartBottom);
        areaPath.lineTo(points.first.dx, chartBottom);
        areaPath.close();

        final gradient = ui.Gradient.linear(
          Offset(0, chartTop),
          Offset(0, chartBottom),
          [color.withValues(alpha: 0.25), color.withValues(alpha: 0.02)],
        );
        canvas.drawPath(areaPath, Paint()..shader = gradient);
      }

      // Line
      canvas.drawPath(
        linePath,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );

      // Dots and value labels
      for (int i = 0; i < points.length; i++) {
        final p = points[i];

        // Outer dot
        canvas.drawCircle(p, 4, Paint()..color = color);
        // Inner dot
        canvas.drawCircle(p, 2, Paint()..color = Colors.white);

        // Value label
        final val = data[i];
        final valTp = _makeTextPainter(
            _formatNumber(val), textColor, 9,
            weight: FontWeight.w600);
        valTp.layout();
        valTp.paint(
            canvas, Offset(p.dx - valTp.width / 2, p.dy - valTp.height - 8));
      }
    }

    // Draw secondary first (behind)
    if (hasSecondary) {
      final secCount = math.min(count, secondaryValues!.length);
      drawSeries(secondaryValues!, secondaryColor, secCount);
    }

    // Draw primary
    drawSeries(values, primaryColor, count);

    // X-axis labels
    for (int i = 0; i < count; i++) {
      final tp = _makeTextPainter(
          labels[i], textColor.withValues(alpha: 0.6), 10);
      tp.layout();
      tp.paint(
          canvas, Offset(xForIndex(i) - tp.width / 2, chartBottom + 10));
    }
  }

  void _drawLegend(Canvas canvas, Size size, double chartRight) {
    const double dotSize = 8;
    const double gap = 6;
    const double itemGap = 16;

    final tp1 = _makeTextPainter(primaryLabel!, textColor, 11);
    tp1.layout();
    final tp2 = _makeTextPainter(secondaryLabel!, textColor, 11);
    tp2.layout();

    final double totalW =
        dotSize + gap + tp1.width + itemGap + dotSize + gap + tp2.width;
    double x = chartRight - totalW;
    const double y = 6;

    canvas.drawCircle(
      Offset(x + dotSize / 2, y + tp1.height / 2),
      dotSize / 2,
      Paint()..color = primaryColor,
    );
    x += dotSize + gap;
    tp1.paint(canvas, Offset(x, y));
    x += tp1.width + itemGap;

    canvas.drawCircle(
      Offset(x + dotSize / 2, y + tp2.height / 2),
      dotSize / 2,
      Paint()..color = secondaryColor,
    );
    x += dotSize + gap;
    tp2.paint(canvas, Offset(x, y));
  }

  void _drawDashedLine(Canvas canvas, Offset from, Offset to, Paint paint,
      {double dashLength = 4, double gapLength = 3}) {
    final double dx = to.dx - from.dx;
    final double dy = to.dy - from.dy;
    final double dist = math.sqrt(dx * dx + dy * dy);
    if (dist == 0) return;
    final double ux = dx / dist;
    final double uy = dy / dist;

    double traveled = 0;
    while (traveled < dist) {
      final double end = math.min(traveled + dashLength, dist);
      canvas.drawLine(
        Offset(from.dx + ux * traveled, from.dy + uy * traveled),
        Offset(from.dx + ux * end, from.dy + uy * end),
        paint,
      );
      traveled = end + gapLength;
    }
  }

  TextPainter _makeTextPainter(String text, Color color, double fontSize,
      {FontWeight weight = FontWeight.normal}) {
    return TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: fontSize, fontWeight: weight),
      ),
      textDirection: TextDirection.ltr,
    );
  }

  String _formatNumber(double val) {
    if (val.abs() >= 1e12) return '${(val / 1e12).toStringAsFixed(1)}조';
    if (val.abs() >= 1e8) return '${(val / 1e8).toStringAsFixed(0)}억';
    if (val.abs() >= 1e4) return '${(val / 1e4).toStringAsFixed(0)}만';
    if (val.abs() >= 1000) return '${(val / 1000).toStringAsFixed(1)}K';
    if (val == val.roundToDouble()) return val.toInt().toString();
    return val.toStringAsFixed(1);
  }

  double _niceNumber(double value) {
    if (value <= 0) return 1;
    final double exponent = (math.log(value) / math.ln10).floorToDouble();
    final double fraction = value / math.pow(10, exponent);
    double nice;
    if (fraction <= 1.5) {
      nice = 1.5;
    } else if (fraction <= 2.5) {
      nice = 2.5;
    } else if (fraction <= 5) {
      nice = 5;
    } else {
      nice = 10;
    }
    return nice * math.pow(10, exponent);
  }

  @override
  bool shouldRepaint(covariant _AreaChartPainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.secondaryValues != secondaryValues ||
        oldDelegate.labels != labels ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor;
  }
}
