import 'package:flutter/material.dart';
import '../../models/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

class IndustryFilterSheet extends StatefulWidget {
  final Set<String> initialSelection;
  final ValueChanged<Set<String>> onApply;

  const IndustryFilterSheet({super.key, required this.initialSelection, required this.onApply});

  @override
  State<IndustryFilterSheet> createState() => _IndustryFilterSheetState();
}

class _IndustryFilterSheetState extends State<IndustryFilterSheet> {
  late Set<String> _selected;
  final Map<String, bool> _expanded = {};

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.initialSelection);
  }

  void _toggleNode(FilterNode node) {
    setState(() {
      if (node.children.isEmpty) {
        if (_selected.contains(node.name)) {
          _selected.remove(node.name);
        } else {
          _selected.add(node.name);
        }
      } else {
        final allLeaves = _getAllLeaves(node);
        final allSelected = allLeaves.every((l) => _selected.contains(l));
        if (allSelected) {
          _selected.removeAll(allLeaves);
        } else {
          _selected.addAll(allLeaves);
        }
      }
    });
  }

  List<String> _getAllLeaves(FilterNode node) {
    if (node.children.isEmpty) return [node.name];
    return node.children.expand(_getAllLeaves).toList();
  }

  bool _isNodeSelected(FilterNode node) {
    if (node.children.isEmpty) return _selected.contains(node.name);
    return _getAllLeaves(node).every((l) => _selected.contains(l));
  }

  bool _isNodePartial(FilterNode node) {
    if (node.children.isEmpty) return false;
    final leaves = _getAllLeaves(node);
    final count = leaves.where((l) => _selected.contains(l)).length;
    return count > 0 && count < leaves.length;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      expand: false,
      builder: (_, scrollController) => Column(
        children: [
          _buildHandle(),
          _buildHeader(),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: industryTree.length,
              itemBuilder: (_, i) => _buildTopLevel(industryTree[i]),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHandle() => Container(
    width: 36, height: 4,
    margin: const EdgeInsets.only(top: 10, bottom: 6),
    decoration: BoxDecoration(color: AppColors.slate300, borderRadius: BorderRadius.circular(2)),
  );

  Widget _buildHeader() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppTheme.sectionPad, vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Text('업종', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            if (_selected.isNotEmpty) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: AppColors.brand, borderRadius: BorderRadius.circular(10)),
                child: Text('${_selected.length}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
              ),
            ],
          ],
        ),
        GestureDetector(
          onTap: () => setState(() => _selected.clear()),
          child: const Text('초기화', style: TextStyle(fontSize: 13, color: AppColors.brand, fontWeight: FontWeight.w500)),
        ),
      ],
    ),
  );

  Widget _buildTopLevel(FilterNode node) {
    final key = node.code;
    final isExpanded = _expanded[key] ?? false;
    final isChecked = _isNodeSelected(node);
    final isPartial = _isNodePartial(node);

    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _expanded[key] = !isExpanded),
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderLight))),
            child: Row(
              children: [
                _checkbox(isChecked, isPartial, () => _toggleNode(node)),
                const SizedBox(width: 10),
                Expanded(child: Text(node.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
                Icon(isExpanded ? Icons.expand_less : Icons.expand_more, size: 20, color: AppColors.textSub),
              ],
            ),
          ),
        ),
        if (isExpanded)
          ...node.children.map((mid) => _buildMidLevel(mid)),
      ],
    );
  }

  Widget _buildMidLevel(FilterNode node) {
    final key = node.code;
    final isExpanded = _expanded[key] ?? false;
    final isChecked = _isNodeSelected(node);
    final isPartial = _isNodePartial(node);

    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _expanded[key] = !isExpanded),
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: const EdgeInsets.fromLTRB(36, 10, 16, 10),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderLight))),
            child: Row(
              children: [
                _checkbox(isChecked, isPartial, () => _toggleNode(node)),
                const SizedBox(width: 10),
                Expanded(child: Text(node.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
                if (node.children.isNotEmpty)
                  Icon(isExpanded ? Icons.expand_less : Icons.expand_more, size: 18, color: AppColors.textMuted),
              ],
            ),
          ),
        ),
        if (isExpanded)
          ...node.children.map((leaf) => _buildLeaf(leaf)),
      ],
    );
  }

  Widget _buildLeaf(FilterNode node) {
    final isChecked = _selected.contains(node.name);
    return GestureDetector(
      onTap: () => _toggleNode(node),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.fromLTRB(56, 8, 16, 8),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderLight))),
        child: Row(
          children: [
            _checkbox(isChecked, false, () => _toggleNode(node)),
            const SizedBox(width: 10),
            Expanded(child: Text(node.name, style: const TextStyle(fontSize: 13, color: AppColors.textSub))),
            if (node.count != null)
              Text('${node.count}', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }

  Widget _checkbox(bool checked, bool partial, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 20, height: 20,
        decoration: BoxDecoration(
          color: checked ? AppColors.brand : (partial ? AppColors.blue100 : Colors.transparent),
          border: Border.all(color: checked || partial ? AppColors.brand : AppColors.border, width: 2),
          borderRadius: BorderRadius.circular(5),
        ),
        child: checked
            ? const Icon(Icons.check, size: 12, color: Colors.white)
            : partial
                ? const Icon(Icons.remove, size: 12, color: AppColors.brand)
                : null,
      ),
    );
  }

  Widget _buildFooter() => Container(
    padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
    decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.borderLight))),
    child: SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          widget.onApply(_selected);
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brand,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusLg)),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        child: Text('결과 보기${_selected.isEmpty ? "" : " (${_selected.length}개 선택)"}'),
      ),
    ),
  );
}
