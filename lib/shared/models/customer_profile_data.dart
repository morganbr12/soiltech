class CustomerProfileData {
  final String id;
  final String userId;
  final String fullName;
  final String? phone;
  final String? address;
  final String? profileImageUrl;
  final String? accountType;
  final String? location;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CustomerProfileData({
    required this.id,
    required this.userId,
    required this.fullName,
    this.phone,
    this.address,
    this.profileImageUrl,
    this.accountType,
    this.location,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CustomerProfileData.fromJson(Map<String, dynamic> json) =>
      CustomerProfileData(
        id: json['id'] as String,
        userId: json['userId'] as String,
        fullName: json['fullName'] as String,
        phone: json['phone'] as String?,
        address: json['address'] as String?,
        profileImageUrl: json['profileImageUrl'] as String?,
        accountType: json['accountType'] as String?,
        location: json['location'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}
