import 'package:flutter/material.dart';
import '../../models/company.dart';
import '../../models/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/charts/donut_chart.dart';
import '../../widgets/charts/area_chart.dart';

class PeopleTab extends StatelessWidget {
  final Company company;
  const PeopleTab({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const PageStorageKey('people'),
      padding: EdgeInsets.zero,
      children: [
        // ── 대표자 정보 ──
        _Section(
          icon: Icons.person,
          title: '대표자 정보',
          child: Column(
            children: [
              _buildCeoCard(),
              const SizedBox(height: 12),
              const Row(
                children: [
                  Expanded(child: _MiniMetric(label: '경력', value: '삼성전자 출신', fontSize: 14)),
                  SizedBox(width: 8),
                  Expanded(child: _MiniMetric(label: '보유 주식', value: '42%', fontSize: 14)),
                  SizedBox(width: 8),
                  Expanded(child: _MiniMetric(label: '취임', value: '2011년', fontSize: 14)),
                ],
              ),
            ],
          ),
        ),

        // ── 경영진 현황 ──
        _Section(
          icon: Icons.work_outline,
          title: '경영진 현황',
          trailing: '${executives.length}명',
          child: Column(
            children: executives.where((e) => e.role != '대표이사').map((e) => _buildExecutiveCard(e)).toList(),
          ),
        ),

        // ── 명함 열람 ──
        _Section(
          icon: Icons.contact_page_outlined,
          title: '명함 열람',
          child: _buildBusinessCardGrid(),
        ),

        // ── 주주현황 상세 ──
        _Section(
          icon: Icons.bar_chart,
          title: '주주현황 상세',
          child: DonutChartWidget(
            values: shareholders.map((s) => s.pct).toList(),
            colors: shareholders.map((s) => s.color).toList(),
            labels: shareholders.map((s) => s.label).toList(),
            centerLabel: '주주현황',
            centerValue: '${shareholders.length}명',
          ),
        ),

        // ── 인원현황 추이 ──
        _Section(
          icon: Icons.trending_up,
          title: '인원현황 추이',
          child: Column(
            children: [
              AreaChartWidget(
                labels: years,
                values: employeeHistory,
                primaryColor: AppColors.brand,
                primaryLabel: '인원',
                height: 180,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _MiniMetric(label: '총 인원', value: '${company.employees}명')),
                  const SizedBox(width: 8),
                  const Expanded(child: _MiniMetric(label: '전년 대비', value: '+8%', isPositive: true)),
                  const SizedBox(width: 8),
                  const Expanded(child: _MiniMetric(label: '평균 근속', value: '4.2년')),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildCeoCard() {
    final ceo = executives.firstWhere((e) => e.role == '대표이사', orElse: () => executives.first);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: company.color,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              ceo.name.substring(0, 1),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ceo.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(
                  '${ceo.role} · ${ceo.dept}부문',
                  style: const TextStyle(fontSize: 13, color: AppColors.textSub),
                ),
                const SizedBox(height: 2),
                Text(
                  '${ceo.since}년~ 재직',
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Opacity(
                opacity: 0.4,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.slate100,
                    borderRadius: BorderRadius.circular(AppTheme.radius),
                  ),
                  child: const Icon(Icons.phone_outlined, size: 18, color: AppColors.slate300),
                ),
              ),
              const SizedBox(height: 8),
              Opacity(
                opacity: 0.4,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.slate100,
                    borderRadius: BorderRadius.circular(AppTheme.radius),
                  ),
                  child: const Icon(Icons.email_outlined, size: 18, color: AppColors.slate300),
                ),
              ),
              const SizedBox(height: 4),
              const Text('명함 필요', style: TextStyle(fontSize: 9, color: AppColors.textMuted)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExecutiveCard(Executive exec) {
    return Container(
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
            decoration: BoxDecoration(
              color: exec.color,
              shape: BoxShape.circle,
            ),
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
    );
  }

  Widget _buildBusinessCardGrid() {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: executives.map((exec) => _buildBusinessCard(exec)).toList(),
    );
  }

  Widget _buildBusinessCard(Executive exec) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderLight),
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: exec.color,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              exec.name.substring(0, 1),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            exec.name,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          Text(
            '${exec.role} · ${exec.dept}',
            style: const TextStyle(fontSize: 11, color: AppColors.textSub),
            overflow: TextOverflow.ellipsis,
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
  final Widget child;

  const _Section({required this.icon, required this.title, this.trailing, required this.child});

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
                Text(trailing!, style: const TextStyle(fontSize: 12, color: AppColors.textSub, fontWeight: FontWeight.w500)),
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

class _MiniMetric extends StatelessWidget {
  final String label;
  final String value;
  final bool isPositive;
  final double? fontSize;

  const _MiniMetric({required this.label, required this.value, this.isPositive = false, this.fontSize});

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
              fontSize: fontSize ?? 16,
              fontWeight: FontWeight.w700,
              color: isPositive ? AppColors.emerald600 : AppColors.text,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
