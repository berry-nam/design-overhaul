import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

class CeoFilterSheet extends StatefulWidget {
  final String initialQuery;
  final ValueChanged<String> onApply;

  const CeoFilterSheet({super.key, required this.initialQuery, required this.onApply});

  @override
  State<CeoFilterSheet> createState() => _CeoFilterSheetState();
}

class _CeoFilterSheetState extends State<CeoFilterSheet> {
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;
    final extra = keyboardHeight / screenHeight;
    return DraggableScrollableSheet(
      initialChildSize: (0.4 + extra).clamp(0.3, 0.95),
      maxChildSize: 0.95,
      minChildSize: 0.3,
      expand: false,
      builder: (_, scrollController) => Column(
        children: [
          Container(
            width: 36, height: 4,
            margin: const EdgeInsets.only(top: 10, bottom: 6),
            decoration: BoxDecoration(color: AppColors.slate300, borderRadius: BorderRadius.circular(2)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const Text('대표자명', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  if (_ctrl.text.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.brand, borderRadius: BorderRadius.circular(10)),
                      child: const Text('1', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ],
                ]),
                GestureDetector(
                  onTap: () => setState(() => _ctrl.clear()),
                  child: const Text('초기화', style: TextStyle(fontSize: 13, color: AppColors.brand, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              children: [
                TextField(
                  controller: _ctrl,
                  autofocus: true,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    hintText: '대표자명을 입력하세요',
                    hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: AppColors.textMuted, size: 20),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.brand, width: 2)),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '대표이사 이름으로 기업을 검색합니다.',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.borderLight))),
            child: SizedBox(
              width: double.infinity, height: 48,
              child: ElevatedButton(
                onPressed: () {
                  widget.onApply(_ctrl.text.trim());
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brand, foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusLg)),
                  textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                child: Text('적용${_ctrl.text.trim().isEmpty ? "" : " (\"${_ctrl.text.trim()}\")"}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
