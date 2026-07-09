import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'produce_record.freezed.dart';
part 'produce_record.g.dart';

@freezed
abstract class ProduceRecord with _$ProduceRecord {
  const ProduceRecord._();

  const factory ProduceRecord({
    required String id,
    required String farmerId,
    required String farmerName,
    required String farmId,
    required String cropType,
    required double weightKg,
    required int quantityBags,
    required double moisturePercent,
    required String qualityGrade,
    required CollectionStatus status,
    required DateTime collectionDate,
    @Default([]) List<String> photoUrls,
    required String agentId,
    @Default('') String notes,
    required double pricePerKg,
    required SyncStatus syncStatus,
  }) = _ProduceRecord;

  double get totalValue => weightKg * pricePerKg;

  factory ProduceRecord.fromJson(Map<String, dynamic> json) => _$ProduceRecordFromJson(json);
}
