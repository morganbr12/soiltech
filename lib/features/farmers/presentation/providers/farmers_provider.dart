import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/agent_farmer.dart';
import '../../../../shared/models/farm_model.dart';
import '../../../../shared/models/farmer_detail.dart';
import '../../../../shared/models/produce_entry.dart';
import '../../../produce/data/produce_repository.dart';
import '../../data/farmers_repository.dart';

class FarmersFilter {
  final String search;
  final String? status; // null = all, 'PENDING', 'APPROVED', 'REJECTED'
  final int page;

  const FarmersFilter({this.search = '', this.status, this.page = 1});

  FarmersFilter copyWith({String? search, String? status, bool clearStatus = false, int? page}) {
    return FarmersFilter(
      search: search ?? this.search,
      status: clearStatus ? null : (status ?? this.status),
      page: page ?? this.page,
    );
  }
}

final farmersFilterProvider = StateProvider<FarmersFilter>((_) => const FarmersFilter());

final farmersListProvider = FutureProvider<({List<AgentFarmer> farmers, int total, int lastPage})>((ref) {
  final filter = ref.watch(farmersFilterProvider);
  return ref.watch(farmersRepositoryProvider).getFarmers(
        page: filter.page,
        search: filter.search,
        status: filter.status,
      );
});

final farmerDetailProvider = FutureProvider.family<FarmerDetail, String>((ref, id) {
  return ref.watch(farmersRepositoryProvider).getFarmerDetail(id);
});

final allFarmersProvider = FutureProvider<List<AgentFarmer>>((ref) async {
  final result = await ref.read(farmersRepositoryProvider).getFarmers(limit: 200);
  return result.farmers;
});

final farmerFarmsProvider = FutureProvider.family<List<FarmModel>, String>((ref, farmerId) {
  return ref.watch(farmersRepositoryProvider).getFarmerFarms(farmerId);
});

// (farmerId, cropType)
final farmerCropRecordsProvider = FutureProvider.family<List<ProduceEntry>, (String, String)>(
  (ref, params) async {
    final (farmerId, cropType) = params;
    final all = await ref.read(produceRepositoryProvider).getAgentProduceRecords(farmerId: farmerId);
    return all.where((r) => r.cropType.toLowerCase() == cropType.toLowerCase()).toList();
  },
);
