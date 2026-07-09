import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'payment_record.freezed.dart';
part 'payment_record.g.dart';

@freezed
abstract class PaymentRecord with _$PaymentRecord {
  const factory PaymentRecord({
    required String id,
    required String farmerId,
    required String farmerName,
    required String farmerPhone,
    required String produceRecordId,
    required String cropType,
    required double amount,
    required PaymentStatus status,
    required DateTime dueDate,
    DateTime? paidDate,
    required String paymentMethod,
    String? transactionRef,
    required SyncStatus syncStatus,
  }) = _PaymentRecord;

  factory PaymentRecord.fromJson(Map<String, dynamic> json) => _$PaymentRecordFromJson(json);
}
