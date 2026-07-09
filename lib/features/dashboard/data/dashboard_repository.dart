import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/core/network/dio_provider.dart';
import '../../../app/core/utils/app_logger.dart';
import '../../../shared/models/agent_activity.dart';
import '../../../shared/models/agent_dashboard.dart';
import '../../../shared/models/agent_profile.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(ref.watch(dioProvider));
});

class DashboardRepository {
  final Dio _dio;
  DashboardRepository(this._dio);

  Future<AgentDashboard> getDashboardStats() async {
    final res = await _dio.get('/agent/dashboard');
    final data = res.data['data'] as Map<String, dynamic>;
    return AgentDashboard.fromJson(data);
  }

  Future<AgentProfile> getAgentProfile() async {
    final res = await _dio.get('/agent/profile');
    final data = res.data['data'] as Map<String, dynamic>;
    return AgentProfile.fromJson(data);
  }

  Future<List<AgentActivity>> getRecentActivities({int limit = 5}) async {
    final res = await _dio.get('/agent/activities', queryParameters: {'limit': limit});
    final list = res.data['data'] as List<dynamic>? ?? [];
    return list
        .map((e) => AgentActivity.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<int> getUnreadNotificationCount() async {
    try {
      final res = await _dio.get('/notifications/unread-count');
      final data = res.data['data'] as Map<String, dynamic>?;
      return (data?['unreadCount'] as num?)?.toInt() ?? 0;
    } catch (e) {
      appLogger.w('Failed to fetch unread count: $e');
      return 0;
    }
  }
}
