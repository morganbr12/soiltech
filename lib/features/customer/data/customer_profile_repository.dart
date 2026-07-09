import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/core/network/dio_provider.dart';
import '../../../shared/models/customer_profile_data.dart';

final customerProfileRepositoryProvider = Provider<CustomerProfileRepository>((ref) {
  return CustomerProfileRepository(ref.watch(dioProvider));
});

class CustomerProfileRepository {
  final Dio _dio;
  CustomerProfileRepository(this._dio);

  Future<CustomerProfileData> getProfile() async {
    final res = await _dio.get('/customer/me');
    return CustomerProfileData.fromJson(res.data['data'] as Map<String, dynamic>);
  }

  Future<CustomerProfileData> updateProfile(Map<String, dynamic> body) async {
    final res = await _dio.put('/customer/me', data: body);
    return CustomerProfileData.fromJson(res.data['data'] as Map<String, dynamic>);
  }
}
