import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

class RangeFilterSheet extends StatefulWidget {
  final String title;
  final String unit;
  final double? initialMin;
  final double? initialMax;
  final List<(String label, double? min, double? max)> presets;
  final void Function(double? min, double? max) onApply;

  const RangeFilterSheet({
    super.key,
    required this.title,
    required this.unit,
    this.initialMin,
    this.initialMax,
    required this.presets,
    required this.onApply,
  });

  @override
  State<RangeFilterSheet> createState() => _RangeFilterSheetState();
}

class _RangeFilterSheetState extends State<RangeFilterSheet> {
  late TextEditingController _minCtrl;
  late TextEditingController _maxCtrl;
  int _selectedPreset = -1;

  @override
  void initState() {
    super.initState();
    _minCtrl = TextEditingController(text: widget.initialMin != null ? _fmt(widget.initialMin!) : '');
    _maxCtrl = TextEditingController(text: widget.initialMax != null ? _fmt(widget.initialMax!) : '');
    _matchPreset();
  }

  @override
  void dispose() {
    _minCtrl.dispose();
    _maxCtrl.dispose();
    super.dispose();
  }

  String _fmt(double v) {
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v.toString();
  }

  void _matchPreset() {
    final min = double.tryParse(_minCtrl.text);
    final max = double.tryParse(_maxCtrl.text);
    for (int i = 0; i < widget.presets.length; i++) {
      final p = widget.presets[i];
      if (p.$2 == min && p.$3 == max) {
        _selectedPreset = i;
        return;
      }
    }
    _selectedPreset = -1;
  }

  void _applyPreset(int index) {
    final p = widget.presets[index];
    setState(() {
      _minCtrl.text = p.$2 != null ? _fmt(p.$2!) : '';
      _maxCtrl.text = p.$3 != null ? _fmt(p.$3!) : '';
      _selectedPreset = index;
    });
  }

  void _clear() {
    setState(() {
      _minCtrl.clear();
      _maxCtrl.clear();
      _selectedPreset = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;
    final extra = keyboardHeight / screenHeight;
    return DraggableScrollableSheet(
      initialChildSize: (0.55 + extra).clamp(0.35, 0.95),
      maxChildSize: 0.95,
      minChildSize: 0.35,
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
                  Text(widget.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  if (_minCtrl.text.isNotEmpty || _maxCtrl.text.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.brand, borderRadius: BorderRadius.circular(10)),
                      child: const Text('1', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ],
                ]),
                GestureDetector(
                  onTap: _clear,
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
                // Min / Max fields
                Row(
                  children: [
                    Expanded(child: _buildField('최소', _minCtrl)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('~', style: TextStyle(fontSize: 18, color: AppColors.textMuted)),
                    ),
                    Expanded(child: _buildField('최대', _maxCtrl)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text('단위: ${widget.unit}', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text('빠른 선택', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    if (_selectedPreset >= 0)
                      GestureDetector(
                        onTap: () => setState(() => _selectedPreset = -1),
                        child: const Text('직접 입력', style: TextStyle(fontSize: 12, color: AppColors.brand, fontWeight: FontWeight.w500)),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(widget.presets.length, (i) {
                    final isActive = _selectedPreset == i;
                    return GestureDetector(
                      onTap: () => _applyPreset(i),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.blue50 : AppColors.slate50,
                          border: Border.all(color: isActive ? AppColors.brand : AppColors.border),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.presets[i].$1,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                            color: isActive ? AppColors.brand : AppColors.textSub,
                          ),
                        ),
                      ),
                    );
                  }),
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
                  final min = double.tryParse(_minCtrl.text);
                  final max = double.tryParse(_maxCtrl.text);
                  widget.onApply(min, max);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brand, foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusLg)),
                  textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                child: const Text('적용'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String hint, TextEditingController ctrl) {
    final isLocked = _selectedPreset >= 0;
    return TextField(
      controller: ctrl,
      readOnly: isLocked,
      enabled: !isLocked,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
      onChanged: (_) => setState(() => _matchPreset()),
      style: TextStyle(fontSize: 15, color: isLocked ? AppColors.textMuted : null),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        filled: isLocked,
        fillColor: isLocked ? AppColors.slate50 : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.borderLight)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.brand, width: 2)),
      ),
    );
  }
}
