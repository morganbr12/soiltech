import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/produce_entry.dart';
import '../../data/produce_repository.dart';

// null = All
final produceStatusFilterProvider = StateProvider<ProduceStatus?>((ref) => null);

final produceListProvider = FutureProvider<List<ProduceEntry>>((ref) {
  final status = ref.watch(produceStatusFilterProvider);
  return ref.read(produceRepositoryProvider).getAgentProduceRecords(
        status: status?.apiValue,
      );
});
