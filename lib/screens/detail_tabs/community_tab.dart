import 'package:flutter/material.dart';
import '../../models/company.dart';
import '../../models/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

class CommunityTab extends StatefulWidget {
  final Company company;
  const CommunityTab({super.key, required this.company});

  @override
  State<CommunityTab> createState() => _CommunityTabState();
}

class _CommunityTabState extends State<CommunityTab> {
  final Set<int> _likedPosts = {};
  final Set<String> _followedUsers = {};

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          key: const PageStorageKey('community'),
          padding: EdgeInsets.zero,
          children: [
            _Section(
              icon: Icons.forum,
              title: '커뮤니티',
              trailing: '${communityPosts.length}개 글',
              child: Column(
                children: List.generate(communityPosts.length, (i) {
                  final post = communityPosts[i];
                  return _buildPostCard(post, i);
                }),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
        Positioned(
          right: 16,
          bottom: 24,
          child: FloatingActionButton(
            onPressed: () => _showComposeSheet(context),
            backgroundColor: AppColors.brand,
            elevation: 4,
            child: const Icon(Icons.edit, color: Colors.white, size: 22),
          ),
        ),
      ],
    );
  }

  Widget _buildPostCard(CommunityPost post, int index) {
    final isLiked = _likedPosts.contains(index);
    final isFollowed = _followedUsers.contains(post.username);
    final likeCount = post.likes + (isLiked ? 1 : 0);

    return GestureDetector(
      onTap: () => _showThreadSheet(context, post, index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppTheme.radius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: post.avatarColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    post.avatar,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(post.username, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          if (post.badge != null) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: AppColors.amber50,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                post.badge!,
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.amber600),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                if (!isFollowed)
                  GestureDetector(
                    onTap: () => setState(() => _followedUsers.add(post.username)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.brand),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('팔로우', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.brand)),
                    ),
                  )
                else
                  GestureDetector(
                    onTap: () => setState(() => _followedUsers.remove(post.username)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.brand,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('팔로잉', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              post.title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.text),
            ),
            const SizedBox(height: 4),
            Text(
              post.body,
              style: const TextStyle(fontSize: 13, color: AppColors.textSub, height: 1.5),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            // Bottom actions
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isLiked) {
                        _likedPosts.remove(index);
                      } else {
                        _likedPosts.add(index);
                      }
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        size: 16,
                        color: isLiked ? AppColors.red600 : AppColors.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$likeCount',
                        style: TextStyle(
                          fontSize: 12,
                          color: isLiked ? AppColors.red600 : AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => _showThreadSheet(context, post, index),
                  child: Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline, size: 15, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Text('${post.comments}', style: const TextStyle(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('링크가 복사되었습니다'), duration: Duration(seconds: 1)),
                    );
                  },
                  child: const Icon(Icons.share_outlined, size: 15, color: AppColors.textMuted),
                ),
                const Spacer(),
                Text(post.time, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Thread / Detail Bottom Sheet ──
  void _showThreadSheet(BuildContext context, CommunityPost post, int index) {
    final commentController = TextEditingController();

    final mockComments = _getMockComments(post);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            final liked = _likedPosts.contains(index);
            final followed = _followedUsers.contains(post.username);
            final likeCount = post.likes + (liked ? 1 : 0);

            return DraggableScrollableSheet(
              initialChildSize: 0.85,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              builder: (_, scrollCtrl) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Column(
                    children: [
                      // Handle bar
                      Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 4),
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.slate200,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      // Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            const Text('글 상세', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                            const Spacer(),
                            GestureDetector(
                              onTap: () => Navigator.pop(ctx),
                              child: const Icon(Icons.close, size: 22, color: AppColors.textSub),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: AppColors.borderLight),
                      // Content
                      Expanded(
                        child: ListView(
                          controller: scrollCtrl,
                          padding: const EdgeInsets.all(16),
                          children: [
                            // Author header
                            Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: post.avatarColor,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(post.avatar, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(post.username, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                                          if (post.badge != null) ...[
                                            const SizedBox(width: 6),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                              decoration: BoxDecoration(
                                                color: AppColors.amber50,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text(post.badge!, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.amber600)),
                                            ),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(post.time, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (followed) {
                                        _followedUsers.remove(post.username);
                                      } else {
                                        _followedUsers.add(post.username);
                                      }
                                    });
                                    setSheetState(() {});
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: followed ? AppColors.brand : Colors.white,
                                      border: Border.all(color: AppColors.brand),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      followed ? '팔로잉' : '팔로우',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: followed ? Colors.white : AppColors.brand),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Title
                            Text(post.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.text, height: 1.4)),
                            const SizedBox(height: 10),
                            // Full body (no maxLines)
                            Text(post.body, style: const TextStyle(fontSize: 14, color: AppColors.textSub, height: 1.7)),
                            const SizedBox(height: 16),
                            // Action bar
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: AppColors.borderLight),
                                  bottom: BorderSide(color: AppColors.borderLight),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (liked) {
                                          _likedPosts.remove(index);
                                        } else {
                                          _likedPosts.add(index);
                                        }
                                      });
                                      setSheetState(() {});
                                    },
                                    child: Row(
                                      children: [
                                        Icon(liked ? Icons.favorite : Icons.favorite_border, size: 20, color: liked ? AppColors.red600 : AppColors.textSub),
                                        const SizedBox(width: 6),
                                        Text('좋아요 $likeCount', style: TextStyle(fontSize: 13, color: liked ? AppColors.red600 : AppColors.textSub, fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.chat_bubble_outline, size: 18, color: AppColors.textSub),
                                      const SizedBox(width: 6),
                                      Text('댓글 ${post.comments}', style: const TextStyle(fontSize: 13, color: AppColors.textSub, fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('링크가 복사되었습니다'), duration: Duration(seconds: 1)),
                                      );
                                    },
                                    child: const Row(
                                      children: [
                                        Icon(Icons.share_outlined, size: 18, color: AppColors.textSub),
                                        SizedBox(width: 6),
                                        Text('공유', style: TextStyle(fontSize: 13, color: AppColors.textSub, fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Comments header
                            Text('댓글 ${mockComments.length}개', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 12),
                            // Comments list
                            ...mockComments.map((c) => _buildComment(c)),
                          ],
                        ),
                      ),
                      // Comment input
                      Container(
                        padding: EdgeInsets.only(
                          left: 16, right: 8, top: 8,
                          bottom: MediaQuery.of(ctx).viewInsets.bottom + 8,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(top: BorderSide(color: AppColors.borderLight)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: commentController,
                                decoration: InputDecoration(
                                  hintText: '댓글을 입력하세요...',
                                  hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(color: AppColors.borderLight),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(color: AppColors.borderLight),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(color: AppColors.brand),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  isDense: true,
                                ),
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (commentController.text.trim().isNotEmpty) {
                                  commentController.clear();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('댓글이 등록되었습니다'), duration: Duration(seconds: 1)),
                                  );
                                }
                              },
                              icon: const Icon(Icons.send, size: 20, color: AppColors.brand),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildComment(_MockComment comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: comment.color,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(comment.avatar, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(comment.username, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    Text(comment.time, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(comment.text, style: const TextStyle(fontSize: 13, color: AppColors.textSub, height: 1.5)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.favorite_border, size: 13, color: AppColors.textMuted),
                    const SizedBox(width: 3),
                    Text('${comment.likes}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                    const SizedBox(width: 14),
                    const Text('답글', style: TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Compose New Post Sheet ──
  void _showComposeSheet(BuildContext context) {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 4),
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.slate200,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: const Text('취소', style: TextStyle(fontSize: 14, color: AppColors.textSub)),
                      ),
                      const Spacer(),
                      const Text('글쓰기', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(ctx);
                          if (titleController.text.trim().isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('글이 등록되었습니다'), duration: Duration(seconds: 1)),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.brand,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text('등록', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: AppColors.borderLight),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          hintText: '제목을 입력하세요',
                          hintStyle: TextStyle(fontSize: 15, color: AppColors.textMuted, fontWeight: FontWeight.w600),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: bodyController,
                        maxLines: 6,
                        decoration: const InputDecoration(
                          hintText: '내용을 입력하세요...',
                          hintStyle: TextStyle(fontSize: 14, color: AppColors.textMuted),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                        style: const TextStyle(fontSize: 14, height: 1.6),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Mock Comments per Post ──
  List<_MockComment> _getMockComments(CommunityPost post) {
    if (post.username == '김영호') {
      return const [
        _MockComment(username: '박지현', avatar: '박', color: Color(0xFF059669), text: '저도 써봤는데 동감합니다. 특히 검사 속도가 빨라서 라인 효율이 확 올랐어요.', time: '2시간 전', likes: 5),
        _MockComment(username: '이준서', avatar: '이', color: Color(0xFFF59E0B), text: 'A/S 빠른 건 진짜 큰 장점이죠. 일본 장비는 A/S만 2주 걸리는데...', time: '1시간 전', likes: 3),
        _MockComment(username: '최서윤', avatar: '최', color: Color(0xFF8B5CF6), text: '어떤 라인에서 사용하셨는지 궁금합니다. 후공정 검사에도 적합할까요?', time: '30분 전', likes: 1),
      ];
    } else if (post.username == '박지현') {
      return const [
        _MockComment(username: '김영호', avatar: '김', color: Color(0xFF0549CC), text: 'AI 기반이라 불량 패턴 학습이 되는 게 인상적이었어요.', time: '4시간 전', likes: 2),
        _MockComment(username: '이준서', avatar: '이', color: Color(0xFFF59E0B), text: '정확도 수치가 공개되어 있나요?', time: '3시간 전', likes: 1),
      ];
    } else if (post.username == '이준서') {
      return const [
        _MockComment(username: '최서윤', avatar: '최', color: Color(0xFF8B5CF6), text: '국산화 트렌드 + AI 반도체 수요가 겹치면서 수혜 기대되네요.', time: '20시간 전', likes: 4),
        _MockComment(username: '김영호', avatar: '김', color: Color(0xFF0549CC), text: '해외 진출도 본격화되면 성장세 더 가팔라질 것 같습니다.', time: '18시간 전', likes: 3),
        _MockComment(username: '박지현', avatar: '박', color: Color(0xFF059669), text: '재무 수치도 안정적이고 좋아 보입니다.', time: '12시간 전', likes: 2),
      ];
    } else {
      return const [
        _MockComment(username: '김영호', avatar: '김', color: Color(0xFF0549CC), text: '저도 같은 생각입니다. 후공정 장비 수요는 앞으로도 꾸준할 것 같아요.', time: '1일 전', likes: 2),
        _MockComment(username: '이준서', avatar: '이', color: Color(0xFFF59E0B), text: 'AI 반도체 쪽 테스트 장비도 기회가 커 보입니다.', time: '1일 전', likes: 1),
      ];
    }
  }
}

// ── Mock Comment Data ──
class _MockComment {
  final String username;
  final String avatar;
  final Color color;
  final String text;
  final String time;
  final int likes;

  const _MockComment({
    required this.username,
    required this.avatar,
    required this.color,
    required this.text,
    required this.time,
    required this.likes,
  });
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
