// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FarmerModel _$FarmerModelFromJson(Map<String, dynamic> json) => _FarmerModel(
  id: json['id'] as String,
  name: json['name'] as String,
  phone: json['phone'] as String,
  nationalId: json['nationalId'] as String,
  region: json['region'] as String,
  district: json['district'] as String,
  community: json['community'] as String,
  avatarUrl: json['avatarUrl'] as String,
  status: $enumDecode(_$FarmerStatusEnumMap, json['status']),
  registeredDate: DateTime.parse(json['registeredDate'] as String),
  totalFarms: (json['totalFarms'] as num).toInt(),
  totalAcreage: (json['totalAcreage'] as num).toDouble(),
  farms:
      (json['farms'] as List<dynamic>?)
          ?.map((e) => FarmModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  crops:
      (json['crops'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  totalCollected: (json['totalCollected'] as num).toDouble(),
  syncStatus: $enumDecode(_$SyncStatusEnumMap, json['syncStatus']),
);

Map<String, dynamic> _$FarmerModelToJson(_FarmerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'nationalId': instance.nationalId,
      'region': instance.region,
      'district': instance.district,
      'community': instance.community,
      'avatarUrl': instance.avatarUrl,
      'status': _$FarmerStatusEnumMap[instance.status]!,
      'registeredDate': instance.registeredDate.toIso8601String(),
      'totalFarms': instance.totalFarms,
      'totalAcreage': instance.totalAcreage,
      'farms': instance.farms,
      'crops': instance.crops,
      'totalCollected': instance.totalCollected,
      'syncStatus': _$SyncStatusEnumMap[instance.syncStatus]!,
    };

const _$FarmerStatusEnumMap = {
  FarmerStatus.pending: 'pending',
  FarmerStatus.approved: 'approved',
  FarmerStatus.rejected: 'rejected',
};

const _$SyncStatusEnumMap = {
  SyncStatus.synced: 'synced',
  SyncStatus.pending: 'pending',
  SyncStatus.failed: 'failed',
};
