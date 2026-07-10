import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/orders_repository.dart';
import '../../../../../shared/models/customer_order.dart';

final allOrdersProvider = FutureProvider<List<CustomerOrder>>((ref) {
  return ref.read(ordersRepositoryProvider).getOrders();
});

class PlaceOrderNotifier extends StateNotifier<AsyncValue<CustomerOrder?>> {
  final OrdersRepository _repo;
  final Ref _ref;

  PlaceOrderNotifier(this._repo, this._ref) : super(const AsyncValue.data(null));

  Future<bool> placeOrder({
    required String produce,
    required double quantityKg,
    required double pricePerKg,
    String paymentType = 'CASH',
    String? farmerId,
    String? agentId,
  }) async {
    state = const AsyncValue.loading();
    try {
      final order = await _repo.placeOrder({
        'produce': produce.toUpperCase(),
        'quantityKg': quantityKg,
        'pricePerKg': pricePerKg,
        'paymentType': paymentType,
        if (farmerId != null) 'farmerId': farmerId,
        if (agentId != null) 'agentId': agentId,
      });
      state = AsyncValue.data(order);
      _ref.invalidate(allOrdersProvider);
      return true;
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      return false;
    }
  }

  void reset() => state = const AsyncValue.data(null);
}

final placeOrderProvider =
    StateNotifierProvider<PlaceOrderNotifier, AsyncValue<CustomerOrder?>>(
  (ref) => PlaceOrderNotifier(ref.read(ordersRepositoryProvider), ref),
);
