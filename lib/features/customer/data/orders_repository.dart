import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/core/network/dio_provider.dart';
import '../../../app/core/utils/app_logger.dart';
import '../../../shared/models/customer_order.dart';
import 'orders_api.dart';

final ordersApiProvider = Provider<OrdersApi>((ref) {
  return OrdersApi(ref.watch(dioProvider));
});

final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  return OrdersRepository(ref.watch(ordersApiProvider), ref.watch(dioProvider));
});

class OrdersRepository {
  final OrdersApi _api;
  final Dio _dio;

  OrdersRepository(this._api, this._dio);

  Future<List<CustomerOrder>> getOrders({int page = 1, String? status}) async {
    final safeStatus = (status?.isNotEmpty == true) ? status : null;
    final response = await _api.getOrders(page: page, status: safeStatus);
    return response.data ?? [];
  }

  Future<CustomerOrder> getOrder(String id) async {
    final raw = await _dio.get('/orders/$id');
    appLogger.d('[OrderDetail] raw: ${raw.data}');
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
