import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/orders_repository.dart';
import '../../../../../app/core/utils/app_logger.dart';
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
    String? region,
    String? assignedAgent,
  }) async {
    state = const AsyncValue.loading();
    try {
      final body = {
        'produce': produce.toUpperCase(),
        'quantityKg': quantityKg,
        'pricePerKg': pricePerKg,
        'paymentType': paymentType,
        if (farmerId != null) 'farmerId': farmerId,
        if (agentId != null) 'agentId': agentId,
        if (region != null && region.isNotEmpty) 'region': region,
        if (assignedAgent != null && assignedAgent.isNotEmpty) 'assignedAgent': assignedAgent,
      };
      appLogger.d('[PlaceOrder] request body: $body');
      final order = await _repo.placeOrder(body);
      appLogger.d('[PlaceOrder] response: id=${order.id} status=${order.status}');
      state = AsyncValue.data(order);
      _ref.invalidate(allOrdersProvider);
      return true;
    } catch (e, s) {
      appLogger.e('[PlaceOrder] failed', error: e, stackTrace: s);
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
