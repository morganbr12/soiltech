import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/core/network/dio_provider.dart';
import '../../../shared/models/product.dart';
import '../../../shared/models/product_category_model.dart';

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  return ProductsRepository(ref.watch(dioProvider));
});

class ProductsRepository {
  final Dio _dio;
  ProductsRepository(this._dio);

  Future<List<Product>> getDeals({int perPage = 20}) async {
    final res = await _dio.get(
      '/products/deals',
      queryParameters: {'page': 1, 'per_page': perPage},
    );
    return _parseProductList(res.data);
  }

  Future<List<Product>> getFeatured({int perPage = 20}) async {
    final res = await _dio.get(
      '/products/featured',
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

  List<Product> _parseProductList(dynamic responseData) {
    final list = responseData['data'] as List<dynamic>;
    return list
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
