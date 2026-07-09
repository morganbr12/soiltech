import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../app/core/network/api_response.dart';
import '../../../shared/models/agent_farmer.dart';
import '../../../shared/models/farm_model.dart';

part 'farmers_api.g.dart';

// AgentFarmer is a plain class — Retrofit needs a JsonMap wrapper for lists.
// We call /agent/farmers via raw Dio in the repository instead.

@RestApi()
abstract class FarmersApi {
  factory FarmersApi(Dio dio, {String? baseUrl}) = _FarmersApi;

  @GET('/farmers/{id}')
  Future<ApiResponse<AgentFarmer>> getFarmer(@Path('id') String id);

  @POST('/agent/farmers')
  Future<ApiResponse<AgentFarmer>> createFarmer(@Body() Map<String, dynamic> body);

  @GET('/farmers/{farmerId}/farms')
  Future<ApiResponse<List<FarmModel>>> getFarmerFarms(
    @Path('farmerId') String farmerId,
  );

  @POST('/farmers/{farmerId}/farms')
  Future<ApiResponse<FarmModel>> addFarm(
    @Path('farmerId') String farmerId,
    @Body() Map<String, dynamic> body,
  );
}
