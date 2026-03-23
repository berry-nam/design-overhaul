import 'package:flutter/material.dart';
import '../../models/company.dart';
import '../../models/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/charts/area_chart.dart';
import '../../widgets/charts/bar_chart.dart';
import '../../widgets/charts/horizontal_bar.dart';

class FinanceTab extends StatefulWidget {
  final Company company;
  const FinanceTab({super.key, required this.company});

  @override
  State<FinanceTab> createState() => _FinanceTabState();
}

class _FinanceTabState extends State<FinanceTab> {
  // F2 toggle
  String _ratioKey = 'OPM';
  // F3 toggle
  String _plMode = 'net'; // 'net' | 'op'
  // F9/F10 expansion
  bool _incomeExpanded = true;
  bool _balanceExpanded = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const PageStorageKey('finance'),
      padding: EdgeInsets.zero,
      children: [
        // ── F1. 투자 지표 ──
        _Section(
          icon: Icons.trending_up,
          title: '투자 지표',
          child: _buildInvestmentMetrics(),
        ),

        // ── F2. 핵심 재무 비율 ──
        _Section(
          icon: Icons.bar_chart,
          title: '핵심 재무 비율',
          child: _buildCoreRatios(),
        ),

        // ── F3. 손익 추이 ──
        _Section(
          icon: Icons.monetization_on,
          title: '손익 추이',
          child: _buildProfitLossTrend(),
        ),

        // ── F4. 재무 추이 ──
        _Section(
          icon: Icons.stacked_bar_chart,
          title: '재무 추이',
          child: BarChartWidget(
            dataSets: [revenueHistory, profitHistory, netProfitHistory],
            colors: const [AppColors.brand, AppColors.emerald500, AppColors.amber500],
            labels: years,
            legends: const ['매출액', '영업이익', '순이익'],
            height: 200,
          ),
        ),

        // ── F5. 공급망 상세 ──
        _Section(
          icon: Icons.link,
          title: '공급망 상세',
          child: _buildSupplyChain(),
        ),

        // ── F6. 재무 건전성 ──
        _Section(
          icon: Icons.shield,
          title: '재무 건전성',
          child: _buildFinancialHealth(),
        ),

        // ── F7. 안정성 ──
        _Section(
          icon: Icons.trending_down,
          title: '안정성',
          child: _buildStability(),
        ),

        // ── F8. 현금흐름 ──
        _Section(
          icon: Icons.account_balance_wallet,
          title: '현금흐름',
          child: _buildCashFlow(),
        ),

        // ── F9. 손익계산서 ──
        _Section(
          icon: Icons.description,
          title: '손익계산서',
          child: _buildIncomeStatement(),
        ),

        // ── F10. 재무상태표 ──
        _Section(
          icon: Icons.description_outlined,
          title: '재무상태표',
          child: _buildBalanceSheet(),
        ),

        const SizedBox(height: 100),
      ],
    );
  }

  // ────────────────────────────────────────────
  // F1. 투자 지표 — 2x3 metric grid
  // ────────────────────────────────────────────
  Widget _buildInvestmentMetrics() {
    const metrics = [
      _MetricItem(label: '시가총액(추정)', value: '1,200억'),
      _MetricItem(label: '배당률', value: '1.2%'),
      _MetricItem(label: 'PBR', value: '2.4x'),
      _MetricItem(label: 'PER', value: '18.5x'),
      _MetricItem(label: 'ROE', value: '11.1%', isPositive: true),
      _MetricItem(label: 'PSR', value: '3.5x'),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 2.2,
      children: metrics.map((m) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.slate50,
            borderRadius: BorderRadius.circular(AppTheme.radius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                m.label,
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 2),
              Text(
                m.value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: m.isPositive ? AppColors.emerald600 : AppColors.text,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ────────────────────────────────────────────
  // F2. 핵심 재무 비율
  // ────────────────────────────────────────────
  Widget _buildCoreRatios() {
    final metric = valuationMetrics[_ratioKey]!;
    final latestValue = '${metric.values.last}${metric.unit}';
    final diff = metric.values.last - metric.values[metric.values.length - 2];
    final diffSign = diff >= 0 ? '+' : '';
    final diffStr = '$diffSign${diff.toStringAsFixed(1)}%p';
    final isUp = diff >= 0;
    // For debt ratio, down is good
    final isGood = _ratioKey == 'DEBT' ? !isUp : isUp;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Toggle buttons
        _buildToggleRow(
          items: const ['OPM', 'NPM', 'DEBT', 'ROE'],
          labels: const ['영업이익률', '순이익률', '부채비율', 'ROE'],
          selected: _ratioKey,
          onTap: (key) => setState(() => _ratioKey = key),
        ),
        const SizedBox(height: 12),

        // Current value display
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '${metric.label} (${metric.years.last})',
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
            const SizedBox(width: 6),
            Text(
              latestValue,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.text),
            ),
            const SizedBox(width: 6),
            Text(
              '${isUp ? "\u25B2" : "\u25BC"} $diffStr',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isGood ? AppColors.emerald600 : AppColors.red600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // 3-year horizontal bars
        HorizontalBarWidget(
          labels: metric.years,
          values: metric.values,
          colors: const [AppColors.blue200, AppColors.blue300, AppColors.brand],
          unit: metric.unit,
        ),
        const SizedBox(height: 8),

        // AI insight card
        _AiInsightCard(text: metric.insight),
      ],
    );
  }

  // ────────────────────────────────────────────
  // F3. 손익 추이
  // ────────────────────────────────────────────
  Widget _buildProfitLossTrend() {
    final isNet = _plMode == 'net';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildToggleRow(
          items: const ['net', 'op'],
          labels: const ['순이익', '영업이익'],
          selected: _plMode,
          onTap: (key) => setState(() => _plMode = key),
        ),
        const SizedBox(height: 12),
        AreaChartWidget(
          labels: years,
          values: revenueHistory,
          secondaryValues: isNet ? netProfitHistory : profitHistory,
          primaryColor: AppColors.brand,
          secondaryColor: isNet ? AppColors.amber500 : AppColors.emerald500,
          primaryLabel: '매출액',
          secondaryLabel: isNet ? '순이익' : '영업이익',
          height: 220,
        ),
      ],
    );
  }

  // ────────────────────────────────────────────
  // F5. 공급망 상세
  // ────────────────────────────────────────────
  Widget _buildSupplyChain() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 구매처 테이블
        _buildSupplyTable(
          header: '구매처',
          columns: const ['구매처', '비중', '품목'],
          rows: const [
            ['도쿄정밀', '32%', '정밀부품'],
            ['한국소재', '25%', '소재'],
            ['글로벌테크', '20%', '부품'],
          ],
        ),
        const SizedBox(height: 10),

        // 판매처 테이블
        _buildSupplyTable(
          header: '판매처',
          columns: const ['판매처', '비중', '관계'],
          rows: const [
            ['삼성전자', '35%', '주요 고객'],
            ['SK하이닉스', '28%', '주요 고객'],
            ['마이크론', '18%', '해외 고객'],
          ],
        ),
        const SizedBox(height: 10),

        // 집중도 grid
        Row(
          children: [
            Expanded(child: _buildHealthCard(label: '구매 집중도', value: '상위3사 77%')),
            const SizedBox(width: 8),
            Expanded(child: _buildHealthCard(label: '판매 집중도', value: '상위3사 81%')),
          ],
        ),
      ],
    );
  }

  Widget _buildSupplyTable({
    required String header,
    required List<String> columns,
    required List<List<String>> rows,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppTheme.radius),
        ),
        child: DataTable(
          headingRowHeight: 36,
          dataRowMinHeight: 32,
          dataRowMaxHeight: 36,
          columnSpacing: 24,
          horizontalMargin: 12,
          headingTextStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSub,
            fontFamily: 'Pretendard',
          ),
          dataTextStyle: const TextStyle(
            fontSize: 12,
            color: AppColors.text,
            fontFamily: 'Pretendard',
          ),
          columns: columns.map((c) => DataColumn(label: Text(c))).toList(),
          rows: rows
              .map((r) => DataRow(
                    cells: r.map((cell) => DataCell(Text(cell))).toList(),
                  ))
              .toList(),
        ),
      ),
    );
  }

  // ────────────────────────────────────────────
  // F6. 재무 건전성
  // ────────────────────────────────────────────
  Widget _buildFinancialHealth() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.4,
      children: [
        _buildHealthGradeCard(grade: 'A', gradeColor: AppColors.emerald600, label: '신용평가', sub: '한국기업데이터'),
        _buildHealthGradeCard(grade: 'A+', gradeColor: AppColors.brand, label: '현금흐름등급', sub: '안정적'),
        _buildHealthGradeCard(grade: '185%', gradeColor: AppColors.text, label: '유동비율', sub: '양호'),
        _buildHealthGradeCard(grade: '4.2x', gradeColor: AppColors.text, label: '이자보상배율', sub: '안정적'),
      ],
    );
  }

  Widget _buildHealthGradeCard({
    required String grade,
    required Color gradeColor,
    required String label,
    required String sub,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.slate50,
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(grade, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: gradeColor)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
          const SizedBox(height: 2),
          Text(sub, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.text)),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────
  // F7. 안정성
  // ────────────────────────────────────────────
  Widget _buildStability() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AreaChartWidget(
          labels: years,
          values: debtRatioHistory,
          primaryColor: AppColors.brand,
          primaryLabel: '부채비율',
          height: 180,
        ),
        const SizedBox(height: 8),
        const _AiInsightCard(
          text: '부채비율이 5년간 85% \u2192 65%로 꾸준히 감소하여 재무 안정성이 개선되고 있습니다',
        ),
      ],
    );
  }

  // ────────────────────────────────────────────
  // F8. 현금흐름
  // ────────────────────────────────────────────
  Widget _buildCashFlow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 2-col health cards
        Row(
          children: [
            Expanded(
              child: _buildHealthGradeCard(
                grade: 'A+',
                gradeColor: AppColors.brand,
                label: '현금흐름 등급',
                sub: '',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildHealthGradeCard(
                grade: '3,600',
                gradeColor: AppColors.emerald600,
                label: '영업활동 (백만)',
                sub: '',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        BarChartWidget(
          dataSets: [
            const [3200.0, 3400.0, 3600.0, 3500.0, 3600.0],
            const [-1500.0, -1600.0, -1800.0, -1700.0, -1800.0],
            const [-800.0, -700.0, -900.0, -750.0, -800.0],
          ],
          colors: const [AppColors.emerald500, AppColors.red500, AppColors.amber500],
          labels: years,
          legends: const ['영업', '투자', '재무'],
          height: 180,
        ),
      ],
    );
  }

  // ────────────────────────────────────────────
  // F9. 손익계산서 (collapsible)
  // ────────────────────────────────────────────
  Widget _buildIncomeStatement() {
    return _CollapsibleTable(
      triggerLabel: '손익계산서',
      isExpanded: _incomeExpanded,
      onToggle: () => setState(() => _incomeExpanded = !_incomeExpanded),
      headers: const ['항목', '2023', '2024', '2025'],
      rows: const [
        ['매출액', '31,000', '32,800', '34,200'],
        ['매출원가', '22,320', '23,370', '24,330'],
        ['매출총이익', '8,680', '9,430', '9,870'],
        ['판관비', '6,480', '6,930', '7,070'],
        ['영업이익', '2,200', '2,500', '2,800'],
        ['당기순이익', '1,500', '1,800', '2,000'],
      ],
      positiveIndices: const {
        // row, col indices for positive highlight
        (0, 3), (2, 3), (4, 3), (5, 3),
      },
    );
  }

  // ────────────────────────────────────────────
  // F10. 재무상태표 (collapsible)
  // ────────────────────────────────────────────
  Widget _buildBalanceSheet() {
    return _CollapsibleTable(
      triggerLabel: '재무상태표',
      isExpanded: _balanceExpanded,
      onToggle: () => setState(() => _balanceExpanded = !_balanceExpanded),
      headers: const ['항목', '2023', '2024', '2025'],
      rows: const [
        ['자산총계', '61,000', '67,000', '72,000'],
        ['유동자산', '28,000', '31,000', '34,000'],
        ['비유동자산', '33,000', '36,000', '38,000'],
        ['부채총계', '25,600', '26,500', '27,700'],
        ['자본총계', '35,400', '40,500', '44,300'],
      ],
      positiveIndices: const {(4, 3)},
    );
  }

  // ────────────────────────────────────────────
  // Shared: toggle row builder
  // ────────────────────────────────────────────
  Widget _buildToggleRow({
    required List<String> items,
    required List<String> labels,
    required String selected,
    required ValueChanged<String> onTap,
  }) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: List.generate(items.length, (i) {
        final isActive = items[i] == selected;
        return GestureDetector(
          onTap: () => onTap(items[i]),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: isActive ? AppColors.slate800 : Colors.white,
              border: Border.all(color: isActive ? AppColors.slate800 : AppColors.border),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
            child: Text(
              labels[i],
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive ? Colors.white : AppColors.textSub,
              ),
            ),
          ),
        );
      }),
    );
  }

  // ────────────────────────────────────────────
  // Shared: simple health card
  // ────────────────────────────────────────────
  Widget _buildHealthCard({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.slate50,
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.text)),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// _Section — reusable section wrapper
// ═══════════════════════════════════════════════
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

