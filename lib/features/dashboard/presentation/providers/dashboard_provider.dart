import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/agent_activity.dart';
import '../../../../shared/models/agent_dashboard.dart';
import '../../../../shared/models/agent_profile.dart';
import '../../data/dashboard_repository.dart';

final agentDashboardProvider = FutureProvider<AgentDashboard>((ref) {
  return ref.watch(dashboardRepositoryProvider).getDashboardStats();
});

final agentProfileProvider = FutureProvider<AgentProfile>((ref) {
  return ref.watch(dashboardRepositoryProvider).getAgentProfile();
});

final recentActivitiesProvider = FutureProvider<List<AgentActivity>>((ref) {
  return ref.watch(dashboardRepositoryProvider).getRecentActivities();
});

final unreadNotificationCountProvider = FutureProvider<int>((ref) {
  return ref.watch(dashboardRepositoryProvider).getUnreadNotificationCount();
});
