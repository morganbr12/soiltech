import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/agent_farmer.dart';
import '../../../../shared/models/farmer_detail.dart';
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
