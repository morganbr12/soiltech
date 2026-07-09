import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../app/core/network/api_constants.dart';
import '../../../app/core/network/api_response.dart';
import '../../../app/core/network/json_map.dart';
import '../../../shared/models/agent_profile.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String? baseUrl}) = _AuthApi;

  @POST(ApiConstants.login)
  Future<ApiResponse<JsonMap>> login(
    @Body() Map<String, dynamic> body,
  );

  @POST(ApiConstants.register)
  Future<ApiResponse<JsonMap>> register(
    @Body() Map<String, dynamic> body,
  );

  @POST(ApiConstants.logout)
  Future<ApiResponse<void>> logout(
    @Body() Map<String, String> body,
  );

  @POST(ApiConstants.forgotPassword)
  Future<ApiResponse<void>> forgotPassword(
    @Body() Map<String, String> body,
  );

  @POST(ApiConstants.verifyOtp)
  Future<ApiResponse<JsonMap>> verifyOtp(
    @Body() Map<String, String> body,
  );

  @POST(ApiConstants.refreshToken)
  Future<ApiResponse<JsonMap>> refreshToken(
    @Body() Map<String, String> body,
  );

  @GET(ApiConstants.agentProfile)
  Future<ApiResponse<AgentProfile>> getAgentProfile();
}
