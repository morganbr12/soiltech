import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../../../app/core/network/dio_provider.dart';
import '../../../app/core/utils/app_logger.dart';
import '../../../shared/models/product.dart';
import '../../../shared/models/delivery_fee_result.dart';
import '../../../shared/models/product_category_model.dart';

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  return ProductsRepository(ref.watch(dioProvider));
});

class ProductsRepository {
  final Dio _dio;
  ProductsRepository(this._dio);

  Future<List<Product>> getDeals({int perPage = 20}) async {
    final res = await _dio.get(
      '/products',
      queryParameters: {'page': 1, 'per_page': perPage},
    );
    return _parseProductList(res.data);
  }

  Future<List<Product>> getFeatured({int perPage = 10}) async {
    final res = await _dio.get(
      '/products',
      queryParameters: {'page': 1, 'per_page': perPage},
    );
    return _parseProductList(res.data);
  }

  Future<List<Product>> getProducts({
    int page = 1,
    int perPage = 20,
    String? categoryId,
    String? query,
  }) async {
    final params = <String, dynamic>{'page': page, 'per_page': perPage};
    if (categoryId != null) params['category_id'] = categoryId;
    if (query != null && query.isNotEmpty) params['query'] = query;
    final res = await _dio.get('/products', queryParameters: params);
    return _parseProductList(res.data);
  }

  Future<List<Product>> getRecent({int perPage = 6}) async {
    final res = await _dio.get(
      '/products',
      queryParameters: {'page': 1, 'per_page': perPage},
    );
    return _parseProductList(res.data);
  }

  Future<Product> getProductById(String id) async {
    final res = await _dio.get('/products/$id');
    final data = res.data['data'] as Map<String, dynamic>;
    return Product.fromJson(data);
  }

  Future<List<ProductCategoryModel>> getCategories({int perPage = 50}) async {
    final res = await _dio.get(
      '/product-categories',
      queryParameters: {'page': 1, 'per_page': perPage},
    );
    final list = res.data['data'] as List<dynamic>;
    return list
        .map((e) => ProductCategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ProductReview>> getProductReviews(String id, {int perPage = 20}) async {
    final res = await _dio.get(
      '/products/$id/reviews',
      queryParameters: {'page': 1, 'per_page': perPage},
    );
    final list = res.data['data'] as List<dynamic>;
    return list
        .map((e) => ProductReview.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> submitReview(
    String productId, {
    required int rating,
    required String comment,
  }) async {
    await _dio.post(
      '/products/$productId/reviews',
      data: {'rating': rating, 'comment': comment},
    );
  }

  Future<void> createProduceRecord({
    required String farmerId,
    required String cropType,
    required double quantityKg,
    required double pricePerKg,
    String? farmId,
    String? cropVariety,
    String? grade,
    String? notes,
    DateTime? collectedAt,
    List<XFile> photos = const [],
  }) async {
    final fields = <String, dynamic>{
      'farmerId': farmerId,
      'cropType': cropType,
      'quantityKg': quantityKg,
      'pricePerKg': pricePerKg,
      if (farmId != null) 'farmId': farmId,
      if (cropVariety != null && cropVariety.isNotEmpty) 'cropVariety': cropVariety,
      if (grade != null && grade.isNotEmpty) 'grade': grade,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
      if (collectedAt != null) 'collectedAt': collectedAt.toIso8601String(),
    };

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

    appLogger.d('Creating produce record: $fields, photos: ${photos.length}');
    await _dio.post('/agent/produce-records', data: formData);
  }

  Future<DeliveryFeeResult> getDeliveryFee({
    required String productId,
    required double deliveryLat,
    required double deliveryLng,
    double? fromLat,
    double? fromLng,
  }) async {
    final params = <String, dynamic>{
      'product_id': productId,
      'delivery_lat': deliveryLat,
      'delivery_lng': deliveryLng,
      if (fromLat != null) 'from_lat': fromLat,
      if (fromLng != null) 'from_lng': fromLng,
    };
    final res = await _dio.get('/delivery-fee', queryParameters: params);
    return DeliveryFeeResult.fromJson(res.data['data'] as Map<String, dynamic>);
  }

  List<Product> _parseProductList(dynamic responseData) {
    final list = responseData['data'] as List<dynamic>;
    return list
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
