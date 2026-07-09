import 'package:dio/dio.dart';
import '../../storage/auth_storage.dart';
import '../api_constants.dart';

class AuthInterceptor extends Interceptor {
  final Dio _dio;
  final AuthStorage _storage;
  bool _isRefreshing = false;
  final List<_PendingRequest> _queue = [];

  AuthInterceptor(this._dio, this._storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _storage.accessToken;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final is401 = err.response?.statusCode == 401;
    final isRefreshPath = err.requestOptions.path.contains(ApiConstants.refreshToken);
    final alreadyRetried = err.requestOptions.extra['_retried'] == true;

    if (!is401 || isRefreshPath || alreadyRetried) {
      handler.next(err);
      return;
    }

    if (_isRefreshing) {
      _queue.add(_PendingRequest(err.requestOptions, handler));
      return;
    }

    _isRefreshing = true;
    try {
      await _doRefresh();
      final newToken = _storage.accessToken!;

      // Retry original request
      err.requestOptions.extra['_retried'] = true;
      err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
      final retried = await _dio.fetch(err.requestOptions);
      handler.resolve(retried);

      // Drain queue
      for (final pending in _queue) {
        pending.options.extra['_retried'] = true;
        pending.options.headers['Authorization'] = 'Bearer $newToken';
        try {
          pending.handler.resolve(await _dio.fetch(pending.options));
        } catch (_) {
          pending.handler.next(err);
        }
      }
    } catch (_) {
      await _storage.clearSession();
      handler.next(err);
      for (final pending in _queue) {
        pending.handler.next(err);
      }
    } finally {
      _queue.clear();
      _isRefreshing = false;
    }
  }

  Future<void> _doRefresh() async {
    final refreshToken = _storage.refreshToken;
    if (refreshToken == null) throw Exception('No refresh token stored');

    final refreshDio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    final response = await refreshDio.post(
      ApiConstants.refreshToken,
      data: {'refreshToken': refreshToken},
    );

    final data = response.data['data'] as Map<String, dynamic>;
    await _storage.saveSession(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
      userId: data['userId'] as String,
      email: data['email'] as String,
      role: data['role'] as String,
      fullName: data['fullName'] as String,
    );
  }
}

class _PendingRequest {
  final RequestOptions options;
  final ErrorInterceptorHandler handler;
  _PendingRequest(this.options, this.handler);
}
