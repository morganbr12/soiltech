// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pickup_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PickupRequest _$PickupRequestFromJson(Map<String, dynamic> json) =>
    _PickupRequest(
      id: json['id'] as String,
      produceRecordId: json['produceRecordId'] as String,
      farmerId: json['farmerId'] as String,
      farmerName: json['farmerName'] as String,
      cropType: json['cropType'] as String,
      weightKg: (json['weightKg'] as num).toDouble(),
      pickupLocation: json['pickupLocation'] as String,
      pickupLatitude: (json['pickupLatitude'] as num).toDouble(),
      pickupLongitude: (json['pickupLongitude'] as num).toDouble(),
      deliveryLocation: json['deliveryLocation'] as String,
      status: $enumDecode(_$LogisticsStatusEnumMap, json['status']),
      requestDate: DateTime.parse(json['requestDate'] as String),
      driverName: json['driverName'] as String?,
      driverPhone: json['driverPhone'] as String?,
      vehicleNumber: json['vehicleNumber'] as String?,
      estimatedPickup: json['estimatedPickup'] == null
          ? null
          : DateTime.parse(json['estimatedPickup'] as String),
      syncStatus: $enumDecode(_$SyncStatusEnumMap, json['syncStatus']),
    );

Map<String, dynamic> _$PickupRequestToJson(_PickupRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'produceRecordId': instance.produceRecordId,
      'farmerId': instance.farmerId,
      'farmerName': instance.farmerName,
      'cropType': instance.cropType,
      'weightKg': instance.weightKg,
      'pickupLocation': instance.pickupLocation,
      'pickupLatitude': instance.pickupLatitude,
      'pickupLongitude': instance.pickupLongitude,
      'deliveryLocation': instance.deliveryLocation,
      'status': _$LogisticsStatusEnumMap[instance.status]!,
      'requestDate': instance.requestDate.toIso8601String(),
      'driverName': instance.driverName,
      'driverPhone': instance.driverPhone,
      'vehicleNumber': instance.vehicleNumber,
      'estimatedPickup': instance.estimatedPickup?.toIso8601String(),
      'syncStatus': _$SyncStatusEnumMap[instance.syncStatus]!,
    };

const _$LogisticsStatusEnumMap = {
  LogisticsStatus.pending: 'pending',
  LogisticsStatus.assigned: 'assigned',
  LogisticsStatus.inTransit: 'inTransit',
  LogisticsStatus.delivered: 'delivered',
};

const _$SyncStatusEnumMap = {
  SyncStatus.synced: 'synced',
  SyncStatus.pending: 'pending',
  SyncStatus.failed: 'failed',
};