// ═══════════════════════════════════════════════
// _AiInsightCard
// ═══════════════════════════════════════════════
class _AiInsightCard extends StatelessWidget {
  final String text;
  const _AiInsightCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.purple50, AppColors.blue50],
        ),
        border: Border.all(color: AppColors.blue200),
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.brand,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'AI \uBD84\uC11D',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, height: 1.6, color: AppColors.textSub),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// _MetricItem — data holder for investment metrics
// ═══════════════════════════════════════════════
class _MetricItem {
  final String label;
  final String value;
  final bool isPositive;
  const _MetricItem({required this.label, required this.value, this.isPositive = false});
}

// ═══════════════════════════════════════════════
// _CollapsibleTable — expandable financial table
// ═══════════════════════════════════════════════
class _CollapsibleTable extends StatelessWidget {
  final String triggerLabel;
  final bool isExpanded;
  final VoidCallback onToggle;
  final List<String> headers;
  final List<List<String>> rows;
  final Set<(int, int)> positiveIndices;

  const _CollapsibleTable({
    required this.triggerLabel,
    required this.isExpanded,
    required this.onToggle,
    required this.headers,
    required this.rows,
    this.positiveIndices = const {},
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Icon(
                  isExpanded ? Icons.keyboard_arrow_down : Icons.chevron_right,
                  size: 18,
                  color: AppColors.brand,
                ),
                const SizedBox(width: 4),
                Text(
                  '${isExpanded ? "" : ""}$triggerLabel ${isExpanded ? "접기" : "보기"}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.brand),
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(AppTheme.radius),
                ),
                child: DataTable(
                  headingRowHeight: 36,
                  dataRowMinHeight: 32,
                  dataRowMaxHeight: 36,
                  columnSpacing: 20,
                  horizontalMargin: 12,
                  headingTextStyle: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSub,
                    fontFamily: 'Pretendard',
                  ),
                  dataTextStyle: const TextStyle(
                    fontSize: 12,
                    color: AppColors.text,
                    fontFamily: 'Pretendard',
                  ),
                  columns: headers.map((h) => DataColumn(label: Text(h))).toList(),
                  rows: List.generate(rows.length, (rowIdx) {
                    final row = rows[rowIdx];
                    return DataRow(
                      cells: List.generate(row.length, (colIdx) {
                        final isPositive = positiveIndices.contains((rowIdx, colIdx));
                        return DataCell(
                          Text(
                            row[colIdx],
                            style: isPositive
                                ? const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.emerald600,
                                    fontFamily: 'Pretendard',
                                  )
                                : null,
                          ),
                        );
                      }),
                    );
                  }),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
