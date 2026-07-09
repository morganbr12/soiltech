import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../app/core/network/api_constants.dart';
import '../../../app/core/network/api_response.dart';
import '../../../shared/models/pickup_request.dart';

part 'logistics_api.g.dart';

@RestApi()
abstract class LogisticsApi {
  factory LogisticsApi(Dio dio, {String? baseUrl}) = _LogisticsApi;

  @GET(ApiConstants.logistics)
  Future<ApiResponse<List<PickupRequest>>> getPickupRequests({
    @Query('page') int page = 1,
    @Query('status') String? status,
  });

  @GET('/logistics/{id}')
  Future<ApiResponse<PickupRequest>> getPickupRequest(@Path('id') String id);

  @POST(ApiConstants.logistics)
  Future<ApiResponse<PickupRequest>> createPickupRequest(
    @Body() Map<String, dynamic> body,
  );

  @PATCH('/logistics/{id}/status')
  Future<ApiResponse<PickupRequest>> updateStatus(
    @Path('id') String id,
    @Body() Map<String, String> body,
  );
}
