import 'enums.dart';

class AgentFarmer {
  final String id;
  final String farmerCode;
  final String fullName;
  final String phone;
  final String region;
  final String district;
  final String community;
  final List<String> cropTypes;
  final FarmerStatus status;
  final bool kycVerified;

  const AgentFarmer({
    required this.id,
    required this.farmerCode,
    required this.fullName,
    required this.phone,
    required this.region,
    required this.district,
    required this.community,
    required this.cropTypes,
    required this.status,
    required this.kycVerified,
  });

  factory AgentFarmer.fromJson(Map<String, dynamic> json) {
    final raw = (json['status'] as String? ?? '').toUpperCase();
    final status = switch (raw) {
      'APPROVED' => FarmerStatus.approved,
      'REJECTED' => FarmerStatus.rejected,
      _ => FarmerStatus.pending,
    };
    return AgentFarmer(
      id: json['id'] as String,
      farmerCode: json['farmerCode'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      region: json['region'] as String? ?? '',
      district: json['district'] as String? ?? '',
      community: json['community'] as String? ?? '',
      cropTypes: (json['cropTypes'] as List<dynamic>?)?.cast<String>() ?? [],
      status: status,
      kycVerified: json['kycVerified'] as bool? ?? false,
    );
  }

  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
  }
}
