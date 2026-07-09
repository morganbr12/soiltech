import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'customer_order.freezed.dart';
part 'customer_order.g.dart';

@freezed
abstract class OrderItem with _$OrderItem {
  const factory OrderItem({
    required String id,
    required String productId,
    required int quantity,
    required double unitPrice,
    required double subtotal,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);
}

@freezed
abstract class OrderTimeline with _$OrderTimeline {
  const factory OrderTimeline({
    required String id,
    required String status,
    required String note,
    required DateTime createdAt,
    required String createdBy,
  }) = _OrderTimeline;

  factory OrderTimeline.fromJson(Map<String, dynamic> json) => _$OrderTimelineFromJson(json);
}

@freezed
abstract class CustomerOrder with _$CustomerOrder {
  const factory CustomerOrder({
    required String id,
    required String customerId,
    required OrderStatus status,
    required double totalAmount,
    required String deliveryAddress,
    String? notes,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default([]) List<OrderItem> items,
    @Default([]) List<OrderTimeline> timeline,
    int? itemCount,
  }) = _CustomerOrder;

  factory CustomerOrder.fromJson(Map<String, dynamic> json) => _$CustomerOrderFromJson(json);
}
