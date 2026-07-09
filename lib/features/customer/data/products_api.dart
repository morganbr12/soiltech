import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../app/core/network/api_constants.dart';
import '../../../app/core/network/api_response.dart';
import '../../../shared/models/product.dart';

part 'products_api.g.dart';

@RestApi()
abstract class ProductsApi {
  factory ProductsApi(Dio dio, {String? baseUrl}) = _ProductsApi;

  @GET(ApiConstants.products)
  Future<ApiResponse<List<Product>>> getProducts({
    @Query('page') int page = 1,
    @Query('category') String? category,
    @Query('search') String? search,
    @Query('sort') String? sort,
  });

  @GET(ApiConstants.featuredProducts)
  Future<ApiResponse<List<Product>>> getFeaturedProducts();

  @GET(ApiConstants.dealProducts)
  Future<ApiResponse<List<Product>>> getDealProducts();

  @GET('/products/{id}')
  Future<ApiResponse<Product>> getProduct(@Path('id') String id);

  @GET('/products/{id}/reviews')
  Future<ApiResponse<List<ProductReview>>> getProductReviews(
    @Path('id') String id,
  );
}
