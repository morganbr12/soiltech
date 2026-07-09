import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../app/core/network/api_constants.dart';
import '../../../app/core/network/api_response.dart';
import '../../../shared/models/payment_record.dart';

part 'payments_api.g.dart';

@RestApi()
abstract class PaymentsApi {
  factory PaymentsApi(Dio dio, {String? baseUrl}) = _PaymentsApi;

  @GET(ApiConstants.payments)
  Future<ApiResponse<List<PaymentRecord>>> getPayments({
    @Query('page') int page = 1,
    @Query('status') String? status,
    @Query('farmer_id') String? farmerId,
  });

  @GET('/payments/{id}')
  Future<ApiResponse<PaymentRecord>> getPayment(@Path('id') String id);

  @POST(ApiConstants.payments)
  Future<ApiResponse<PaymentRecord>> createPayment(
    @Body() Map<String, dynamic> body,
  );

  @PATCH('/payments/{id}/mark-paid')
  Future<ApiResponse<PaymentRecord>> markAsPaid(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );
}
