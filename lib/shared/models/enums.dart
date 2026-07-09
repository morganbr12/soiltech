import 'package:flutter/material.dart';

enum SyncStatus { synced, pending, failed }

enum CollectionStatus { draft, submitted, approved, rejected }

enum PaymentStatus { pending, processing, paid, failed }

enum LogisticsStatus { pending, assigned, inTransit, delivered }

enum FarmerStatus { pending, approved, rejected }

enum UserRole { agent, customer }

enum MessageType { text, image, deliveryUpdate }

// ─── NotificationType ─────────────────────────────────────────────────────────

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

// ─── CustomerAccountType ──────────────────────────────────────────────────────

enum CustomerAccountType {
  individual,
  restaurant,
  retailShop,
  marketTrader,
  processor,
  exporter,
}

extension CustomerAccountTypeExtension on CustomerAccountType {
  String get label {
    switch (this) {
      case CustomerAccountType.individual:
        return 'Individual';
      case CustomerAccountType.restaurant:
        return 'Restaurant';
      case CustomerAccountType.retailShop:
        return 'Retail Shop';
      case CustomerAccountType.marketTrader:
        return 'Market Trader';
      case CustomerAccountType.processor:
        return 'Processor';
      case CustomerAccountType.exporter:
        return 'Exporter';
    }
  }

  String get icon {
    switch (this) {
      case CustomerAccountType.individual:
        return '👤';
      case CustomerAccountType.restaurant:
        return '🍽️';
      case CustomerAccountType.retailShop:
        return '🏪';
      case CustomerAccountType.marketTrader:
        return '🛒';
      case CustomerAccountType.processor:
        return '🏭';
      case CustomerAccountType.exporter:
        return '🚢';
    }
  }

  String get apiValue {
    switch (this) {
      case CustomerAccountType.individual:
        return 'individual';
      case CustomerAccountType.restaurant:
        return 'restaurant';
      case CustomerAccountType.retailShop:
        return 'retail_shop';
      case CustomerAccountType.marketTrader:
        return 'market_trader';
      case CustomerAccountType.processor:
        return 'processor';
      case CustomerAccountType.exporter:
        return 'exporter';
    }
  }
}

// ─── ProductCategory ──────────────────────────────────────────────────────────

enum ProductCategory {
  tomatoes,
  pepper,
  onion,
  cabbage,
  carrot,
  lettuce,
  gardenEggs,
  okra,
  other,
}

extension ProductCategoryExtension on ProductCategory {
  String get label {
    switch (this) {
      case ProductCategory.tomatoes:
        return 'Tomatoes';
      case ProductCategory.pepper:
        return 'Pepper';
      case ProductCategory.onion:
        return 'Onion';
      case ProductCategory.cabbage:
        return 'Cabbage';
      case ProductCategory.carrot:
        return 'Carrot';
      case ProductCategory.lettuce:
        return 'Lettuce';
      case ProductCategory.gardenEggs:
        return 'Garden Eggs';
      case ProductCategory.okra:
        return 'Okra';
      case ProductCategory.other:
        return 'Other';
    }
  }

  String get emoji {
    switch (this) {
      case ProductCategory.tomatoes:
        return '🍅';
      case ProductCategory.pepper:
        return '🌶️';
      case ProductCategory.onion:
        return '🧅';
      case ProductCategory.cabbage:
        return '🥬';
      case ProductCategory.carrot:
        return '🥕';
      case ProductCategory.lettuce:
        return '🥗';
      case ProductCategory.gardenEggs:
        return '🍆';
      case ProductCategory.okra:
        return '🌿';
      case ProductCategory.other:
        return '🌾';
    }
  }
}

// ─── OrderStatus ──────────────────────────────────────────────────────────────

enum OrderStatus { pending, confirmed, processing, shipped, active, delivered, cancelled }

extension OrderStatusExtension on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending:    return 'Pending';
      case OrderStatus.confirmed:  return 'Confirmed';
      case OrderStatus.processing: return 'Processing';
      case OrderStatus.shipped:    return 'Shipped';
      case OrderStatus.active:     return 'Active';
      case OrderStatus.delivered:  return 'Delivered';
      case OrderStatus.cancelled:  return 'Cancelled';
    }
  }

  Color get color {
    switch (this) {
      case OrderStatus.pending:    return const Color(0xFFF4A261);
      case OrderStatus.confirmed:  return const Color(0xFF2196F3);
      case OrderStatus.processing: return const Color(0xFF9C27B0);
      case OrderStatus.shipped:    return const Color(0xFF2D6A4F);
      case OrderStatus.active:     return const Color(0xFF40916C);
      case OrderStatus.delivered:  return const Color(0xFF52B788);
      case OrderStatus.cancelled:  return const Color(0xFFBA1A1A);
    }
  }

  bool get isActive =>
      this == OrderStatus.active ||
      this == OrderStatus.confirmed ||
      this == OrderStatus.processing ||
      this == OrderStatus.shipped;
}
