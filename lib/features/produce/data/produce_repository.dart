import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/core/network/dio_provider.dart';
import '../../../shared/models/produce_record.dart';
import 'produce_api.dart';

final produceApiProvider = Provider<ProduceApi>((ref) {
  return ProduceApi(ref.watch(dioProvider));
});

final produceRepositoryProvider = Provider<ProduceRepository>((ref) {
  return ProduceRepository(ref.watch(produceApiProvider));
});

class ProduceRepository {
  final ProduceApi _api;

  ProduceRepository(this._api);

  Future<List<ProduceRecord>> getProduceRecords({
    int page = 1,
    String? status,
    String? farmerId,
  }) async {
    final response = await _api.getProduceRecords(page: page, status: status, farmerId: farmerId);
    return response.data ?? [];
  }

  Future<ProduceRecord> getProduceRecord(String id) async {
    final response = await _api.getProduceRecord(id);
    return response.data!;
  }

  Future<ProduceRecord> createProduceRecord(Map<String, dynamic> body) async {
    final response = await _api.createProduceRecord(body);
    return response.data!;
  }

  Future<ProduceRecord> updateProduceRecord(String id, Map<String, dynamic> body) async {
    final response = await _api.updateProduceRecord(id, body);
    return response.data!;
  }

  Future<ProduceRecord> approveRecord(String id) async {
    final response = await _api.approveRecord(id);
    return response.data!;
  }

  Future<ProduceRecord> rejectRecord(String id, String reason) async {
    final response = await _api.rejectRecord(id, {'reason': reason});
    return response.data!;
  }
}
