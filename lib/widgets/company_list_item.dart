import 'package:flutter/material.dart';
import '../models/company.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class CompanyListItem extends StatelessWidget {
  final Company company;
  final bool isSelected;
  final bool showCheckbox;
  final VoidCallback? onTap;
  final VoidCallback? onCheckToggle;

  const CompanyListItem({
    super.key,
    required this.company,
    this.isSelected = false,
    this.showCheckbox = false,
    this.onTap,
    this.onCheckToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.borderLight)),
        ),
        child: Row(
          children: [
            if (showCheckbox) ...[
              GestureDetector(
                onTap: onCheckToggle,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.brand : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? AppColors.brand : AppColors.border,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 12, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 12),
            ],
            // Logo
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: company.color,
                borderRadius: BorderRadius.circular(AppTheme.radius),
              ),
              alignment: Alignment.center,
              child: Text(
                company.initials,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    company.name,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${company.industry} · ${company.region}',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSub),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    company.bizNo,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Metrics
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _MetricRow(label: '매출', value: company.revenueFormatted, growth: company.revenueGrowth),
                const SizedBox(height: 1),
                _MetricRow(label: '영업이익', value: company.profitFormatted, growth: company.profitGrowth),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;
  final double growth;

  const _MetricRow({required this.label, required this.value, required this.growth});

  @override
  Widget build(BuildContext context) {
    final isPositive = growth >= 0 && growth != -999;
    final growthText = growth == -999
        ? ''
        : '${isPositive ? '▲' : '▼'} ${growth.abs().toStringAsFixed(1)}%';
    final growthColor = isPositive ? AppColors.emerald600 : AppColors.red600;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
        if (growthText.isNotEmpty) ...[
          const SizedBox(width: 3),
          Text(
            growthText,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: growthColor),
          ),
        ],
      ],
    );
  }
}
