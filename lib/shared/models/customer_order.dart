import 'enums.dart';

class CustomerOrder {
  final String id;
  final String orderCode;
  final String customerId;
  final String customerName;
  final String produce;
  final double quantityKg;
  final double pricePerKg;
  final double totalAmount;
  final OrderStatus status;
  final String paymentStatus;
  final String? assignedAgent;
  final String? assignedDriver;
  final DateTime? orderDate;
  final DateTime? deliveryDate;
  final String region;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CustomerOrder({
    required this.id,
    required this.orderCode,
    required this.customerId,
    required this.customerName,
    required this.produce,
    required this.quantityKg,
    required this.pricePerKg,
    required this.totalAmount,
    required this.status,
    required this.paymentStatus,
    this.assignedAgent,
    this.assignedDriver,
    this.orderDate,
    this.deliveryDate,
    required this.region,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CustomerOrder.fromJson(Map<String, dynamic> json) {
    final raw = (json['status'] as String? ?? '').toUpperCase();
    final status = switch (raw) {
      'CONFIRMED'  => OrderStatus.confirmed,
      'PROCESSING' => OrderStatus.processing,
      'SHIPPED'    => OrderStatus.shipped,
      'DELIVERED'  => OrderStatus.delivered,
      'CANCELLED'  => OrderStatus.cancelled,
      _            => OrderStatus.pending,
    };
    return CustomerOrder(
      id:              json['id'] as String,
      orderCode:       json['orderCode'] as String? ?? '',
      customerId:      json['customerId'] as String? ?? '',
      customerName:    json['customerName'] as String? ?? '',
      produce:         json['produce'] as String? ?? '',
      quantityKg:      (json['quantityKg'] as num?)?.toDouble() ?? 0.0,
      pricePerKg:      (json['pricePerKg'] as num?)?.toDouble() ?? 0.0,
      totalAmount:     (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status:          status,
      paymentStatus:   json['paymentStatus'] as String? ?? 'UNPAID',
      assignedAgent:   json['assignedAgent'] as String?,
      assignedDriver:  json['assignedDriver'] as String?,
      orderDate:       json['orderDate'] != null
                           ? DateTime.tryParse(json['orderDate'] as String)
                           : null,
      deliveryDate:    json['deliveryDate'] != null
                           ? DateTime.tryParse(json['deliveryDate'] as String)
                           : null,
      region:          json['region'] as String? ?? '',
      createdAt:       DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      updatedAt:       DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
