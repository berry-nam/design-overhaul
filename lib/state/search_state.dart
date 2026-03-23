import 'package:flutter/foundation.dart';
import '../models/company.dart';

enum SortKey {
  revenueDesc,
  revenueAsc,
  profitDesc,
  foundedDesc,
  growthDesc,
}

class SearchState extends ChangeNotifier {
  String _searchQuery = '';
  SortKey _sortKey = SortKey.revenueDesc;
  Set<String> _selectedIndustries = {};
  Set<String> _selectedProducts = {};
  Set<String> _selectedRegions = {};
  double? _revenueMin;
  double? _revenueMax;
  double? _profitMin;
  double? _profitMax;
  String _ceoQuery = '';
  final Set<int> _selectedIndices = {};

  // Getters
  String get searchQuery => _searchQuery;
  SortKey get sortKey => _sortKey;
  Set<String> get selectedIndustries => _selectedIndustries;
  Set<String> get selectedProducts => _selectedProducts;
  Set<String> get selectedRegions => _selectedRegions;
  double? get revenueMin => _revenueMin;
  double? get revenueMax => _revenueMax;
  double? get profitMin => _profitMin;
  double? get profitMax => _profitMax;
  String get ceoQuery => _ceoQuery;
  Set<int> get selectedIndices => _selectedIndices;

  String get sortLabel {
    switch (_sortKey) {
      case SortKey.revenueDesc: return '매출액 높은 순';
      case SortKey.revenueAsc: return '매출액 낮은 순';
      case SortKey.profitDesc: return '영업이익 높은 순';
      case SortKey.foundedDesc: return '설립일 최신 순';
      case SortKey.growthDesc: return '성장률 높은 순';
    }
  }

  int get activeFilterCount {
    int count = 0;
    if (_selectedIndustries.isNotEmpty) count++;
    if (_selectedProducts.isNotEmpty) count++;
    if (_selectedRegions.isNotEmpty) count++;
    if (_revenueMin != null || _revenueMax != null) count++;
    if (_profitMin != null || _profitMax != null) count++;
    if (_ceoQuery.isNotEmpty) count++;
    return count;
  }

  List<Company> get filteredCompanies {
    var list = List<Company>.from(sampleCompanies);

    // Text search
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((c) =>
        c.name.toLowerCase().contains(q) ||
        c.industry.toLowerCase().contains(q) ||
        c.ceo.toLowerCase().contains(q) ||
        c.bizNo.contains(q) ||
        c.products.toLowerCase().contains(q)
      ).toList();
    }

    // Industry filter
    if (_selectedIndustries.isNotEmpty) {
      list = list.where((c) =>
        _selectedIndustries.any((ind) =>
          c.industry.contains(ind) || c.category.contains(ind)
        )
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
    if (_revenueMin != null) {
      list = list.where((c) => c.revenue >= _revenueMin!).toList();
    }
    if (_revenueMax != null) {
      list = list.where((c) => c.revenue <= _revenueMax!).toList();
    }

    // Profit range
    if (_profitMin != null) {
      list = list.where((c) => c.profit >= _profitMin!).toList();
    }
    if (_profitMax != null) {
      list = list.where((c) => c.profit <= _profitMax!).toList();
    }

    // CEO search
    if (_ceoQuery.isNotEmpty) {
      list = list.where((c) => c.ceo.contains(_ceoQuery)).toList();
    }

    // Sort
    switch (_sortKey) {
      case SortKey.revenueDesc:
        list.sort((a, b) => b.revenue.compareTo(a.revenue));
      case SortKey.revenueAsc:
        list.sort((a, b) => a.revenue.compareTo(b.revenue));
      case SortKey.profitDesc:
        list.sort((a, b) => b.profit.compareTo(a.profit));
      case SortKey.foundedDesc:
        list.sort((a, b) => b.foundedYear.compareTo(a.foundedYear));
      case SortKey.growthDesc:
        list.sort((a, b) => b.revenueGrowth.compareTo(a.revenueGrowth));
    }

    return list;
  }

  // Setters
  void setSearchQuery(String q) { _searchQuery = q; notifyListeners(); }
  void setSortKey(SortKey key) { _sortKey = key; notifyListeners(); }

  void setIndustries(Set<String> v) { _selectedIndustries = v; notifyListeners(); }
  void setProducts(Set<String> v) { _selectedProducts = v; notifyListeners(); }
  void setRegions(Set<String> v) { _selectedRegions = v; notifyListeners(); }
  void setRevenueRange(double? min, double? max) { _revenueMin = min; _revenueMax = max; notifyListeners(); }
  void setProfitRange(double? min, double? max) { _profitMin = min; _profitMax = max; notifyListeners(); }
  void setCeoQuery(String q) { _ceoQuery = q; notifyListeners(); }

  void toggleSelection(int index) {
    if (_selectedIndices.contains(index)) {
      _selectedIndices.remove(index);
    } else {
      _selectedIndices.add(index);
    }
    notifyListeners();
  }

  void clearSelection() { _selectedIndices.clear(); notifyListeners(); }

  void clearAllFilters() {
    _selectedIndustries = {};
    _selectedProducts = {};
    _selectedRegions = {};
    _revenueMin = null;
    _revenueMax = null;
    _profitMin = null;
    _profitMax = null;
    _ceoQuery = '';
    notifyListeners();
  }

  // Filter badge counts for chips
  int industryCount() => _selectedIndustries.length;
  int productCount() => _selectedProducts.length;
  int regionCount() => _selectedRegions.length;
  bool hasRevenueFilter() => _revenueMin != null || _revenueMax != null;
  bool hasProfitFilter() => _profitMin != null || _profitMax != null;
  bool hasCeoFilter() => _ceoQuery.isNotEmpty;
}
