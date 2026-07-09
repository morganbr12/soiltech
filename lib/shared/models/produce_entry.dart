import 'enums.dart';

// Collection/harvest state
enum ProduceStatus { pending, collected, rejected }

extension ProduceStatusExtension on ProduceStatus {
  String get apiValue => switch (this) {
        ProduceStatus.pending => 'PENDING',
        ProduceStatus.collected => 'COLLECTED',
        ProduceStatus.rejected => 'REJECTED',
      };

  static ProduceStatus fromString(String? s) {
    return switch (s?.toUpperCase()) {
      'COLLECTED' => ProduceStatus.collected,
      'REJECTED' => ProduceStatus.rejected,
      _ => ProduceStatus.pending,
    };
  }
}

// Marketplace approval state
enum ListingStatus { pendingApproval, available, soldOut, unlisted, unknown }

extension ListingStatusExtension on ListingStatus {
  static ListingStatus fromString(String? s) {
    return switch (s?.toUpperCase()) {
      'AVAILABLE' => ListingStatus.available,
      'SOLD_OUT' => ListingStatus.soldOut,
      'UNLISTED' => ListingStatus.unlisted,
      'PENDING_APPROVAL' => ListingStatus.pendingApproval,
      null => ListingStatus.unknown,
      _ => ListingStatus.pendingApproval,
    };
  }
}

class ProduceEntry {
  final String id;
  final String farmerId;
  final String? farmId;
  final String agentId;
  final String cropType;
  final String? cropVariety;
  final String? grade;
  final double quantityKg;
  final double pricePerKg;
  final double totalAmount;
  final ProduceStatus status;
  final ListingStatus listingStatus;
  final DateTime? collectedAt;
  final String? notes;
  final List<String> photos;
  final SyncStatus syncStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProduceEntry({
    required this.id,
    required this.farmerId,
    this.farmId,
    required this.agentId,
    required this.cropType,
    this.cropVariety,
    this.grade,
    required this.quantityKg,
    required this.pricePerKg,
    required this.totalAmount,
    required this.status,
    this.listingStatus = ListingStatus.unknown,
    this.collectedAt,
    this.notes,
    required this.photos,
    required this.syncStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProduceEntry.fromJson(Map<String, dynamic> j) {
    return ProduceEntry(
      id: j['id'] as String,
      farmerId: j['farmerId'] as String,
      farmId: j['farmId'] as String?,
      agentId: j['agentId'] as String? ?? '',
      cropType: j['cropType'] as String? ?? '',
      cropVariety: j['cropVariety'] as String?,
      grade: j['grade'] as String?,
      quantityKg: (j['quantityKg'] as num?)?.toDouble() ?? 0,
      pricePerKg: (j['pricePerKg'] as num?)?.toDouble() ?? 0,
      totalAmount: (j['totalAmount'] as num?)?.toDouble() ?? 0,
      status: ProduceStatusExtension.fromString(j['status'] as String?),
      listingStatus: ListingStatusExtension.fromString(j['listingStatus'] as String?),
      collectedAt: j['collectedAt'] != null ? DateTime.tryParse(j['collectedAt'] as String) : null,
      notes: j['notes'] as String?,
      photos: (j['photos'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      syncStatus: _parseSyncStatus(j['syncStatus'] as String?),
      createdAt: DateTime.parse(j['createdAt'] as String),
      updatedAt: DateTime.parse(j['updatedAt'] as String),
    );
  }

  static SyncStatus _parseSyncStatus(String? s) => switch (s?.toUpperCase()) {
        'SYNCED' => SyncStatus.synced,
        'FAILED' => SyncStatus.failed,
        _ => SyncStatus.pending,
      };
}
