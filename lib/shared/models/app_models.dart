import 'package:flutter/material.dart';

// ─── Enums ───────────────────────────────────────────────────────────────────

enum SyncStatus { synced, pending, failed }

enum CollectionStatus { draft, submitted, approved, rejected }

enum PaymentStatus { pending, processing, paid, failed }

enum LogisticsStatus { pending, assigned, inTransit, delivered }

enum FarmerStatus { active, inactive, suspended }

// ─── Farmer ──────────────────────────────────────────────────────────────────

class FarmerModel {
  final String id;
  final String name;
  final String phone;
  final String nationalId;
  final String region;
  final String district;
  final String community;
  final String avatarUrl;
  final FarmerStatus status;
  final DateTime registeredDate;
  final int totalFarms;
  final double totalAcreage;
  final List<FarmModel> farms;
  final List<String> crops;
  final double totalCollected;
  final SyncStatus syncStatus;

  const FarmerModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.nationalId,
    required this.region,
    required this.district,
    required this.community,
    required this.avatarUrl,
    required this.status,
    required this.registeredDate,
    required this.totalFarms,
    required this.totalAcreage,
    required this.farms,
    required this.crops,
    required this.totalCollected,
    required this.syncStatus,
  });
}

// ─── Farm ────────────────────────────────────────────────────────────────────

class FarmModel {
  final String id;
  final String farmerId;
  final String name;
  final double latitude;
  final double longitude;
  final double sizeAcres;
  final List<String> cropTypes;
  final String region;
  final String district;
  final String community;
  final DateTime registeredDate;
  final String? harvestPeriod;
  final List<String> photoUrls;
  final SyncStatus syncStatus;

  const FarmModel({
    required this.id,
    required this.farmerId,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.sizeAcres,
    required this.cropTypes,
    required this.region,
    required this.district,
    required this.community,
    required this.registeredDate,
    this.harvestPeriod,
    required this.photoUrls,
    required this.syncStatus,
  });
}

// ─── Produce Collection ──────────────────────────────────────────────────────

class ProduceRecord {
  final String id;
  final String farmerId;
  final String farmerName;
  final String farmId;
  final String cropType;
  final double weightKg;
  final int quantityBags;
  final double moisturePercent;
  final String qualityGrade;
  final CollectionStatus status;
  final DateTime collectionDate;
  final List<String> photoUrls;
  final String agentId;
  final String notes;
  final double pricePerKg;
  final SyncStatus syncStatus;

  const ProduceRecord({
    required this.id,
    required this.farmerId,
    required this.farmerName,
    required this.farmId,
    required this.cropType,
    required this.weightKg,
    required this.quantityBags,
    required this.moisturePercent,
    required this.qualityGrade,
    required this.status,
    required this.collectionDate,
    required this.photoUrls,
    required this.agentId,
    required this.notes,
    required this.pricePerKg,
    required this.syncStatus,
  });

  double get totalValue => weightKg * pricePerKg;
}

// ─── Logistics ────────────────────────────────────────────────────────────────

class PickupRequest {
  final String id;
  final String produceRecordId;
  final String farmerId;
  final String farmerName;
  final String cropType;
  final double weightKg;
  final String pickupLocation;
  final double pickupLatitude;
  final double pickupLongitude;
  final String deliveryLocation;
  final LogisticsStatus status;
  final DateTime requestDate;
  final String? driverName;
  final String? driverPhone;
  final String? vehicleNumber;
  final DateTime? estimatedPickup;
  final SyncStatus syncStatus;

  const PickupRequest({
    required this.id,
    required this.produceRecordId,
    required this.farmerId,
    required this.farmerName,
    required this.cropType,
    required this.weightKg,
    required this.pickupLocation,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.deliveryLocation,
    required this.status,
    required this.requestDate,
    this.driverName,
    this.driverPhone,
    this.vehicleNumber,
    this.estimatedPickup,
    required this.syncStatus,
  });
}

// ─── Payment ─────────────────────────────────────────────────────────────────

class PaymentRecord {
  final String id;
  final String farmerId;
  final String farmerName;
  final String farmerPhone;
  final String produceRecordId;
  final String cropType;
  final double amount;
  final PaymentStatus status;
  final DateTime dueDate;
  final DateTime? paidDate;
  final String paymentMethod;
  final String? transactionRef;
  final SyncStatus syncStatus;

  const PaymentRecord({
    required this.id,
    required this.farmerId,
    required this.farmerName,
    required this.farmerPhone,
    required this.produceRecordId,
    required this.cropType,
    required this.amount,
    required this.status,
    required this.dueDate,
    this.paidDate,
    required this.paymentMethod,
    this.transactionRef,
    required this.syncStatus,
  });
}

// ─── Notification ─────────────────────────────────────────────────────────────

class AppNotification {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final Map<String, dynamic> data;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.timestamp,
    required this.isRead,
    required this.data,
  });
}

enum NotificationType { announcement, alert, task, payment, sync }

