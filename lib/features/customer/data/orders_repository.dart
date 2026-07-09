import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/core/network/dio_provider.dart';
import '../../../shared/models/customer_order.dart';
import 'orders_api.dart';

final ordersApiProvider = Provider<OrdersApi>((ref) {
  return OrdersApi(ref.watch(dioProvider));
});

final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  return OrdersRepository(ref.watch(ordersApiProvider));
});

class OrdersRepository {
  final OrdersApi _api;

  OrdersRepository(this._api);

  Future<List<CustomerOrder>> getOrders({int page = 1, String? status}) async {
    final response = await _api.getOrders(page: page, status: status);
    return response.data ?? [];
  }

  Future<CustomerOrder> getOrder(String id) async {
    final response = await _api.getOrder(id);
    return response.data!;
  }

  Future<CustomerOrder> placeOrder(Map<String, dynamic> body) async {
    final response = await _api.placeOrder(body);
    return response.data!;
  }

  Future<CustomerOrder> cancelOrder(String id) async {
    final response = await _api.cancelOrder(id);
    return response.data!;
  }
}
