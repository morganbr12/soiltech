import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/core/network/dio_provider.dart';
import '../../../shared/models/payment_record.dart';
import 'payments_api.dart';

final paymentsApiProvider = Provider<PaymentsApi>((ref) {
  return PaymentsApi(ref.watch(dioProvider));
});

final paymentsRepositoryProvider = Provider<PaymentsRepository>((ref) {
  return PaymentsRepository(ref.watch(paymentsApiProvider));
});

class PaymentsRepository {
  final PaymentsApi _api;

  PaymentsRepository(this._api);

  Future<List<PaymentRecord>> getPayments({
    int page = 1,
    String? status,
    String? farmerId,
  }) async {
    final response = await _api.getPayments(page: page, status: status, farmerId: farmerId);
    return response.data ?? [];
  }

  Future<PaymentRecord> getPayment(String id) async {
    final response = await _api.getPayment(id);
    return response.data!;
  }

  Future<PaymentRecord> markAsPaid(String id, String transactionRef, String method) async {
    final response = await _api.markAsPaid(id, {
      'transaction_ref': transactionRef,
      'payment_method': method,
    });
    return response.data!;
  }
}
