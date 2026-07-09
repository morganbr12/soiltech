// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaymentRecord _$PaymentRecordFromJson(Map<String, dynamic> json) =>
    _PaymentRecord(
      id: json['id'] as String,
      farmerId: json['farmerId'] as String,
      farmerName: json['farmerName'] as String,
      farmerPhone: json['farmerPhone'] as String,
      produceRecordId: json['produceRecordId'] as String,
      cropType: json['cropType'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: $enumDecode(_$PaymentStatusEnumMap, json['status']),
      dueDate: DateTime.parse(json['dueDate'] as String),
      paidDate: json['paidDate'] == null
          ? null
          : DateTime.parse(json['paidDate'] as String),
      paymentMethod: json['paymentMethod'] as String,
      transactionRef: json['transactionRef'] as String?,
      syncStatus: $enumDecode(_$SyncStatusEnumMap, json['syncStatus']),
    );

Map<String, dynamic> _$PaymentRecordToJson(_PaymentRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'farmerId': instance.farmerId,
      'farmerName': instance.farmerName,
      'farmerPhone': instance.farmerPhone,
      'produceRecordId': instance.produceRecordId,
      'cropType': instance.cropType,
      'amount': instance.amount,
      'status': _$PaymentStatusEnumMap[instance.status]!,
      'dueDate': instance.dueDate.toIso8601String(),
      'paidDate': instance.paidDate?.toIso8601String(),
      'paymentMethod': instance.paymentMethod,
      'transactionRef': instance.transactionRef,
      'syncStatus': _$SyncStatusEnumMap[instance.syncStatus]!,
    };

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.processing: 'processing',
  PaymentStatus.paid: 'paid',
  PaymentStatus.failed: 'failed',
};

const _$SyncStatusEnumMap = {
  SyncStatus.synced: 'synced',
  SyncStatus.pending: 'pending',
  SyncStatus.failed: 'failed',
};
