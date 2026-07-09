// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'produce_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProduceRecord _$ProduceRecordFromJson(Map<String, dynamic> json) =>
    _ProduceRecord(
      id: json['id'] as String,
      farmerId: json['farmerId'] as String,
      farmerName: json['farmerName'] as String,
      farmId: json['farmId'] as String,
      cropType: json['cropType'] as String,
      weightKg: (json['weightKg'] as num).toDouble(),
      quantityBags: (json['quantityBags'] as num).toInt(),
      moisturePercent: (json['moisturePercent'] as num).toDouble(),
      qualityGrade: json['qualityGrade'] as String,
      status: $enumDecode(_$CollectionStatusEnumMap, json['status']),
      collectionDate: DateTime.parse(json['collectionDate'] as String),
      photoUrls:
          (json['photoUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      agentId: json['agentId'] as String,
      notes: json['notes'] as String? ?? '',
      pricePerKg: (json['pricePerKg'] as num).toDouble(),
      syncStatus: $enumDecode(_$SyncStatusEnumMap, json['syncStatus']),
    );

Map<String, dynamic> _$ProduceRecordToJson(_ProduceRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'farmerId': instance.farmerId,
      'farmerName': instance.farmerName,
      'farmId': instance.farmId,
      'cropType': instance.cropType,
      'weightKg': instance.weightKg,
      'quantityBags': instance.quantityBags,
      'moisturePercent': instance.moisturePercent,
      'qualityGrade': instance.qualityGrade,
      'status': _$CollectionStatusEnumMap[instance.status]!,
      'collectionDate': instance.collectionDate.toIso8601String(),
      'photoUrls': instance.photoUrls,
      'agentId': instance.agentId,
      'notes': instance.notes,
      'pricePerKg': instance.pricePerKg,
      'syncStatus': _$SyncStatusEnumMap[instance.syncStatus]!,
    };

const _$CollectionStatusEnumMap = {
  CollectionStatus.draft: 'draft',
  CollectionStatus.submitted: 'submitted',
  CollectionStatus.approved: 'approved',
  CollectionStatus.rejected: 'rejected',
};

const _$SyncStatusEnumMap = {
  SyncStatus.synced: 'synced',
  SyncStatus.pending: 'pending',
  SyncStatus.failed: 'failed',
};
