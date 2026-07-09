import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/core/network/dio_provider.dart';
import '../../../shared/models/pickup_request.dart';
import 'logistics_api.dart';

final logisticsApiProvider = Provider<LogisticsApi>((ref) {
  return LogisticsApi(ref.watch(dioProvider));
});

final logisticsRepositoryProvider = Provider<LogisticsRepository>((ref) {
  return LogisticsRepository(ref.watch(logisticsApiProvider));
});

class LogisticsRepository {
  final LogisticsApi _api;

  LogisticsRepository(this._api);

  Future<List<PickupRequest>> getPickupRequests({int page = 1, String? status}) async {
    final response = await _api.getPickupRequests(page: page, status: status);
    return response.data ?? [];
  }

  Future<PickupRequest> getPickupRequest(String id) async {
    final response = await _api.getPickupRequest(id);
    return response.data!;
  }

  Future<PickupRequest> createPickupRequest(Map<String, dynamic> body) async {
    final response = await _api.createPickupRequest(body);
    return response.data!;
  }

  Future<PickupRequest> updateStatus(String id, String status) async {
    final response = await _api.updateStatus(id, {'status': status});
    return response.data!;
  }
}
