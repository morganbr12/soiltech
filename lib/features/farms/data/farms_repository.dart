import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/core/network/dio_provider.dart';
import '../../../app/core/utils/app_logger.dart';

final farmsRepositoryProvider = Provider<FarmsRepository>((ref) {
  return FarmsRepository(ref.watch(dioProvider));
});

class FarmsRepository {
  final Dio _dio;
  FarmsRepository(this._dio);

  Future<void> registerFarm({
    required String farmerId,
    required String name,
    required double sizeHectares,
    required String cropType,
    required String location,
    double? latitude,
    double? longitude,
    List<XFile> photos = const [],
  }) async {
    // Flat form fields — backend uses @RequestParam, not @RequestPart
    final fields = <String, dynamic>{
      'farmerId': farmerId,
      'name': name,
      'sizeHectares': sizeHectares,
      'cropType': cropType.toLowerCase(),
      'location': location,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    };

    // Photo MultipartFiles
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

    final formData = FormData.fromMap({
      ...fields,
      if (photoFiles.isNotEmpty) 'photos': photoFiles,
    });

    appLogger.d('Registering farm: $fields, photos: ${photos.length}');
    await _dio.post('/farmers/$farmerId/farms', data: formData);
  }
}
