import 'package:flutter/material.dart';
import '../models/company.dart';
import '../models/company_list_group.dart';

class ListState extends ChangeNotifier {
  final List<CompanyListGroup> _groups = List.from(defaultGroups);
  int _activeGroupIndex = -1; // -1 = 전체

  List<CompanyListGroup> get groups => _groups;
  int get activeGroupIndex => _activeGroupIndex;

  String get activeGroupName => _activeGroupIndex < 0 ? '전체' : _groups[_activeGroupIndex].name;

  void setActiveGroup(int index) {
    _activeGroupIndex = index;
    notifyListeners();
  }

  /// All unique company names across all groups
  Set<String> get _allNames =>
      _groups.expand((g) => g.companyNames).toSet();

  /// Companies for the active group (or all if -1)
  List<Company> get companies {
    final names = _activeGroupIndex < 0
        ? _allNames
        : _groups[_activeGroupIndex].companyNames.toSet();
    return sampleCompanies.where((c) => names.contains(c.name)).toList();
  }

  int get totalCount => _allNames.length;

  /// Add companies to a group by name
  void addToGroup(int groupIndex, List<String> names) {
    final group = _groups[groupIndex];
    for (final n in names) {
      if (!group.companyNames.contains(n)) {
        group.companyNames.add(n);
      }
    }
    notifyListeners();
  }

  /// Remove a company from a group
  void removeFromGroup(int groupIndex, String name) {
    _groups[groupIndex].companyNames.remove(name);
    notifyListeners();
  }

  /// Create a new group
  void createGroup(String name, String desc, Color color) {
    _groups.add(CompanyListGroup(
      name: name,
      desc: desc,
      color: color,
      companyNames: [],
    ));
    notifyListeners();
  }

  /// Delete a group
  void deleteGroup(int index) {
    _groups.removeAt(index);
    if (_activeGroupIndex >= _groups.length) {
      _activeGroupIndex = -1;
    }
    notifyListeners();
  }

  /// Rename a group
  void editGroup(int index, String name, String desc) {
    _groups[index].name = name;
    _groups[index].desc = desc;
    notifyListeners();
  }
}
