import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'pickup_request.freezed.dart';
part 'pickup_request.g.dart';

@freezed
abstract class PickupRequest with _$PickupRequest {
  const factory PickupRequest({
    required String id,
    required String produceRecordId,
    required String farmerId,
    required String farmerName,
    required String cropType,
    required double weightKg,
    required String pickupLocation,
    required double pickupLatitude,
    required double pickupLongitude,
    required String deliveryLocation,
    required LogisticsStatus status,
    required DateTime requestDate,
    String? driverName,
    String? driverPhone,
    String? vehicleNumber,
    DateTime? estimatedPickup,
    required SyncStatus syncStatus,
  }) = _PickupRequest;

  factory PickupRequest.fromJson(Map<String, dynamic> json) => _$PickupRequestFromJson(json);
}
