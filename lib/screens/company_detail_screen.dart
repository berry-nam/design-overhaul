import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/company.dart';
import '../models/company_list_group.dart';
import '../models/mock_data.dart' as mock;
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/charts/area_chart.dart';
import '../widgets/charts/donut_chart.dart';
import '../widgets/charts/waterfall_chart.dart';
import 'detail_tabs/finance_tab.dart';
import 'detail_tabs/people_tab.dart';
import 'detail_tabs/similar_tab.dart';
import 'detail_tabs/competitors_tab.dart';
import 'detail_tabs/news_tab.dart';
import 'detail_tabs/community_tab.dart';

class CompanyDetailScreen extends StatefulWidget {
  final Company company;

  const CompanyDetailScreen({super.key, required this.company});

  @override
  State<CompanyDetailScreen> createState() => _CompanyDetailScreenState();
}

class _CompanyDetailScreenState extends State<CompanyDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isSaved = false;
  bool _isNotified = false;

  final _tabs = const ['개요', '재무', '인물', '유사기업', '경쟁사', '뉴스', '커뮤니티'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Company get c => widget.company;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(),
                  _buildFinanceTab(),
                  _buildPeopleTab(),
                  _buildSimilarTab(),
                  _buildCompetitorsTab(),
                  _buildNewsTab(),
                  _buildCommunityTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomCta(),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: AppColors.brand,
        unselectedLabelColor: AppColors.textSub,
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Pretendard'),
        unselectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, fontFamily: 'Pretendard'),
        indicatorColor: AppColors.brand,
        indicatorWeight: 2,
        tabAlignment: TabAlignment.start,
        dividerColor: AppColors.border,
        tabs: _tabs.map((t) => Tab(text: t)).toList(),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const SizedBox(
              width: 40, height: 40,
              child: Center(child: Icon(Icons.arrow_back_ios_new, size: 18)),
            ),
          ),
          Expanded(
            child: Text(
              c.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_horiz, size: 22, color: AppColors.textSub),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onSelected: (value) {
              switch (value) {
                case 'share':
                  _shareCompany();
                case 'export':
                  _showExportSheet();
                case 'save':
                  setState(() => _isSaved = !_isSaved);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_isSaved ? '저장되었습니다' : '저장이 해제되었습니다'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  );
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.ios_share, size: 18, color: AppColors.textSub),
                    SizedBox(width: 10),
                    Text('공유', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.download, size: 18, color: AppColors.textSub),
                    SizedBox(width: 10),
                    Text('내보내기', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'save',
                child: Row(
                  children: [
                    Icon(
                      _isSaved ? Icons.favorite : Icons.favorite_border,
                      size: 18,
                      color: _isSaved ? AppColors.red500 : AppColors.textSub,
                    ),
                    const SizedBox(width: 10),
                    Text(_isSaved ? '저장 해제' : '저장하기', style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Column(
        children: [
          // Logo
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: c.color,
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              boxShadow: [AppTheme.shadowMd],
            ),
            alignment: Alignment.center,
            child: Text(
              c.initials,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          // Name
          Text(c.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
          const SizedBox(height: 6),
          // Badges
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Badge(label: '✓ 검증됨', bgColor: AppColors.blue50, textColor: AppColors.brand),
              const SizedBox(width: 6),
              _Badge(label: '✦ AI 분석', bgColor: AppColors.purple50, textColor: AppColors.purple500),
            ],
          ),
          const SizedBox(height: 6),
          // Meta
          Text(
            '${c.industry} · ${c.region} · ${c.foundedYear} 설립 · 비상장 · ${c.bizNo}',
            style: const TextStyle(fontSize: 12, color: AppColors.textSub),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMetrics() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _MetricCard(label: '매출액', value: '${c.revenue.toInt()}', unit: '억', growth: '▲ +${c.revenueGrowth}% YoY', isPositive: true)),
              const SizedBox(width: 8),
              Expanded(child: _MetricCard(label: '영업이익', value: '${c.profit.toInt()}', unit: '억', growth: '▲ +${c.profitGrowth}% YoY', isPositive: c.isProfitable)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Expanded(child: _MetricCard(label: '순이익', value: '20', unit: '억', growth: '▲ +11.1% YoY', isPositive: true)),
              const SizedBox(width: 8),
              const Expanded(child: _MetricCard(label: '부채비율', value: '65', unit: '%', growth: '▼ -3%p YoY', isPositive: true)),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // ── CTA Actions ──

  void _showAddToListSheet() {
    final checked = <int>{};
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.sheetRadius)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(ctx).padding.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('리스트에 추가', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              ...defaultGroups.asMap().entries.map((entry) {
                final i = entry.key;
                final g = entry.value;
                return GestureDetector(
                  onTap: () => setSheetState(() {
                    if (checked.contains(i)) {
                      checked.remove(i);
                    } else {
                      checked.add(i);
                    }
                  }),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 20, height: 20,
                          decoration: BoxDecoration(
                            color: checked.contains(i) ? AppColors.brand : Colors.transparent,
                            border: Border.all(color: checked.contains(i) ? AppColors.brand : AppColors.border, width: 2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: checked.contains(i) ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
                        ),
                        const SizedBox(width: 12),
                        Container(width: 8, height: 8, decoration: BoxDecoration(color: g.color, shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(g.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                              Text(g.desc, style: const TextStyle(fontSize: 12, color: AppColors.textSub)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: checked.isEmpty ? null : () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${checked.length}개 리스트에 추가되었습니다'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brand,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.slate200,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusLg)),
                  ),
                  child: Text('추가 (${checked.length}개 선택)', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _shareCompany() {
    SharePlus.instance.share(
      ShareParams(
        text: '${c.name} - ${c.industry} | 매출 ${c.revenueFormatted} · 영업이익 ${c.profitFormatted}\nhttps://cookiedeal.co.kr/company/${c.bizNo}',
      ),
    );
  }

  void _showExportSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.sheetRadius)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(ctx).padding.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('내보내기', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            _ExportOption(icon: Icons.picture_as_pdf, label: 'PDF로 내보내기', onTap: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: const Text('PDF 내보내기 준비 중...'), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              );
            }),
            _ExportOption(icon: Icons.table_chart, label: 'Excel로 내보내기', onTap: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: const Text('Excel 내보내기 준비 중...'), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              );
            }),
            _ExportOption(icon: Icons.image, label: '이미지로 저장', onTap: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: const Text('이미지 저장 준비 중...'), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              );
            }),
          ],
        ),
      ),
    );
  }

  // ── Tab Content Builders ──

  void _navigateToTab(int index) {
    _tabController.animateTo(index);
  }

  Widget _buildOverviewTab() {
    return ListView(
      key: const PageStorageKey('overview'),
      padding: EdgeInsets.zero,
      children: [
        _buildHero(),
        _buildMetrics(),

        // 1. 매출·영업이익 추이
        _Section(
          icon: Icons.show_chart,
          title: '매출 · 영업이익 추이',
          trailing: '단위: 억원 · 상세보기 →',
          onTrailingTap: () => _navigateToTab(1),
          child: AreaChartWidget(
            labels: mock.years,
            values: mock.revenueHistory,
            secondaryValues: mock.profitHistory,
            primaryColor: AppColors.brand,
            secondaryColor: AppColors.amber500,
            primaryLabel: '매출액',
            secondaryLabel: '영업이익',
            height: 200,
          ),
        ),

        // 2. 재무 요약
        _Section(
          icon: Icons.table_chart,
          title: '재무 요약',
          trailing: '상세보기 →',
          onTrailingTap: () => _navigateToTab(1),
          child: _buildFinanceSummaryTable(),
        ),

        // 3. 매출 구성 (NEW)
        _Section(
          icon: Icons.bar_chart,
          title: '매출 구성',
          trailing: '단위: 억원 · 상세보기 →',
          onTrailingTap: () => _navigateToTab(1),
          child: WaterfallChartWidget(
            data: mock.waterfallData['2024'] ?? [],
            height: 200,
          ),
        ),

        // 4. 주요 구매처·판매처
        _Section(
          icon: Icons.hub,
          title: '주요 구매처 · 판매처',
          trailing: '상세보기 →',
          onTrailingTap: () => _navigateToTab(1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SupplyGroup(title: '구매처', color: AppColors.emerald600, items: const [
                ('도쿄정밀', '32%'), ('한국소재', '25%'), ('글로벌테크', '20%'),
              ]),
              const SizedBox(height: 12),
              _SupplyGroup(title: '판매처', color: AppColors.brand, items: const [
                ('삼성전자', '35%'), ('SK하이닉스', '28%'), ('마이크론', '18%'),
              ]),
            ],
          ),
        ),

        // 5. 주주현황
        _Section(
          icon: Icons.group,
          title: '주주현황',
          trailing: '상세보기 →',
          onTrailingTap: () => _navigateToTab(2),
          child: DonutChartWidget(
            labels: mock.shareholders.map((s) => s.label).toList(),
            values: mock.shareholders.map((s) => s.pct).toList(),
            colors: mock.shareholders.map((s) => s.color).toList(),
            centerLabel: '주주현황',
            centerValue: '${mock.shareholders.length}명',
            size: 160,
          ),
        ),

        // 6. 경영진 (NEW)
        _Section(
          icon: Icons.work_outline,
          title: '경영진',
          trailing: '상세보기 →',
          onTrailingTap: () => _navigateToTab(2),
          child: _buildExecutivePreview(),
        ),

        // 7. 인원현황
        _Section(
          icon: Icons.person,
          title: '인원현황',
          child: Column(
            children: [
              AreaChartWidget(
                labels: mock.years,
                values: mock.employeeHistory,
                primaryColor: AppColors.emerald500,
                primaryLabel: '인원수',
                height: 160,
              ),
              const SizedBox(height: 8),
              Row(
                children: const [
                  Expanded(child: _MiniMetric(label: '총 인원', value: '187명')),
                  SizedBox(width: 8),
                  Expanded(child: _MiniMetric(label: '전년 대비', value: '+8%', isPositive: true)),
                  SizedBox(width: 8),
                  Expanded(child: _MiniMetric(label: '평균 근속', value: '4.2년')),
                ],
              ),
            ],
          ),
        ),

        // 8. 기술·특허 (NEW)
        _Section(
          icon: Icons.lightbulb_outline,
          title: '기술 · 특허',
          trailing: '5건',
          child: _buildTechPatents(),
        ),

        // 9. 최신 뉴스 (NEW)
        _Section(
          icon: Icons.newspaper,
          title: '최신 뉴스',
          trailing: '더보기 →',
          onTrailingTap: () => _navigateToTab(5),
          child: _buildNewsPreview(),
        ),

        // 10. 기업 연혁
        _Section(
          icon: Icons.history,
          title: '기업 연혁',
          child: _buildTimeline(),
        ),

        // 11. 유사 기업 추천
        _Section(
          icon: Icons.business,
          title: '유사 기업 추천',
          trailing: '전체보기 →',
          onTrailingTap: () => _navigateToTab(3),
          child: _buildSimilarPreview(),
        ),

        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildExecutivePreview() {
    final execs = mock.executives.take(3).toList();
    return Column(
      children: execs.map((exec) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderLight),
          borderRadius: BorderRadius.circular(AppTheme.radius),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: exec.color, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Text(
                exec.name.substring(0, 1),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(exec.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: exec.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          exec.role,
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: exec.color),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${exec.dept}부문 · ${exec.since}년~',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSub),
                  ),
                ],
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildTechPatents() {
    final patents = [
      ('반도체 웨이퍼 프로빙 장치 및 방법', '특허 제10-2024-001', '2024.03'),
      ('AI 기반 반도체 불량 검출 시스템', '특허 제10-2023-042', '2023.11'),
      ('고속 웨이퍼 정렬 메커니즘', '특허 제10-2023-018', '2023.06'),
      ('비전 검사 장비용 조명 모듈', '특허 제10-2022-055', '2022.09'),
      ('반도체 테스트 소켓 접촉 구조', '특허 제10-2022-012', '2022.03'),
    ];

    return Column(
      children: patents.map((p) => Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderLight))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.purple50,
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.description, size: 14, color: AppColors.purple500),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.$1, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(
                    '${p.$2} · ${p.$3}',
                    style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  static IconData _newsIcon(String emoji) {
    switch (emoji) {
      case '🔬': return Icons.biotech;
      case '📈': return Icons.trending_up;
      case '💰': return Icons.payments;
      case '🏭': return Icons.factory;
      case '🌏': return Icons.public;
      default: return Icons.article;
    }
  }

  Widget _buildNewsPreview() {
    final news = mock.newsItems.take(3).toList();
    return Column(
      children: news.map((item) => Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderLight))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(color: AppColors.slate50, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Icon(_newsIcon(item.emoji), size: 16, color: AppColors.brand),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(item.source, style: const TextStyle(fontSize: 11, color: AppColors.textSub)),
                      const SizedBox(width: 8),
                      Text(item.time, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildFinanceSummaryTable() {
    final headers = ['항목', '2021', '2022', '2023', '2024', '2025'];
    final rows = [
      ['매출액 (억)', '280', '295', '310', '328', '342'],
      ['영업이익 (억)', '18', '20', '22', '25', '28'],
      ['순이익 (억)', '12', '14', '15', '18', '20'],
      ['자산총계 (억)', '520', '560', '610', '670', '720'],
      ['부채비율 (%)', '85', '78', '72', '68', '65'],
    ];

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
          columnSpacing: 16,
          horizontalMargin: 12,
          headingTextStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSub, fontFamily: 'Pretendard'),
          dataTextStyle: const TextStyle(fontSize: 12, color: AppColors.text, fontFamily: 'Pretendard'),
          columns: headers.map((h) => DataColumn(label: Text(h))).toList(),
          rows: rows.map((row) => DataRow(
            cells: row.map((cell) => DataCell(Text(cell))).toList(),
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildTimeline() {
    final events = [
      ('2024', 'AI 검사 솔루션 HB-Vision 출시, Series B 투자 유치 (200억)'),
      ('2023', 'SK하이닉스 납품 개시, 직원 150명 돌파'),
      ('2022', '본사 강남 이전, 해외 지사 설립 (중국 상하이)'),
      ('2020', '삼성전자 반도체 사업부 납품 시작'),
      ('2018', 'Series A 투자 유치 (50억), 웨이퍼 프로버 양산 시작'),
      ('2011', '에이치비테크놀로지 설립'),
    ];

    return Column(
      children: events.asMap().entries.map((entry) {
        final i = entry.key;
        final (year, text) = entry.value;
        return Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Line + dot
              SizedBox(
                width: 20,
                child: Column(
                  children: [
                    Container(
                      width: 10, height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.brand,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [BoxShadow(color: AppColors.brand.withValues(alpha: 0.3), blurRadius: 4)],
                      ),
                    ),
                    if (i < events.length - 1)
                      Container(width: 2, height: 40, color: AppColors.border),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(year, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.brand)),
                      const SizedBox(height: 2),
                      Text(text, style: const TextStyle(fontSize: 13, color: AppColors.textSub, height: 1.5)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSimilarPreview() {
    final similar = sampleCompanies.where((s) => s.name != c.name).take(5).toList();
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: similar.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final s = similar[i];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CompanyDetailScreen(company: s)),
              );
            },
            child: Container(
            width: 200,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(AppTheme.radius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    color: s.color,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  alignment: Alignment.center,
                  child: Text(s.initials, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
                const SizedBox(height: 6),
                Text(s.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                Text(s.industry, style: const TextStyle(fontSize: 11, color: AppColors.textSub), overflow: TextOverflow.ellipsis),
                const Spacer(),
                Row(
                  children: [
                    Text('매출 ', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                    Text(s.revenueFormatted, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 12),
                    Text('영업이익 ', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                    Text(s.profitFormatted, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
          );
        },
      ),
    );
  }

  Widget _buildFinanceTab() => FinanceTab(company: c);
  Widget _buildPeopleTab() => PeopleTab(company: c);
  Widget _buildSimilarTab() => SimilarTab(company: c);
  Widget _buildCompetitorsTab() => CompetitorsTab(company: c);
  Widget _buildNewsTab() => NewsTab(company: c);
  Widget _buildCommunityTab() => CommunityTab(company: c);

  Widget _buildBottomCta() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8 + MediaQuery.of(context).padding.bottom),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 44,
              child: OutlinedButton(
                onPressed: _showAddToListSheet,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radius)),
                ),
                child: const Text('리스트에 추가', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.text)),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  setState(() => _isNotified = !_isNotified);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_isNotified ? '알림이 설정되었습니다' : '알림이 해제되었습니다'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brand,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radius)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_isNotified ? Icons.notifications_active : Icons.notifications_none, size: 18),
                    const SizedBox(width: 6),
                    Text(_isNotified ? '알림 받는 중' : '알림 받기', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Reusable widgets for detail screen ──

class _Badge extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color textColor;

  const _Badge({required this.label, required this.bgColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textColor)),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final String growth;
  final bool isPositive;

  const _MetricCard({required this.label, required this.value, required this.unit, required this.growth, required this.isPositive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.slate50,
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontFamily: 'Pretendard'),
              children: [
                TextSpan(text: value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.text, letterSpacing: -0.3)),
                TextSpan(text: unit, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSub)),
              ],
            ),
          ),
          const SizedBox(height: 1),
          Text(
            growth,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: isPositive ? AppColors.emerald600 : AppColors.red600),
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
  final VoidCallback? onTrailingTap;
  final Widget child;

  const _Section({required this.icon, required this.title, this.trailing, this.onTrailingTap, required this.child});

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
                GestureDetector(
                  onTap: onTrailingTap,
                  child: Text(trailing!, style: const TextStyle(fontSize: 12, color: AppColors.brand, fontWeight: FontWeight.w500)),
                ),
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

class _SupplyGroup extends StatelessWidget {
  final String title;
  final Color color;
  final List<(String, String)> items;

  const _SupplyGroup({required this.title, required this.color, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSub)),
          ],
        ),
        ...items.map((item) => Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderLight))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.$1, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              Text(item.$2, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.brand)),
            ],
          ),
        )),
      ],
    );
  }
}

class _MiniMetric extends StatelessWidget {
  final String label;
  final String value;
  final bool isPositive;

  const _MiniMetric({required this.label, required this.value, this.isPositive = false});

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
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isPositive ? AppColors.emerald600 : AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExportOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ExportOption({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textSub),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

