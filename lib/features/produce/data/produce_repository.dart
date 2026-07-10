import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../../../app/core/network/api_constants.dart';
import '../../../app/core/network/dio_provider.dart';
import '../../../shared/models/produce_entry.dart';
import '../../../shared/models/produce_record.dart';
import 'produce_api.dart';

final produceApiProvider = Provider<ProduceApi>((ref) {
  return ProduceApi(ref.watch(dioProvider));
});

final produceRepositoryProvider = Provider<ProduceRepository>((ref) {
  return ProduceRepository(ref.watch(produceApiProvider), ref.watch(dioProvider));
});

class ProduceRepository {
  final ProduceApi _api;
  final Dio _dio;

  ProduceRepository(this._api, this._dio);

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

  Future<List<ProduceEntry>> getAgentProduceRecords({
    String? status,
    String? farmerId,
    int page = 1,
    int perPage = 30,
  }) async {
    final params = <String, dynamic>{'page': page, 'per_page': perPage};
    if (status != null) params['status'] = status;
    if (farmerId != null) params['farmer_id'] = farmerId;
    final res = await _dio.get(ApiConstants.agentProduceRecords, queryParameters: params);
    final list = res.data['data'] as List<dynamic>;
    return list.map((e) => ProduceEntry.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> submitCollection({
    required String farmerId,
    String? farmId,
    required String cropType,
    required double weightKg,
    required int quantityBags,
    required double moisturePercent,
    required String qualityGrade,
    required DateTime collectionDate,
    required double pricePerKg,
    String notes = '',
    List<XFile> photos = const [],
  }) async {
    final fields = <String, dynamic>{
      'farmer_id': farmerId,
      if (farmId != null) 'farm_id': farmId,
      'crop_type': cropType.toUpperCase(),
      'quantity_kg': weightKg,
      'quantity_bags': quantityBags,
      'moisture_percent': moisturePercent,
      'quality_grade': qualityGrade,
      'collection_date': collectionDate.toIso8601String(),
      'price_per_kg': pricePerKg,
      if (notes.isNotEmpty) 'notes': notes,
    };

    if (photos.isEmpty) {
      await _api.createProduceRecord(fields);
      return;
    }

    final photoFiles = <MultipartFile>[];
    for (final photo in photos) {
      final bytes = await photo.readAsBytes();
      final mime = photo.mimeType ?? 'image/jpeg';
      final parts = mime.split('/');
      photoFiles.add(MultipartFile.fromBytes(
        bytes,
        filename: photo.name,
        contentType: MediaType(parts[0], parts.length > 1 ? parts[1] : 'jpeg'),
      ));
    }

    await _dio.post(
      ApiConstants.produce,
      data: FormData.fromMap({...fields, 'photos': photoFiles}),
    );
  }
}
