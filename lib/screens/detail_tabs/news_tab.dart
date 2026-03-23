import 'package:flutter/material.dart';
import '../../models/company.dart';
import '../../models/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

class NewsTab extends StatefulWidget {
  final Company company;
  const NewsTab({super.key, required this.company});

  @override
  State<NewsTab> createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
  bool _aiExpanded = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // ── AI 요약 ──
        _Section(
          icon: Icons.auto_awesome,
          title: 'AI 뉴스 분석',
          child: _buildAiSummary(),
        ),

        // ── 뉴스 리스트 ──
        _Section(
          icon: Icons.newspaper,
          title: '뉴스',
          trailing: '${newsItems.length}건',
          child: Column(
            children: [
              for (int i = 0; i < newsItems.length; i++) ...[
                _buildNewsCard(newsItems[i]),
                if (i < newsItems.length - 1)
                  const Divider(height: 1, color: AppColors.borderLight),
              ],
            ],
          ),
        ),

        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildAiSummary() {
    return GestureDetector(
      onTap: () => setState(() => _aiExpanded = !_aiExpanded),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.blue50,
              AppColors.purple50,
            ],
          ),
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          border: Border.all(color: AppColors.blue100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.brand,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  alignment: Alignment.center,
                  child: const Text('AI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
                const SizedBox(width: 8),
                const Text('AI 뉴스 분석', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.text)),
                const Spacer(),
                Icon(
                  _aiExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: 20,
                  color: AppColors.textSub,
                ),
              ],
            ),
            if (_aiExpanded) ...[
              const SizedBox(height: 10),
              const Text(
                '최근 에이치비테크놀로지 관련 뉴스는 긍정적 논조가 우세합니다. AI 검사장비 출시, 투자 유치, 고객사 확대 등 성장 모멘텀이 이어지고 있습니다.',
                style: TextStyle(fontSize: 13, color: AppColors.textSub, height: 1.6),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _SentimentChip(label: '긍정', count: 4, color: AppColors.emerald600, bgColor: AppColors.emerald50),
                  const SizedBox(width: 6),
                  _SentimentChip(label: '중립', count: 1, color: AppColors.amber600, bgColor: AppColors.amber50),
                  const SizedBox(width: 6),
                  _SentimentChip(label: '부정', count: 0, color: AppColors.red600, bgColor: AppColors.red50),
                ],
              ),
            ],
          ],
        ),
      ),
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

  Widget _buildNewsCard(NewsItem news) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.slate50,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(_newsIcon(news.emoji), size: 16, color: AppColors.brand),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news.title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.text, height: 1.3),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  news.summary,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSub, height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.slate50,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(news.source, style: const TextStyle(fontSize: 11, color: AppColors.textSub, fontWeight: FontWeight.w500)),
                    ),
                    const SizedBox(width: 8),
                    Text(news.time, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SentimentChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final Color bgColor;

  const _SentimentChip({required this.label, required this.count, required this.color, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$label $count건',
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
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