extension NotificationTypeExtension on NotificationType {
  IconData get icon {
    switch (this) {
      case NotificationType.announcement:
        return Icons.campaign_outlined;
      case NotificationType.alert:
        return Icons.warning_amber_outlined;
      case NotificationType.task:
        return Icons.task_alt_outlined;
      case NotificationType.payment:
        return Icons.payments_outlined;
      case NotificationType.sync:
        return Icons.sync_outlined;
    }
  }

  Color get color {
    switch (this) {
      case NotificationType.announcement:
        return const Color(0xFF2D6A4F);
      case NotificationType.alert:
        return const Color(0xFFF4A261);
      case NotificationType.task:
        return const Color(0xFF2196F3);
      case NotificationType.payment:
        return const Color(0xFF40916C);
      case NotificationType.sync:
        return const Color(0xFF52B788);
    }
  }
}

// ─── Agent Profile ────────────────────────────────────────────────────────────

class AgentProfile {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String agentCode;
  final String region;
  final String district;
  final String avatarUrl;
  final int totalFarmersRegistered;
  final double totalProduceCollected;
  final int totalCollections;
  final double performanceScore;
  final DateTime joinDate;

  const AgentProfile({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.agentCode,
    required this.region,
    required this.district,
    required this.avatarUrl,
    required this.totalFarmersRegistered,
    required this.totalProduceCollected,
    required this.totalCollections,
    required this.performanceScore,
    required this.joinDate,
  });
}

// ─── User Role ────────────────────────────────────────────────────────────────

enum UserRole { agent, customer }

// ─── Customer Account Type ────────────────────────────────────────────────────

enum CustomerAccountType { individual, restaurant, retailShop, marketTrader, processor, exporter }

extension CustomerAccountTypeExtension on CustomerAccountType {
  String get label {
    switch (this) {
      case CustomerAccountType.individual: return 'Individual';
      case CustomerAccountType.restaurant: return 'Restaurant';
      case CustomerAccountType.retailShop: return 'Retail Shop';
      case CustomerAccountType.marketTrader: return 'Market Trader';
      case CustomerAccountType.processor: return 'Processor';
      case CustomerAccountType.exporter: return 'Exporter';
    }
  }

  String get icon {
    switch (this) {
      case CustomerAccountType.individual: return '👤';
      case CustomerAccountType.restaurant: return '🍽️';
      case CustomerAccountType.retailShop: return '🏪';
      case CustomerAccountType.marketTrader: return '🛒';
      case CustomerAccountType.processor: return '🏭';
      case CustomerAccountType.exporter: return '🚢';
    }
  }
}

// ─── Product Category ─────────────────────────────────────────────────────────

enum ProductCategory { tomatoes, pepper, onion, cabbage, carrot, lettuce, gardenEggs, okra, other }

extension ProductCategoryExtension on ProductCategory {
  String get label {
    switch (this) {
      case ProductCategory.tomatoes: return 'Tomatoes';
      case ProductCategory.pepper: return 'Pepper';
      case ProductCategory.onion: return 'Onion';
      case ProductCategory.cabbage: return 'Cabbage';
      case ProductCategory.carrot: return 'Carrot';
      case ProductCategory.lettuce: return 'Lettuce';
      case ProductCategory.gardenEggs: return 'Garden Eggs';
      case ProductCategory.okra: return 'Okra';
      case ProductCategory.other: return 'Other';
    }
  }

  String get emoji {
    switch (this) {
      case ProductCategory.tomatoes: return '🍅';
      case ProductCategory.pepper: return '🌶️';
      case ProductCategory.onion: return '🧅';
      case ProductCategory.cabbage: return '🥬';
      case ProductCategory.carrot: return '🥕';
      case ProductCategory.lettuce: return '🥗';
      case ProductCategory.gardenEggs: return '🍆';
      case ProductCategory.okra: return '🌿';
      case ProductCategory.other: return '🌾';
    }
  }
}

// ─── Order Status ─────────────────────────────────────────────────────────────

enum OrderStatus { pending, confirmed, preparing, onTheWay, delivered, cancelled }

extension OrderStatusExtension on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending: return 'Pending';
      case OrderStatus.confirmed: return 'Confirmed';
      case OrderStatus.preparing: return 'Preparing';
      case OrderStatus.onTheWay: return 'On the Way';
      case OrderStatus.delivered: return 'Delivered';
      case OrderStatus.cancelled: return 'Cancelled';
    }
  }

  Color get color {
    switch (this) {
      case OrderStatus.pending: return const Color(0xFFF4A261);
      case OrderStatus.confirmed: return const Color(0xFF2196F3);
      case OrderStatus.preparing: return const Color(0xFF9C27B0);
      case OrderStatus.onTheWay: return const Color(0xFF2D6A4F);
      case OrderStatus.delivered: return const Color(0xFF40916C);
      case OrderStatus.cancelled: return const Color(0xFFBA1A1A);
    }
  }
}

// ─── Message Type ─────────────────────────────────────────────────────────────

enum MessageType { text, image, deliveryUpdate }

// ─── Customer Profile ─────────────────────────────────────────────────────────

