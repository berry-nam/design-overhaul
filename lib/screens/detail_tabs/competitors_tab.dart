import 'package:flutter/material.dart';
import '../../models/company.dart';
import '../../models/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/charts/radar_chart.dart';
import '../../widgets/charts/horizontal_bar.dart';

class CompetitorsTab extends StatelessWidget {
  final Company company;
  const CompetitorsTab({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // ── 경쟁사 비교 레이더 ──
        _Section(
          icon: Icons.gps_fixed,
          title: '경쟁사 비교 레이더',
          child: RadarChartWidget(
            axes: const ['매출', '영업이익률', '성장률', '인원', '설립연도', '재무건전성'],
            dataSets: _buildRadarData(),
            colors: competitors.map((c) => c.color).toList(),
            legends: competitors.map((c) => c.name.length > 6 ? c.name.substring(0, 6) : c.name).toList(),
            height: 280,
            backgroundColor: const Color(0xFF1F2937),
          ),
        ),

        // ── 핵심지표 비교 ──
        _Section(
          icon: Icons.bar_chart,
          title: '핵심지표 비교',
          child: Row(
            children: const [
              Expanded(child: _CompactMetric(label: '시장점유율', value: '~8%')),
              SizedBox(width: 8),
              Expanded(child: _CompactMetric(label: '매출순위', value: '3위/5개사')),
              SizedBox(width: 8),
              Expanded(child: _CompactMetric(label: '영업이익률', value: '8.2%')),
            ],
          ),
        ),

        // ── 매출 비교 바 ──
        _Section(
          icon: Icons.trending_up,
          title: '매출 비교',
          child: HorizontalBarWidget(
            labels: competitors.map((c) => c.name.length > 6 ? c.name.substring(0, 6) : c.name).toList(),
            values: competitors.map((c) => c.revenue).toList(),
            colors: competitors.map((c) => c.color).toList(),
            unit: '억',
          ),
        ),

        // ── 영업이익 비교 바 ──
        _Section(
          icon: Icons.payments,
          title: '영업이익 비교',
          child: HorizontalBarWidget(
            labels: competitors.map((c) => c.name.length > 6 ? c.name.substring(0, 6) : c.name).toList(),
            values: competitors.map((c) => c.profit).toList(),
            colors: competitors.map((c) => c.color).toList(),
            unit: '억',
          ),
        ),

        // ── 비교 테이블 ──
        _Section(
          icon: Icons.table_chart,
          title: '비교 테이블',
          child: _buildComparisonTable(),
        ),

        const SizedBox(height: 100),
      ],
    );
  }

  List<List<double>> _buildRadarData() {
    // Normalize values to 0-1 range across all competitors
    double maxRevenue = 0, maxProfitRate = 0, maxGrowth = 0, maxEmployees = 0, maxYear = 0, maxDebt = 0;
    for (final c in competitors) {
      if (c.revenue > maxRevenue) maxRevenue = c.revenue;
      if (c.profitRate > maxProfitRate) maxProfitRate = c.profitRate;
      if (c.growth > maxGrowth) maxGrowth = c.growth;
      if (c.employees > maxEmployees) maxEmployees = c.employees.toDouble();
      if (c.year > maxYear) maxYear = c.year.toDouble();
      if (c.debt > maxDebt) maxDebt = c.debt;
    }
    if (maxRevenue == 0) maxRevenue = 1;
    if (maxProfitRate == 0) maxProfitRate = 1;
    if (maxGrowth == 0) maxGrowth = 1;
    if (maxEmployees == 0) maxEmployees = 1;
    if (maxDebt == 0) maxDebt = 1;

    return competitors.map((c) {
      return [
        c.revenue / maxRevenue,
        c.profitRate / maxProfitRate,
        c.growth / maxGrowth,
        c.employees / maxEmployees,
        // For foundedYear, older = higher. Normalize inversely.
        1.0 - ((c.year - 2000) / 20).clamp(0, 1),
        // For debt, lower = better, so invert.
        1.0 - (c.debt / 100).clamp(0, 1),
      ];
    }).toList();
  }

  Widget _buildComparisonTable() {
    final headers = ['기업명', '매출', '영업이익', '영업이익률', '인원', '성장률', '부채비율'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppTheme.radius),
        ),
        child: DataTable(
          headingRowHeight: 36,
          dataRowMinHeight: 36,
          dataRowMaxHeight: 40,
          columnSpacing: 16,
          horizontalMargin: 12,
          headingTextStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSub, fontFamily: 'Pretendard'),
          dataTextStyle: const TextStyle(fontSize: 12, color: AppColors.text, fontFamily: 'Pretendard'),
          columns: headers.map((h) => DataColumn(label: Text(h))).toList(),
          rows: competitors.map((c) {
            final isTarget = c.isTarget;
            final cellStyle = TextStyle(
              fontSize: 12,
              color: isTarget ? AppColors.brand : AppColors.text,
              fontWeight: isTarget ? FontWeight.w700 : FontWeight.w400,
              fontFamily: 'Pretendard',
            );
            return DataRow(
              color: WidgetStateProperty.resolveWith<Color?>((states) {
                return isTarget ? AppColors.blue50 : null;
              }),
              cells: [
                DataCell(Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(color: c.color, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 4),
                    Text(c.name, style: cellStyle),
                  ],
                )),
                DataCell(Text('${c.revenue.toStringAsFixed(0)}억', style: cellStyle)),
                DataCell(Text('${c.profit.toStringAsFixed(0)}억', style: cellStyle)),
                DataCell(Text('${c.profitRate.toStringAsFixed(1)}%', style: cellStyle)),
                DataCell(Text('${c.employees}명', style: cellStyle)),
                DataCell(Text('+${c.growth.toStringAsFixed(1)}%', style: cellStyle.copyWith(
                  color: AppColors.emerald600,
                ))),
                DataCell(Text('${c.debt.toStringAsFixed(0)}%', style: cellStyle)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _Section({required this.icon, required this.title, required this.child});

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
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _CompactMetric extends StatelessWidget {
  final String label;
  final String value;

  const _CompactMetric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.slate50,
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.text)),
        ],
      ),
    );
  }
}
