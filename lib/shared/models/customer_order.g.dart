// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => _OrderItem(
  id: json['id'] as String,
  productId: json['productId'] as String,
  quantity: (json['quantity'] as num).toInt(),
  unitPrice: (json['unitPrice'] as num).toDouble(),
  subtotal: (json['subtotal'] as num).toDouble(),
);

Map<String, dynamic> _$OrderItemToJson(_OrderItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
      'subtotal': instance.subtotal,
    };

_OrderTimeline _$OrderTimelineFromJson(Map<String, dynamic> json) =>
    _OrderTimeline(
      id: json['id'] as String,
      status: json['status'] as String,
      note: json['note'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      createdBy: json['createdBy'] as String,
    );

Map<String, dynamic> _$OrderTimelineToJson(_OrderTimeline instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'note': instance.note,
      'createdAt': instance.createdAt.toIso8601String(),
      'createdBy': instance.createdBy,
    };

_CustomerOrder _$CustomerOrderFromJson(Map<String, dynamic> json) =>
    _CustomerOrder(
      id: json['id'] as String,
      customerId: json['customerId'] as String,
      status: $enumDecode(_$OrderStatusEnumMap, json['status']),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      deliveryAddress: json['deliveryAddress'] as String,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      timeline:
          (json['timeline'] as List<dynamic>?)
              ?.map((e) => OrderTimeline.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      itemCount: (json['itemCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CustomerOrderToJson(_CustomerOrder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'status': _$OrderStatusEnumMap[instance.status]!,
      'totalAmount': instance.totalAmount,
      'deliveryAddress': instance.deliveryAddress,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'items': instance.items,
      'timeline': instance.timeline,
      'itemCount': instance.itemCount,
    };

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.confirmed: 'confirmed',
  OrderStatus.processing: 'processing',
  OrderStatus.shipped: 'shipped',
  OrderStatus.active: 'active',
  OrderStatus.delivered: 'delivered',
  OrderStatus.cancelled: 'cancelled',
};
