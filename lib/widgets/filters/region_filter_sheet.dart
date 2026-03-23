import 'package:flutter/material.dart';
import '../../models/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

class RegionFilterSheet extends StatefulWidget {
  final Set<String> initialSelection;
  final ValueChanged<Set<String>> onApply;

  const RegionFilterSheet({super.key, required this.initialSelection, required this.onApply});

  @override
  State<RegionFilterSheet> createState() => _RegionFilterSheetState();
}

class _RegionFilterSheetState extends State<RegionFilterSheet> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.initialSelection);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.85,
      minChildSize: 0.3,
      expand: false,
      builder: (_, scrollController) => Column(
        children: [
          Container(width: 36, height: 4, margin: const EdgeInsets.only(top: 10, bottom: 6),
            decoration: BoxDecoration(color: AppColors.slate300, borderRadius: BorderRadius.circular(2))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const Text('지역', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  if (_selected.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.brand, borderRadius: BorderRadius.circular(10)),
                      child: Text('${_selected.length}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ],
                ]),
                GestureDetector(
                  onTap: () => setState(() => _selected.clear()),
                  child: const Text('초기화', style: TextStyle(fontSize: 13, color: AppColors.brand, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: regionList.length,
              itemBuilder: (_, i) {
                final r = regionList[i];
                final isChecked = _selected.contains(r.name);
                return GestureDetector(
                  onTap: () => setState(() {
                    if (isChecked) { _selected.remove(r.name); } else { _selected.add(r.name); }
                  }),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderLight))),
                    child: Row(
                      children: [
                        Container(
                          width: 20, height: 20,
                          decoration: BoxDecoration(
                            color: isChecked ? AppColors.brand : Colors.transparent,
                            border: Border.all(color: isChecked ? AppColors.brand : AppColors.border, width: 2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: isChecked ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(r.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.slate50, borderRadius: BorderRadius.circular(10)),
                          child: Text('${r.count}', style: const TextStyle(fontSize: 12, color: AppColors.textSub)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.borderLight))),
            child: SizedBox(
              width: double.infinity, height: 48,
              child: ElevatedButton(
                onPressed: () { widget.onApply(_selected); Navigator.pop(context); },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brand, foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusLg)),
                  textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                child: Text('결과 보기${_selected.isEmpty ? "" : " (${_selected.length}개 선택)"}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
