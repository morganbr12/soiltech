// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farm_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FarmModel _$FarmModelFromJson(Map<String, dynamic> json) => _FarmModel(
  id: json['id'] as String,
  farmerId: json['farmerId'] as String,
  name: json['name'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  sizeAcres: (json['sizeAcres'] as num).toDouble(),
  cropTypes:
      (json['cropTypes'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  region: json['region'] as String,
  district: json['district'] as String,
  community: json['community'] as String,
  registeredDate: DateTime.parse(json['registeredDate'] as String),
  harvestPeriod: json['harvestPeriod'] as String?,
  photoUrls:
      (json['photoUrls'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  syncStatus: $enumDecode(_$SyncStatusEnumMap, json['syncStatus']),
);

Map<String, dynamic> _$FarmModelToJson(_FarmModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'farmerId': instance.farmerId,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'sizeAcres': instance.sizeAcres,
      'cropTypes': instance.cropTypes,
      'region': instance.region,
      'district': instance.district,
      'community': instance.community,
      'registeredDate': instance.registeredDate.toIso8601String(),
      'harvestPeriod': instance.harvestPeriod,
      'photoUrls': instance.photoUrls,
      'syncStatus': _$SyncStatusEnumMap[instance.syncStatus]!,
    };

const _$SyncStatusEnumMap = {
  SyncStatus.synced: 'synced',
  SyncStatus.pending: 'pending',
  SyncStatus.failed: 'failed',
};
