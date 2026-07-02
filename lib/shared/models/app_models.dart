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
