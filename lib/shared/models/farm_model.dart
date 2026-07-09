import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'farm_model.freezed.dart';
part 'farm_model.g.dart';

@freezed
abstract class FarmModel with _$FarmModel {
  const factory FarmModel({
    required String id,
    required String farmerId,
    required String name,
    required double latitude,
    required double longitude,
    required double sizeAcres,
    @Default([]) List<String> cropTypes,
    required String region,
    required String district,
    required String community,
    required DateTime registeredDate,
    String? harvestPeriod,
    @Default([]) List<String> photoUrls,
    required SyncStatus syncStatus,
  }) = _FarmModel;

  factory FarmModel.fromJson(Map<String, dynamic> json) => _$FarmModelFromJson(json);
}
