import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

class HorizontalBarWidget extends StatelessWidget {
  final List<String> labels;
  final List<double> values;
  final List<Color> colors;
  final String? unit;
  final double? referenceLine;
  final String? referenceLabel;
  final double barHeight;

  const HorizontalBarWidget({
    super.key,
    required this.labels,
    required this.values,
    required this.colors,
    this.unit,
    this.referenceLine,
    this.referenceLabel,
    this.barHeight = 24,
  });

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return const SizedBox.shrink();

    double maxVal = 0;
    for (final v in values) {
      if (v > maxVal) maxVal = v;
    }
    if (referenceLine != null && referenceLine! > maxVal) {
      maxVal = referenceLine!;
    }
    if (maxVal == 0) maxVal = 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < values.length; i++) ...[
          Padding(
            padding: EdgeInsets.only(top: i == 0 ? 0 : 8),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    labels[i],
                    style: const TextStyle(fontSize: 12, color: AppColors.text, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final availableW = constraints.maxWidth;
                      return Stack(
                        children: [
                          Container(
                            height: barHeight,
                            decoration: BoxDecoration(
                              color: AppColors.slate50,
                              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                            ),
                          ),
                          Container(
                            width: availableW * (values[i] / maxVal).clamp(0, 1),
                            height: barHeight,
                            decoration: BoxDecoration(
                              color: colors[i % colors.length],
                              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                            ),
                          ),
                          if (referenceLine != null)
                            Positioned(
                              left: availableW * (referenceLine! / maxVal).clamp(0, 1),
                              top: 0,
                              bottom: 0,
                              child: Container(
                                width: 2,
                                color: AppColors.red500.withValues(alpha: 0.6),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 42,
                  child: Text(
                    '${values[i].toStringAsFixed(0)}${unit ?? ''}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.text),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ],
        if (referenceLabel != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Container(width: 12, height: 2, color: AppColors.red500.withValues(alpha: 0.6)),
                const SizedBox(width: 4),
                Text(
                  referenceLabel!,
                  style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
