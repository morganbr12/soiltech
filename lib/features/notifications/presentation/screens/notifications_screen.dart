import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/core/theme/app_colors.dart';
import '../../../../shared/extensions/extensions.dart';
import '../../../../shared/models/app_models.dart';
import '../../../../shared/models/dummy_data.dart';
import '../../../../shared/widgets/offline_banner.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<AppNotification> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = List.from(DummyData.notifications);
  }

  void _markAllRead() {
    setState(() {
      _notifications = _notifications.map((n) => AppNotification(
        id: n.id,
        title: n.title,
        body: n.body,
        type: n.type,
        timestamp: n.timestamp,
        isRead: true,
        data: n.data,
      )).toList();
    });
  }

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Notifications'),
            if (_unreadCount > 0)
              Text(
                '$_unreadCount unread',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
          ],
        ),
        centerTitle: false,
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child: const Text('Mark all read'),
            ),
          const SizedBox(width: 4),
        ],
      ),
      body: _notifications.isEmpty
          ? AppEmptyState(
              icon: Icons.notifications_none_rounded,
              title: 'No Notifications',
              subtitle: 'You\'re all caught up!',
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              itemCount: _notifications.length,
              itemBuilder: (_, i) {
                final n = _notifications[i];

                // Date separator
                bool showDateHeader = false;
                if (i == 0) {
                  showDateHeader = true;
                } else {
                  final prev = _notifications[i - 1];
                  showDateHeader = n.timestamp.day != prev.timestamp.day;
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showDateHeader)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Text(
                          _dateLabel(n.timestamp),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    _NotificationCard(
                      notification: n,
                      index: i,
                      onTap: () {
                        setState(() {
                          _notifications[i] = AppNotification(
                            id: n.id,
                            title: n.title,
                            body: n.body,
                            type: n.type,
                            timestamp: n.timestamp,
                            isRead: true,
                            data: n.data,
                          );
                        });
                      },
                    ),
                  ],
                );
              },
            ),
    );
  }

  String _dateLabel(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt).inDays;
    if (diff == 0) return 'TODAY';
    if (diff == 1) return 'YESTERDAY';
    return dt.shortDate.toUpperCase();
  }
}

class _NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final int index;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.notification,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = notification.type.color;
    final isUnread = !notification.isRead;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUnread
              ? (isDark
                  ? color.withValues(alpha: 0.08)
                  : color.withValues(alpha: 0.05))
              : (isDark ? AppColors.cardDark : AppColors.cardLight),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnread
                ? color.withValues(alpha: 0.25)
                : (isDark ? const Color(0xFF2A3A2A) : const Color(0xFFE8F0E8)),
            width: isUnread ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(notification.type.icon, size: 20, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isUnread ? FontWeight.w700 : FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(left: 6),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.body,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          notification.type.name.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: color,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        notification.timestamp.timeAgo,
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 50 * index))
        .fadeIn(duration: 300.ms)
        .slideX(begin: 0.03, end: 0);
  }
}
