import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../app/core/network/api_constants.dart';
import '../../../app/core/network/api_response.dart';
import '../../../shared/models/customer_order.dart';

part 'orders_api.g.dart';

@RestApi()
abstract class OrdersApi {
  factory OrdersApi(Dio dio, {String? baseUrl}) = _OrdersApi;

  @GET(ApiConstants.orders)
  Future<ApiResponse<List<CustomerOrder>>> getOrders({
    @Query('page') int page = 1,
    @Query('per_page') int perPage = 20,
    @Query('status') String? status,
  });

  @GET('/orders/{id}')
  Future<ApiResponse<CustomerOrder>> getOrder(@Path('id') String id);

  @POST(ApiConstants.placeOrder)
  Future<ApiResponse<CustomerOrder>> placeOrder(
    @Body() Map<String, dynamic> body,
  );

  @PATCH('/orders/{id}/cancel')
  Future<ApiResponse<CustomerOrder>> cancelOrder(@Path('id') String id);

  @PATCH('/orders/{id}/status')
  Future<ApiResponse<CustomerOrder>> updateStatus(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );
}
