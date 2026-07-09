import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'customer_profile.freezed.dart';
part 'customer_profile.g.dart';

@freezed
abstract class DeliveryAddress with _$DeliveryAddress {
  const factory DeliveryAddress({
    required String id,
    required String label,
    required String fullAddress,
    required String city,
    required String region,
    @Default(false) bool isDefault,
    double? lat,
    double? lng,
  }) = _DeliveryAddress;

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) => _$DeliveryAddressFromJson(json);
}

@freezed
abstract class CustomerProfile with _$CustomerProfile {
  const factory CustomerProfile({
    required String id,
    required String fullName,
    required String phone,
    required String email,
    required CustomerAccountType accountType,
    String? profileImageUrl,
    @Default([]) List<DeliveryAddress> addresses,
    @Default(0) int totalOrders,
    required DateTime createdAt,
  }) = _CustomerProfile;

  factory CustomerProfile.fromJson(Map<String, dynamic> json) => _$CustomerProfileFromJson(json);
}
