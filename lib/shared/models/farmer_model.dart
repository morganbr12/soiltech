import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';
import 'farm_model.dart';

part 'farmer_model.freezed.dart';
part 'farmer_model.g.dart';

@freezed
abstract class FarmerModel with _$FarmerModel {
  const factory FarmerModel({
    required String id,
    required String name,
    required String phone,
    required String nationalId,
    required String region,
    required String district,
    required String community,
    required String avatarUrl,
    required FarmerStatus status,
    required DateTime registeredDate,
    required int totalFarms,
    required double totalAcreage,
    @Default([]) List<FarmModel> farms,
    @Default([]) List<String> crops,
    required double totalCollected,
    required SyncStatus syncStatus,
  }) = _FarmerModel;

  factory FarmerModel.fromJson(Map<String, dynamic> json) => _$FarmerModelFromJson(json);
}
