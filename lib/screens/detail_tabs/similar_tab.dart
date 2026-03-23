import 'package:flutter/material.dart';
import '../../models/company.dart';
import '../../models/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/charts/horizontal_bar.dart';

class SimilarTab extends StatelessWidget {
  final Company company;
  const SimilarTab({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // ── 유사기업 목록 ──
        _Section(
          icon: Icons.hub,
          title: '유사기업 목록',
          trailing: '${similarCompanies.length}개사',
          child: Column(
            children: similarCompanies.map((sc) => _buildSimilarCard(sc)).toList(),
          ),
        ),

        // ── 매출 비교 ──
        _Section(
          icon: Icons.bar_chart,
          title: '매출 비교',
          child: HorizontalBarWidget(
            labels: similarCompanies.map((sc) => sc.name.length > 6 ? sc.name.substring(0, 6) : sc.name).toList(),
            values: similarCompanies.map((sc) => sc.revenue).toList(),
            colors: similarCompanies.map((sc) => sc.color).toList(),
            unit: '억',
            referenceLine: company.revenue,
            referenceLabel: '${company.name} ${company.revenue.toStringAsFixed(0)}억',
          ),
        ),

        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildSimilarCard(SimilarCompany sc) {
    final isGrowthPositive = sc.profitGrowth >= 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: sc.color,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                alignment: Alignment.center,
                child: Text(
                  sc.name.length >= 2 ? sc.name.substring(0, 2) : sc.name,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sc.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(sc.desc, style: const TextStyle(fontSize: 12, color: AppColors.textSub)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Chips
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: sc.chips.map((chip) {
              Color chipBg;
              Color chipText;
              if (chip == '동일 업종') {
                chipBg = AppColors.blue50;
                chipText = AppColors.brand;
              } else if (chip == '유사 규모') {
                chipBg = AppColors.emerald50;
                chipText = AppColors.emerald600;
              } else if (chip == '같은 지역') {
                chipBg = AppColors.amber50;
                chipText = AppColors.amber600;
              } else if (chip == '유사 매출') {
                chipBg = AppColors.purple50;
                chipText = AppColors.purple500;
              } else {
                chipBg = AppColors.slate50;
                chipText = AppColors.textSub;
              }
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: chipBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(chip, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: chipText)),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          // Revenue & Profit
          Row(
            children: [
              const Text('매출 ', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
              Text('${sc.revenue.toStringAsFixed(0)}억', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(width: 16),
              const Text('영업이익 ', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
              Text('${sc.profit.toStringAsFixed(0)}억', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const Spacer(),
              Icon(
                isGrowthPositive ? Icons.trending_up : Icons.trending_down,
                size: 14,
                color: isGrowthPositive ? AppColors.emerald600 : AppColors.red500,
              ),
              const SizedBox(width: 2),
              Text(
                '${isGrowthPositive ? '+' : ''}${sc.profitGrowth.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isGrowthPositive ? AppColors.emerald600 : AppColors.red500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailing;
  final Widget child;

  const _Section({required this.icon, required this.title, this.trailing, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.slate50, width: 8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.brand),
              const SizedBox(width: 6),
              Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              if (trailing != null) ...[
                const Spacer(),
                Text(trailing!, style: const TextStyle(fontSize: 12, color: AppColors.textSub, fontWeight: FontWeight.w500)),
              ],
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
