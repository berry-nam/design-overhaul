import 'package:flutter/material.dart';
import '../models/company.dart';
import '../state/list_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/company_list_item.dart';
import '../widgets/filters/industry_filter_sheet.dart';
import '../widgets/filters/product_filter_sheet.dart';
import '../widgets/filters/region_filter_sheet.dart';
import '../widgets/filters/range_filter_sheet.dart';
import '../widgets/filters/ceo_filter_sheet.dart';
import 'company_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final GlobalKey<SearchScreenState>? searchKey;
  const SearchScreen({super.key, this.searchKey});

  @override
  State<SearchScreen> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  int _modeIndex = 0; // 0 = search, 1 = list
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortLabel = '매출액 높은 순';
  final Set<int> _selectedIndices = {};

  // Filter state
  Set<String> _selectedIndustries = {};
  Set<String> _selectedProducts = {};
  Set<String> _selectedRegions = {};
  double? _revenueMin;
  double? _revenueMax;
  double? _profitMin;
  double? _profitMax;
  String _ceoQuery = '';

  // List state
  final _listState = ListState();

  void toggleMode() {
    setState(() => _modeIndex = _modeIndex == 0 ? 1 : 0);
  }

  int get _activeFilterCount {
    int c = 0;
    if (_selectedIndustries.isNotEmpty) c++;
    if (_selectedProducts.isNotEmpty) c++;
    if (_selectedRegions.isNotEmpty) c++;
    if (_revenueMin != null || _revenueMax != null) c++;
    if (_profitMin != null || _profitMax != null) c++;
    if (_ceoQuery.isNotEmpty) c++;
    return c;
  }

  List<Company> get _filteredCompanies {
    var list = List<Company>.from(sampleCompanies);

    // Text search
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((c) =>
          c.name.toLowerCase().contains(q) ||
          c.industry.toLowerCase().contains(q) ||
          c.ceo.toLowerCase().contains(q) ||
          c.bizNo.contains(q) ||
          c.products.toLowerCase().contains(q)).toList();
    }

    // Industry filter
    if (_selectedIndustries.isNotEmpty) {
      list = list.where((c) =>
        _selectedIndustries.any((ind) => c.industry.contains(ind) || c.category.contains(ind))
      ).toList();
    }

    // Product filter
    if (_selectedProducts.isNotEmpty) {
      list = list.where((c) =>
        _selectedProducts.any((prod) => c.products.contains(prod))
      ).toList();
    }

    // Region filter
    if (_selectedRegions.isNotEmpty) {
      list = list.where((c) =>
        _selectedRegions.any((r) => c.region.contains(r))
      ).toList();
    }

    // Revenue range
    if (_revenueMin != null) list = list.where((c) => c.revenue >= _revenueMin!).toList();
    if (_revenueMax != null) list = list.where((c) => c.revenue <= _revenueMax!).toList();

    // Profit range
    if (_profitMin != null) list = list.where((c) => c.profit >= _profitMin!).toList();
    if (_profitMax != null) list = list.where((c) => c.profit <= _profitMax!).toList();

    // CEO search
    if (_ceoQuery.isNotEmpty) {
      list = list.where((c) => c.ceo.contains(_ceoQuery)).toList();
    }

    // Sort
    switch (_sortLabel) {
      case '매출액 낮은 순':
        list.sort((a, b) => a.revenue.compareTo(b.revenue));
      case '영업이익 높은 순':
        list.sort((a, b) => b.profit.compareTo(a.profit));
      case '설립일 최신 순':
        list.sort((a, b) => b.foundedYear.compareTo(a.foundedYear));
      case '성장률 높은 순':
        list.sort((a, b) => b.revenueGrowth.compareTo(a.revenueGrowth));
      default:
        list.sort((a, b) => b.revenue.compareTo(a.revenue));
    }
    return list;
  }

  void _openFilterSheet(String type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.sheetRadius)),
      ),
      builder: (ctx) {
        switch (type) {
          case '업종':
            return IndustryFilterSheet(
              initialSelection: _selectedIndustries,
              onApply: (v) => setState(() => _selectedIndustries = v),
            );
          case '생산품':
            return ProductFilterSheet(
              initialSelection: _selectedProducts,
              onApply: (v) => setState(() => _selectedProducts = v),
            );
          case '지역':
            return RegionFilterSheet(
              initialSelection: _selectedRegions,
              onApply: (v) => setState(() => _selectedRegions = v),
            );
          case '매출':
            return RangeFilterSheet(
              title: '매출액',
              unit: '억 원',
              initialMin: _revenueMin,
              initialMax: _revenueMax,
              presets: [
                ('10억 이하', null, 10),
                ('10~50억', 10, 50),
                ('50~100억', 50, 100),
                ('100~500억', 100, 500),
                ('500~1000억', 500, 1000),
                ('1000억 이상', 1000, null),
              ],
              onApply: (min, max) => setState(() { _revenueMin = min; _revenueMax = max; }),
            );
          case '영업이익':
            return RangeFilterSheet(
              title: '영업이익',
              unit: '억 원',
              initialMin: _profitMin,
              initialMax: _profitMax,
              presets: [
                ('적자 기업', null, 0),
                ('0~10억', 0, 10),
                ('10~50억', 10, 50),
                ('50~100억', 50, 100),
                ('100억 이상', 100, null),
              ],
              onApply: (min, max) => setState(() { _profitMin = min; _profitMax = max; }),
            );
          case '대표자명':
            return CeoFilterSheet(
              initialQuery: _ceoQuery,
              onApply: (v) => setState(() => _ceoQuery = v),
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  void _openSortSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.sheetRadius)),
      ),
      builder: (ctx) => _SortSheet(
        current: _sortLabel,
        onSelect: (label) {
          setState(() => _sortLabel = label);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final companies = _filteredCompanies;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Mode chips
            _buildModeChips(),
            // Content
            Expanded(
              child: _modeIndex == 0
                  ? _buildSearchView(companies)
                  : _buildListView(companies),
            ),
          ],
        ),
      ),
      // Selection bar
      bottomSheet: _selectedIndices.isNotEmpty ? _buildSelectionBar() : null,
    );
  }

  Widget _buildModeChips() {
    return Container(
      padding: const EdgeInsets.fromLTRB(AppTheme.sectionPad, 12, AppTheme.sectionPad, 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      child: Row(
        children: [
          _ModeChip(
            label: '기업 탐색',
            isActive: _modeIndex == 0,
            onTap: () => setState(() => _modeIndex = 0),
          ),
          const SizedBox(width: 8),
          _ModeChip(
            label: '리스트',
            isActive: _modeIndex == 1,
            badge: '4',
            onTap: () => setState(() => _modeIndex = 1),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchView(List<Company> companies) {
    return CustomScrollView(
      slivers: [
        // Search bar
        SliverPersistentHeader(
          pinned: true,
          delegate: _SearchBarDelegate(
            controller: _searchController,
            onChanged: (v) => setState(() => _searchQuery = v),
          ),
        ),
        // Filter chips
        SliverToBoxAdapter(child: _buildFilterChips()),
        // Result bar
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(AppTheme.sectionPad, 12, AppTheme.sectionPad, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 13, color: AppColors.textSub, fontFamily: 'Pretendard'),
                    children: [
                      const TextSpan(text: '탐색 결과 '),
                      TextSpan(
                        text: '${companies.length}',
                        style: const TextStyle(color: AppColors.brand, fontWeight: FontWeight.w700),
                      ),
                      const TextSpan(text: '개'),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: _openSortSheet,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '정렬 $_sortLabel',
                        style: const TextStyle(fontSize: 13, color: AppColors.textSub, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.textSub),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Company list
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.sectionPad),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final company = companies[index];
                return CompanyListItem(
                  company: company,
                  showCheckbox: true,
                  isSelected: _selectedIndices.contains(index),
                  onCheckToggle: () {
                    setState(() {
                      if (_selectedIndices.contains(index)) {
                        _selectedIndices.remove(index);
                      } else {
                        _selectedIndices.add(index);
                      }
                    });
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CompanyDetailScreen(company: company),
                      ),
                    );
                  },
                );
              },
              childCount: companies.length,
            ),
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
      ],
    );
  }

  int _badgeForFilter(String type) {
    switch (type) {
      case '업종': return _selectedIndustries.length;
      case '생산품': return _selectedProducts.length;
      case '지역': return _selectedRegions.length;
      case '매출': return (_revenueMin != null || _revenueMax != null) ? 1 : 0;
      case '영업이익': return (_profitMin != null || _profitMax != null) ? 1 : 0;
      case '대표자명': return _ceoQuery.isNotEmpty ? 1 : 0;
      default: return 0;
    }
  }

  Widget _buildFilterChips() {
    final filters = ['업종', '생산품', '지역', '매출', '영업이익', '대표자명'];
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.sectionPad, vertical: 8),
        itemCount: filters.length + (_activeFilterCount > 0 ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          // Clear-all chip at the end
          if (_activeFilterCount > 0 && i == filters.length) {
            return GestureDetector(
              onTap: () => setState(() {
                _selectedIndustries = {};
                _selectedProducts = {};
                _selectedRegions = {};
                _revenueMin = null;
                _revenueMax = null;
                _profitMin = null;
                _profitMax = null;
                _ceoQuery = '';
              }),
              child: Container(
                height: AppTheme.chipHeight,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.slate100,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh, size: 14, color: AppColors.textSub),
                    SizedBox(width: 4),
                    Text('초기화', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSub)),
                  ],
                ),
              ),
            );
          }

          final badge = _badgeForFilter(filters[i]);
          final isActive = badge > 0;

          return GestureDetector(
            onTap: () => _openFilterSheet(filters[i]),
            child: Container(
              height: AppTheme.chipHeight,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                border: Border.all(color: isActive ? AppColors.brand : AppColors.border),
                borderRadius: BorderRadius.circular(20),
                color: isActive ? AppColors.blue50 : Colors.white,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    filters[i],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color: isActive ? AppColors.brand : AppColors.textSub,
                    ),
                  ),
                  if (badge > 0) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(color: AppColors.brand, borderRadius: BorderRadius.circular(8)),
                      child: Text('$badge', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ] else ...[
                    const SizedBox(width: 4),
                    Icon(Icons.keyboard_arrow_down, size: 14, color: AppColors.textSub),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListView(List<Company> _) {
    final listCompanies = _listState.companies;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with edit button
        Padding(
          padding: const EdgeInsets.fromLTRB(AppTheme.sectionPad, 12, AppTheme.sectionPad, 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('내 리스트', style: Theme.of(context).textTheme.headlineMedium),
              GestureDetector(
                onTap: _showCreateGroupSheet,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, size: 14, color: AppColors.textSub),
                      SizedBox(width: 4),
                      Text('새 그룹', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSub)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Group tabs
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.sectionPad),
            children: [
              _ListTab(
                label: '전체',
                count: '${_listState.totalCount}',
                isActive: _listState.activeGroupIndex < 0,
                onTap: () => setState(() => _listState.setActiveGroup(-1)),
              ),
              ...List.generate(_listState.groups.length, (i) {
                final g = _listState.groups[i];
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: _ListTab(
                    label: g.name,
                    count: '${g.companyNames.length}',
                    isActive: _listState.activeGroupIndex == i,
                    color: g.color,
                    onTap: () => setState(() => _listState.setActiveGroup(i)),
                    onLongPress: () => _showEditGroupSheet(i),
                  ),
                );
              }),
            ],
          ),
        ),
        // Result count
        Padding(
          padding: const EdgeInsets.fromLTRB(AppTheme.sectionPad, 10, AppTheme.sectionPad, 4),
          child: Text(
            '${listCompanies.length}개 기업',
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
        ),
        Expanded(
          child: listCompanies.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.folder_open, size: 48, color: AppColors.slate200),
                      const SizedBox(height: 12),
                      const Text('리스트가 비어있습니다', style: TextStyle(fontSize: 14, color: AppColors.textMuted)),
                      const SizedBox(height: 4),
                      const Text('기업 탐색에서 기업을 추가해보세요', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.sectionPad),
                  itemCount: listCompanies.length,
                  itemBuilder: (context, index) {
                    return CompanyListItem(
                      company: listCompanies[index],
                      showCheckbox: true,
                      isSelected: _selectedIndices.contains(index + 10000),
                      onCheckToggle: () {
                        setState(() {
                          final key = index + 10000;
                          if (_selectedIndices.contains(key)) {
                            _selectedIndices.remove(key);
                          } else {
                            _selectedIndices.add(key);
                          }
                        });
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CompanyDetailScreen(company: listCompanies[index]),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _showCreateGroupSheet() {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final colors = [
      AppColors.brand, const Color(0xFFD97706), const Color(0xFF059669),
      const Color(0xFF8B5CF6), const Color(0xFFDC2626), const Color(0xFF0891B2),
    ];
    int selectedColor = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.sheetRadius)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(ctx).viewInsets.bottom + MediaQuery.of(ctx).padding.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 36, height: 4, decoration: BoxDecoration(color: AppColors.slate300, borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 16),
              const Text('새 그룹 만들기', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: '그룹 이름',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descCtrl,
                decoration: InputDecoration(
                  hintText: '설명 (선택)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 12),
              const Text('색상', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                children: List.generate(colors.length, (i) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () => setSheetState(() => selectedColor = i),
                    child: Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        color: colors[i],
                        shape: BoxShape.circle,
                        border: selectedColor == i ? Border.all(color: Colors.white, width: 3) : null,
                        boxShadow: selectedColor == i ? [BoxShadow(color: colors[i].withValues(alpha: 0.5), blurRadius: 8)] : null,
                      ),
                      child: selectedColor == i ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                    ),
                  ),
                )),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity, height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (nameCtrl.text.trim().isEmpty) return;
                    setState(() {
                      _listState.createGroup(nameCtrl.text.trim(), descCtrl.text.trim(), colors[selectedColor]);
                    });
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brand, foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusLg)),
                  ),
                  child: const Text('만들기', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditGroupSheet(int groupIndex) {
    final group = _listState.groups[groupIndex];
    final nameCtrl = TextEditingController(text: group.name);
    final descCtrl = TextEditingController(text: group.desc);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.sheetRadius)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(ctx).viewInsets.bottom + MediaQuery.of(ctx).padding.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(width: 36, height: 4, decoration: BoxDecoration(color: AppColors.slate300, borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('그룹 편집', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() => _listState.deleteGroup(groupIndex));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${group.name} 그룹이 삭제되었습니다')),
                    );
                  },
                  child: const Text('삭제', style: TextStyle(fontSize: 13, color: Color(0xFFDC2626), fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                hintText: '그룹 이름',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descCtrl,
              decoration: InputDecoration(
                hintText: '설명 (선택)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity, height: 48,
              child: ElevatedButton(
                onPressed: () {
                  if (nameCtrl.text.trim().isEmpty) return;
                  setState(() => _listState.editGroup(groupIndex, nameCtrl.text.trim(), descCtrl.text.trim()));
                  Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brand, foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusLg)),
                ),
                child: const Text('저장', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBulkAddToListSheet() {
    final companies = _filteredCompanies;
    final names = _selectedIndices
        .where((i) => i < companies.length)
        .map((i) => companies[i].name)
        .toList();
    if (names.isEmpty) return;

    final checked = List.filled(_listState.groups.length, false);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
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
              Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: AppColors.slate300, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              Text('${names.length}개 기업을 리스트에 추가', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              ...List.generate(_listState.groups.length, (i) {
                final g = _listState.groups[i];
                return GestureDetector(
                  onTap: () => setSheetState(() => checked[i] = !checked[i]),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 20, height: 20,
                          decoration: BoxDecoration(
                            color: checked[i] ? AppColors.brand : Colors.transparent,
                            border: Border.all(color: checked[i] ? AppColors.brand : AppColors.border, width: 2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: checked[i] ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
                        ),
                        const SizedBox(width: 12),
                        Container(width: 10, height: 10, decoration: BoxDecoration(color: g.color, shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Text(g.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        const SizedBox(width: 6),
                        Text('${g.companyNames.length}', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity, height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    for (int i = 0; i < checked.length; i++) {
                      if (checked[i]) _listState.addToGroup(i, names);
                    }
                    Navigator.pop(ctx);
                    setState(() => _selectedIndices.clear());
                    final addedTo = <String>[];
                    for (int i = 0; i < checked.length; i++) {
                      if (checked[i]) addedTo.add(_listState.groups[i].name);
                    }
                    if (addedTo.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${names.length}개 기업이 ${addedTo.join(", ")}에 추가되었습니다')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brand, foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusLg)),
                  ),
                  child: const Text('추가', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionBar() {
    return Container(
      color: AppColors.slate900,
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.sectionPad, vertical: 10),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.brand,
                borderRadius: BorderRadius.circular(AppTheme.radius),
              ),
              child: Text(
                '${_selectedIndices.length}',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              '개 기업 선택됨',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
            ),
            const Spacer(),
            _SelBarBtn(label: '리스트에 추가', onTap: _showBulkAddToListSheet),
            const SizedBox(width: 8),
            _SelBarBtn(label: '선택 해제', onTap: () => setState(() => _selectedIndices.clear())),
          ],
        ),
      ),
    );
  }
}

// ── Helper widgets ──

class _ModeChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final String? badge;
  final VoidCallback onTap;

  const _ModeChip({required this.label, required this.isActive, this.badge, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? AppColors.brand : AppColors.slate100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : AppColors.slate600,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: isActive ? Colors.white.withValues(alpha: 0.25) : AppColors.slate200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badge!,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isActive ? Colors.white : AppColors.slate600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ListTab extends StatelessWidget {
  final String label;
  final String count;
  final bool isActive;
  final Color? color;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _ListTab({required this.label, required this.count, required this.isActive, this.color, required this.onTap, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? (color ?? AppColors.slate900) : AppColors.slate50,
          borderRadius: BorderRadius.circular(16),
          border: isActive ? null : Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (color != null && !isActive) ...[
              Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isActive ? Colors.white : AppColors.textSub,
              ),
            ),
            Text(
              ' $count',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isActive ? Colors.white.withValues(alpha: 0.7) : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelBarBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SelBarBtn({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.slate700,
          borderRadius: BorderRadius.circular(AppTheme.radius),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
    );
  }
}

class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  _SearchBarDelegate({required this.controller, required this.onChanged});

  @override
  double get maxExtent => 60;
  @override
  double get minExtent => 60;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.sectionPad, vertical: 8),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: '기업명, 업종, 대표자명, 사업자번호...',
          hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
          filled: true,
          fillColor: AppColors.slate50,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            borderSide: const BorderSide(color: AppColors.brand),
          ),
          suffixIcon: const Icon(Icons.search, color: AppColors.textMuted, size: 18),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}

class _SortSheet extends StatelessWidget {
  final String current;
  final ValueChanged<String> onSelect;

  const _SortSheet({required this.current, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final options = ['매출액 높은 순', '매출액 낮은 순', '영업이익 높은 순', '설립일 최신 순', '성장률 높은 순'];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36, height: 4,
          margin: const EdgeInsets.only(top: 10, bottom: 12),
          decoration: BoxDecoration(color: AppColors.slate300, borderRadius: BorderRadius.circular(2)),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppTheme.sectionPad),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('정렬', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ),
        ),
        ...options.map((opt) => GestureDetector(
          onTap: () => onSelect(opt),
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.sectionPad, vertical: 14),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.borderLight)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  opt,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: current == opt ? FontWeight.w700 : FontWeight.w500,
                    color: current == opt ? AppColors.brand : AppColors.text,
                  ),
                ),
                if (current == opt)
                  const Text('✓', style: TextStyle(color: AppColors.brand, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        )),
        SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
      ],
    );
  }
}
