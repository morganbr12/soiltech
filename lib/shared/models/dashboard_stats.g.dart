// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardStats _$DashboardStatsFromJson(Map<String, dynamic> json) =>
    _DashboardStats(
      todayCollections: (json['todayCollections'] as num).toInt(),
      todayFarmers: (json['todayFarmers'] as num).toInt(),
      pendingUploads: (json['pendingUploads'] as num).toInt(),
      offlineRecords: (json['offlineRecords'] as num).toInt(),
      todayWeight: (json['todayWeight'] as num).toDouble(),
      weeklyWeight: (json['weeklyWeight'] as num).toDouble(),
      monthlyRevenue: (json['monthlyRevenue'] as num).toDouble(),
      activePickups: (json['activePickups'] as num).toInt(),
    );

Map<String, dynamic> _$DashboardStatsToJson(_DashboardStats instance) =>
    <String, dynamic>{
      'todayCollections': instance.todayCollections,
      'todayFarmers': instance.todayFarmers,
      'pendingUploads': instance.pendingUploads,
      'offlineRecords': instance.offlineRecords,
      'todayWeight': instance.todayWeight,
      'weeklyWeight': instance.weeklyWeight,
      'monthlyRevenue': instance.monthlyRevenue,
      'activePickups': instance.activePickups,
    };
