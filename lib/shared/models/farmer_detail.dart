import 'enums.dart';

class FarmerDetail {
  final String id;
  final String farmerCode;
  final String firstName;
  final String lastName;
  final String fullName;
  final String phone;
  final String? email;
  final String? nationalId;
  final String agentId;
  final String agentName;
  final String lbcId;
  final String lbcName;
  final String region;
  final String district;
  final int farmsCount;
  final double totalFarmSize;
  final List<String> cropTypes;
  final double walletBalance;
  final double totalEarnings;
  final bool kycVerified;
  final FarmerStatus status;
  final String? rejectionReason;
  final double? lat;
  final double? lng;
  final DateTime joinedDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FarmerDetail({
    required this.id,
    required this.farmerCode,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.phone,
    this.email,
    this.nationalId,
    required this.agentId,
    required this.agentName,
    required this.lbcId,
    required this.lbcName,
    required this.region,
    required this.district,
    required this.farmsCount,
    required this.totalFarmSize,
    required this.cropTypes,
    required this.walletBalance,
    required this.totalEarnings,
    required this.kycVerified,
    required this.status,
    this.rejectionReason,
    this.lat,
    this.lng,
    required this.joinedDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FarmerDetail.fromJson(Map<String, dynamic> json) {
    final raw = (json['status'] as String? ?? '').toUpperCase();
    final status = switch (raw) {
      'APPROVED' => FarmerStatus.approved,
      'REJECTED' => FarmerStatus.rejected,
      _ => FarmerStatus.pending,
    };
    return FarmerDetail(
      id: json['id'] as String,
      farmerCode: json['farmerCode'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String?,
      nationalId: json['nationalId'] as String?,
      agentId: json['agentId'] as String? ?? '',
      agentName: json['agentName'] as String? ?? '',
      lbcId: json['lbcId'] as String? ?? '',
      lbcName: json['lbcName'] as String? ?? '',
      region: json['region'] as String? ?? '',
      district: json['district'] as String? ?? '',
      farmsCount: (json['farmsCount'] as num?)?.toInt() ?? 0,
      totalFarmSize: (json['totalFarmSize'] as num?)?.toDouble() ?? 0.0,
      cropTypes: (json['cropTypes'] as List<dynamic>?)?.cast<String>() ?? [],
      walletBalance: (json['walletBalance'] as num?)?.toDouble() ?? 0.0,
      totalEarnings: (json['totalEarnings'] as num?)?.toDouble() ?? 0.0,
      kycVerified: json['kycVerified'] as bool? ?? false,
      status: status,
      rejectionReason: json['rejectionReason'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      joinedDate: DateTime.tryParse(json['joinedDate'] as String? ?? '') ?? DateTime.now(),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
  }
}
