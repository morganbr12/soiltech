import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../app/core/theme/app_colors.dart';
import '../../data/chats_repository.dart';
import 'conversation_screen.dart';

class ChatsScreen extends ConsumerWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatsAsync = ref.watch(chatListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF5F7F5),
      appBar: AppBar(
        title: chatsAsync.maybeWhen(
          data: (chats) {
            final unread = chats.fold(0, (s, c) => s + c.unreadCount);
            return Row(children: [
              const Text('Messages', style: TextStyle(fontWeight: FontWeight.w700)),
              if (unread > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: const Color(0xFFE63946), borderRadius: BorderRadius.circular(10)),
                  child: Text('$unread', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                ),
              ],
            ]);
          },
          orElse: () => const Text('Messages', style: TextStyle(fontWeight: FontWeight.w700)),
        ),
        backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF5F7F5),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(chatListProvider),
          ),
        ],
      ),
      body: chatsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.chat_bubble_outline_rounded, size: 56, color: AppColors.primaryLight),
            const SizedBox(height: 12),
            const Text('Could not load messages', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => ref.invalidate(chatListProvider),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ]),
        ),
        data: (chats) => chats.isEmpty
            ? _EmptyChats().animate().fadeIn(duration: 400.ms)
            : RefreshIndicator(
                onRefresh: () async => ref.invalidate(chatListProvider),
                color: AppColors.primary,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 100),
                  itemCount: chats.length,
                  separatorBuilder: (_, idx) => Divider(
                    height: 1, indent: 72,
                    color: isDark ? const Color(0xFF2A3A2A) : const Color(0xFFE8F0E8),
                  ),
                  itemBuilder: (_, i) => _ChatTile(thread: chats[i])
                      .animate(delay: Duration(milliseconds: 50 * i))
                      .fadeIn(duration: 300.ms)
                      .slideX(begin: 0.04, end: 0),
                ),
              ),
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  final ChatThread thread;
  const _ChatTile({required this.thread});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasUnread = thread.unreadCount > 0;

    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ConversationScreen(thread: thread)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 26,
              backgroundColor: AppColors.primaryContainer,
              child: Text(
                thread.lbcName.isNotEmpty ? thread.lbcName[0].toUpperCase() : 'L',
                style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary, fontSize: 18),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(
                      child: Text(thread.lbcName,
                          style: TextStyle(fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w600, fontSize: 14),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: thread.isOpen ? AppColors.success.withValues(alpha: 0.12) : Colors.grey.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        thread.isOpen ? 'Open' : 'Closed',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                            color: thread.isOpen ? AppColors.success : Colors.grey),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 3),
                  Text(thread.topic,
                      style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 3),
                  Row(children: [
                    Expanded(
                      child: Text(thread.lastMessage,
                          style: TextStyle(fontSize: 12,
                              color: hasUnread ? theme.colorScheme.onSurface : theme.colorScheme.onSurfaceVariant,
                              fontWeight: hasUnread ? FontWeight.w500 : FontWeight.w400),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                    if (hasUnread)
                      Container(
                        width: 20, height: 20,
                        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                        child: Center(child: Text('${thread.unreadCount}',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700))),
                      ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyChats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.chat_bubble_outline_rounded, size: 72,
            color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
        const SizedBox(height: 16),
        const Text('No conversations yet', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text('Start a chat from a product page',
            style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ]),
    );
  }
}