class CustomerProfile {
  final String id;
  final String fullName;
  final String phone;
  final String email;
  final CustomerAccountType accountType;
  final String? profileImageUrl;
  final List<DeliveryAddress> addresses;
  final int totalOrders;
  final DateTime createdAt;

  const CustomerProfile({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.accountType,
    this.profileImageUrl,
    this.addresses = const [],
    this.totalOrders = 0,
    required this.createdAt,
  });
}

// ─── Delivery Address ─────────────────────────────────────────────────────────

class DeliveryAddress {
  final String id;
  final String label;
  final String fullAddress;
  final String city;
  final String region;
  final bool isDefault;
  final double? lat;
  final double? lng;

  const DeliveryAddress({
    required this.id,
    required this.label,
    required this.fullAddress,
    required this.city,
    required this.region,
    this.isDefault = false,
    this.lat,
    this.lng,
  });
}

// ─── Product ─────────────────────────────────────────────────────────────────

class Product {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<String> galleryImages;
  final double pricePerUnit;
  final String unit;
  final double availableQuantity;
  final String farmerId;
  final String farmerName;
  final String lbcName;
  final String location;
  final double distanceKm;
  final double rating;
  final int reviewCount;
  final ProductCategory category;
  final DateTime harvestDate;
  final String freshnessLabel;
  final bool isFeatured;
  final bool isOnDeal;
  final double? originalPrice;
  final bool isAvailable;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.galleryImages,
    required this.pricePerUnit,
    required this.unit,
    required this.availableQuantity,
    required this.farmerId,
    required this.farmerName,
    required this.lbcName,
    required this.location,
    required this.distanceKm,
    required this.rating,
    required this.reviewCount,
    required this.category,
    required this.harvestDate,
    required this.freshnessLabel,
    this.isFeatured = false,
    this.isOnDeal = false,
    this.originalPrice,
    this.isAvailable = true,
  });

  double get discountPercent {
    if (originalPrice == null || originalPrice! <= pricePerUnit) return 0;
    return ((originalPrice! - pricePerUnit) / originalPrice!) * 100;
  }
}

// ─── Product Review ───────────────────────────────────────────────────────────

class ProductReview {
  final String id;
  final String reviewerName;
  final String? reviewerAvatar;
  final double rating;
  final String comment;
  final DateTime date;

  const ProductReview({
    required this.id,
    required this.reviewerName,
    this.reviewerAvatar,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

// ─── Customer Order ───────────────────────────────────────────────────────────

class CustomerOrder {
  final String id;
  final String orderNumber;
  final String customerId;
  final List<OrderItem> items;
  final OrderStatus status;
  final double totalAmount;
  final DeliveryAddress deliveryAddress;
  final DateTime createdAt;
  final DateTime? estimatedDelivery;
  final String? driverName;
  final String? driverPhone;
  final String? driverVehicle;
  final List<OrderTimeline> timeline;

  const CustomerOrder({
    required this.id,
    required this.orderNumber,
    required this.customerId,
    required this.items,
    required this.status,
    required this.totalAmount,
    required this.deliveryAddress,
    required this.createdAt,
    this.estimatedDelivery,
    this.driverName,
    this.driverPhone,
    this.driverVehicle,
    required this.timeline,
  });
}

// ─── Order Item ───────────────────────────────────────────────────────────────

class OrderItem {
  final String productId;
  final String productName;
  final String productImage;
  final double quantity;
  final String unit;
  final double pricePerUnit;

  const OrderItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.unit,
    required this.pricePerUnit,
  });

  double get subtotal => quantity * pricePerUnit;
}

// ─── Order Timeline ───────────────────────────────────────────────────────────

class OrderTimeline {
  final String event;
  final String description;
  final DateTime? timestamp;
  final bool isCompleted;

  const OrderTimeline({
    required this.event,
    required this.description,
    this.timestamp,
    required this.isCompleted,
  });
}

// ─── Chat ─────────────────────────────────────────────────────────────────────

class ChatConversation {
  final String id;
  final String otherUserId;
  final String otherUserName;
  final String? otherUserAvatar;
  final bool isOnline;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isAgent;

  const ChatConversation({
    required this.id,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserAvatar,
    required this.isOnline,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    this.isAgent = false,
  });
}

class ChatMessage {
  final String id;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final MessageType type;
  final bool isRead;
  final String? imageUrl;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.content,
    required this.timestamp,
    required this.type,
    required this.isRead,
    this.imageUrl,
  });
}

// ─── Dashboard Stats ──────────────────────────────────────────────────────────

class DashboardStats {
  final int todayCollections;
  final int todayFarmers;
  final int pendingUploads;
  final int offlineRecords;
  final double todayWeight;
  final double weeklyWeight;
  final double monthlyRevenue;
  final int activePickups;

  const DashboardStats({
    required this.todayCollections,
    required this.todayFarmers,
    required this.pendingUploads,
    required this.offlineRecords,
    required this.todayWeight,
    required this.weeklyWeight,
    required this.monthlyRevenue,
    required this.activePickups,
  });
}
