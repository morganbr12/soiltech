import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/orders_repository.dart';
import '../../../../../shared/models/customer_order.dart';

final allOrdersProvider = FutureProvider<List<CustomerOrder>>((ref) {
  return ref.read(ordersRepositoryProvider).getOrders();
});

final orderDetailProvider =
    FutureProvider.family<CustomerOrder, String>((ref, id) {
  return ref.read(ordersRepositoryProvider).getOrder(id);
});

class PlaceOrderNotifier extends StateNotifier<AsyncValue<CustomerOrder?>> {
  final OrdersRepository _repo;
  final Ref _ref;

  PlaceOrderNotifier(this._repo, this._ref) : super(const AsyncValue.data(null));

  Future<bool> placeOrder({
    required String deliveryAddress,
    required String productId,
    required int quantity,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    try {
      final order = await _repo.placeOrder({
        'deliveryAddress': deliveryAddress,
        'items': [
          {'productId': productId, 'quantity': quantity},
        ],
        if (notes != null && notes.isNotEmpty) 'notes': notes,
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
    StateNotifierProvider.autoDispose<PlaceOrderNotifier, AsyncValue<CustomerOrder?>>(
  (ref) => PlaceOrderNotifier(ref.read(ordersRepositoryProvider), ref),
);
