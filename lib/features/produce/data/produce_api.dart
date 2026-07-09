import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../app/core/network/api_constants.dart';
import '../../../app/core/network/api_response.dart';
import '../../../shared/models/produce_record.dart';

part 'produce_api.g.dart';

@RestApi()
abstract class ProduceApi {
  factory ProduceApi(Dio dio, {String? baseUrl}) = _ProduceApi;

  @GET(ApiConstants.produce)
  Future<ApiResponse<List<ProduceRecord>>> getProduceRecords({
    @Query('page') int page = 1,
    @Query('status') String? status,
    @Query('farmer_id') String? farmerId,
  });

  @GET('/produce/{id}')
  Future<ApiResponse<ProduceRecord>> getProduceRecord(@Path('id') String id);

  @POST(ApiConstants.produce)
  Future<ApiResponse<ProduceRecord>> createProduceRecord(
    @Body() Map<String, dynamic> body,
  );

  @PUT('/produce/{id}')
  Future<ApiResponse<ProduceRecord>> updateProduceRecord(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @PATCH('/produce/{id}/approve')
  Future<ApiResponse<ProduceRecord>> approveRecord(@Path('id') String id);

  @PATCH('/produce/{id}/reject')
  Future<ApiResponse<ProduceRecord>> rejectRecord(
    @Path('id') String id,
    @Body() Map<String, String> body,
  );
}
