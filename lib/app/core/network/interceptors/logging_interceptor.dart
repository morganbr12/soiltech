import 'package:dio/dio.dart';
import '../../utils/app_logger.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    appLogger.d('[API] → ${options.method} ${options.path}');
    if (options.data != null) appLogger.d('[API] Body: ${options.data}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    appLogger.i('[API] ← ${response.statusCode} ${response.requestOptions.path}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    appLogger.e(
      '[API] ✕ ${err.response?.statusCode} ${err.requestOptions.path}',
      error: err.error,
      stackTrace: err.stackTrace,
    );
    if (err.response?.data != null) appLogger.e('[API] body: ${err.response?.data}');
    handler.next(err);
  }
}
