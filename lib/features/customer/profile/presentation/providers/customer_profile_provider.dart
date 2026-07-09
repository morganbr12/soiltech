import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/customer_profile_repository.dart';
import '../../../../../shared/models/customer_profile_data.dart';

final customerProfileProvider = FutureProvider<CustomerProfileData>((ref) {
  return ref.watch(customerProfileRepositoryProvider).getProfile();
});
