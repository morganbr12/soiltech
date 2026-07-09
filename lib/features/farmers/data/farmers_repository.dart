import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/core/network/dio_provider.dart';
import '../../../shared/models/agent_farmer.dart';
import '../../../shared/models/farm_model.dart';
import '../../../shared/models/farmer_detail.dart';
import 'farmers_api.dart';

final farmersApiProvider = Provider<FarmersApi>((ref) {
  return FarmersApi(ref.watch(dioProvider));
});

final farmersRepositoryProvider = Provider<FarmersRepository>((ref) {
  return FarmersRepository(ref.watch(dioProvider), ref.watch(farmersApiProvider));
});

class FarmersRepository {
  final Dio _dio;
  final FarmersApi _api;

  FarmersRepository(this._dio, this._api);

  Future<({List<AgentFarmer> farmers, int total, int lastPage})> getFarmers({
    int page = 1,
    int limit = 20,
    String? search,
    String? status,
  }) async {
    final res = await _dio.get(
      '/agent/farmers',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
        if (status != null) 'status': status,
      },
    );
    final list = (res.data['data'] as List<dynamic>? ?? [])
        .map((e) => AgentFarmer.fromJson(e as Map<String, dynamic>))
        .toList();
    final meta = res.data['meta'] as Map<String, dynamic>?;
    return (
      farmers: list,
      total: (meta?['total'] as num?)?.toInt() ?? list.length,
      lastPage: (meta?['last_page'] as num?)?.toInt() ?? 1,
    );
  }

  Future<FarmerDetail> getFarmerDetail(String id) async {
    final res = await _dio.get('/agent/farmers/$id');
    return FarmerDetail.fromJson(res.data['data'] as Map<String, dynamic>);
  }

  Future<AgentFarmer> createFarmer(Map<String, dynamic> body) async {
    final response = await _api.createFarmer(body);
    return response.data!;
  }

  Future<List<FarmModel>> getFarmerFarms(String farmerId) async {
    final response = await _api.getFarmerFarms(farmerId);
    return response.data ?? [];
  }

  Future<FarmModel> addFarm(String farmerId, Map<String, dynamic> body) async {
    final response = await _api.addFarm(farmerId, body);
    return response.data!;
  }
}
