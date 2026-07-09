import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_stats.freezed.dart';
part 'dashboard_stats.g.dart';

@freezed
abstract class DashboardStats with _$DashboardStats {
  const factory DashboardStats({
    required int todayCollections,
    required int todayFarmers,
    required int pendingUploads,
    required int offlineRecords,
    required double todayWeight,
    required double weeklyWeight,
    required double monthlyRevenue,
    required int activePickups,
  }) = _DashboardStats;

  factory DashboardStats.fromJson(Map<String, dynamic> json) => _$DashboardStatsFromJson(json);
}
