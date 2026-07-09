import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/core/network/dio_provider.dart';
import '../../../app/core/theme/app_colors.dart';
import '../../../app/core/utils/app_logger.dart';

final notificationsRepositoryProvider = Provider<NotificationsRepository>((ref) {
  return NotificationsRepository(ref.watch(dioProvider));
});

// ─── Model ────────────────────────────────────────────────────────────────────

class ApiNotification {
  final String id;
  final String title;
  final String body;
  final String type;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic> data;

  ApiNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    required this.createdAt,
    required this.data,
  });

  factory ApiNotification.fromJson(Map<String, dynamic> j) => ApiNotification(
        id: j['id'] as String? ?? '',
        title: j['title'] as String? ?? '',
        body: j['body'] as String? ?? j['message'] as String? ?? '',
        type: j['type'] as String? ?? '',
        isRead: j['isRead'] as bool? ?? j['read'] as bool? ?? false,
        createdAt: j['createdAt'] != null
            ? DateTime.tryParse(j['createdAt'].toString()) ?? DateTime.now()
            : DateTime.now(),
        data: (j['data'] as Map<String, dynamic>?) ?? {},
      );

  ApiNotification copyWith({bool? isRead}) => ApiNotification(
        id: id,
        title: title,
        body: body,
        type: type,
        isRead: isRead ?? this.isRead,
        createdAt: createdAt,
        data: data,
      );

  IconData get icon => switch (type) {
        'PRODUCE_SUBMITTED' => Icons.upload_rounded,
        'PRODUCE_APPROVED' => Icons.check_circle_rounded,
        'PRODUCE_REJECTED' => Icons.cancel_rounded,
        'ORDER_PLACED' => Icons.shopping_bag_rounded,
        'ORDER_CONFIRMED' => Icons.verified_rounded,
        'ORDER_AGENT_CONFIRMED' => Icons.person_pin_circle_rounded,
        'ORDER_DRIVER_DISPATCHED' => Icons.local_shipping_rounded,
        'ORDER_SHIPPED' => Icons.directions_car_rounded,
        'ORDER_DELIVERED' => Icons.done_all_rounded,
        'ORDER_CANCELLED' => Icons.remove_circle_rounded,
        _ => Icons.notifications_rounded,
      };

  Color get color => switch (type) {
        'PRODUCE_SUBMITTED' => AppColors.info,
        'PRODUCE_APPROVED' => AppColors.success,
        'PRODUCE_REJECTED' => AppColors.error,
        'ORDER_PLACED' => AppColors.info,
        'ORDER_CONFIRMED' => AppColors.success,
        'ORDER_AGENT_CONFIRMED' => AppColors.primary,
        'ORDER_DRIVER_DISPATCHED' => const Color(0xFFF4A261),
        'ORDER_SHIPPED' => const Color(0xFF7B2FBE),
        'ORDER_DELIVERED' => AppColors.success,
        'ORDER_CANCELLED' => AppColors.error,
        _ => AppColors.primaryLight,
      };

  String get typeLabel => switch (type) {
        'PRODUCE_SUBMITTED' => 'Produce',
        'PRODUCE_APPROVED' => 'Approved',
        'PRODUCE_REJECTED' => 'Rejected',
        'ORDER_PLACED' => 'Order',
        'ORDER_CONFIRMED' => 'Confirmed',
        'ORDER_AGENT_CONFIRMED' => 'Field',
        'ORDER_DRIVER_DISPATCHED' => 'Dispatch',
        'ORDER_SHIPPED' => 'Shipped',
        'ORDER_DELIVERED' => 'Delivered',
        'ORDER_CANCELLED' => 'Cancelled',
        _ => type.replaceAll('_', ' ').toLowerCase(),
      };
}

// ─── Repository ───────────────────────────────────────────────────────────────

class NotificationsRepository {
  final Dio _dio;
  NotificationsRepository(this._dio);

  Future<List<ApiNotification>> getNotifications({int page = 1, int limit = 30}) async {
    final res = await _dio.get(
      '/notifications',
      queryParameters: {'page': page, 'limit': limit},
    );
    final list = res.data['data'] as List<dynamic>? ?? [];
    return list.map((e) => ApiNotification.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> markAsRead(String id) async {
    try {
      await _dio.patch('/notifications/$id/read');
    } catch (e) {
      appLogger.w('[Notifications] markAsRead failed: $e');
    }
  }

  Future<void> markAllRead() async {
    try {
      await _dio.patch('/notifications/read-all');
    } catch (e) {
      appLogger.w('[Notifications] markAllRead failed: $e');
    }
  }
}

// ─── Providers ────────────────────────────────────────────────────────────────

final notificationsListProvider = FutureProvider<List<ApiNotification>>((ref) {
  return ref.read(notificationsRepositoryProvider).getNotifications();
});
