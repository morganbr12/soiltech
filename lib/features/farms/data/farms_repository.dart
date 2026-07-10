import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/farmers/data/farmers_api.dart';
import '../../../features/farmers/data/farmers_repository.dart';
import '../../../shared/models/farm_model.dart';

final farmsRepositoryProvider = Provider<FarmsRepository>((ref) {
  return FarmsRepository(ref.watch(farmersApiProvider));
});

class FarmsRepository {
  final FarmersApi _api;
  FarmsRepository(this._api);

  Future<FarmModel> registerFarm({
    required String farmerId,
    required String name,
    required String district,
    required String community,
    required double sizeAcres,
    List<String> cropTypes = const [],
    double? latitude,
    double? longitude,
  }) async {
    final body = <String, dynamic>{
      'name': name,
      'district': district,
      'community': community,
      'sizeAcres': sizeAcres,
      if (cropTypes.isNotEmpty) 'cropTypes': cropTypes.map((c) => c.toUpperCase()).toList(),
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    };
    return _api.addFarm(farmerId, body).then((r) => r.data!);
  }
}
