import 'package:dio/dio.dart';
import 'package:frontend/shared/store/jwt_store.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final Dio refreshDio;
  final JwtStore storage;

  bool _isRefreshing = false;

  AuthInterceptor({
    required this.dio,
    required this.storage,
  }) : refreshDio = Dio(BaseOptions(
          baseUrl: dio.options.baseUrl,
          connectTimeout: const Duration(seconds: 5),
        ));

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await storage.getJwtToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final requestOptions = err.requestOptions;

    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    if (requestOptions.extra['retried'] == true) {
      await storage.clearTokens();
      return handler.next(err);
    }

    final refreshToken = await storage.getRefreshToken();

    if (refreshToken == null) {
      return handler.next(err);
    }

    if (_isRefreshing) {
      await Future.delayed(const Duration(milliseconds: 300));

      final newToken = await storage.getJwtToken();

      if (newToken != null) {
        final retryResponse = await dio.request(
          requestOptions.path,
          options: Options(
            method: requestOptions.method,
            headers: {
              ...requestOptions.headers,
              'Authorization': 'Bearer $newToken',
            },
            extra: {
              ...requestOptions.extra,
              'retried': true,
            },
          ),
          data: requestOptions.data,
          queryParameters: requestOptions.queryParameters,
        );

        return handler.resolve(retryResponse);
      }

      return handler.next(err);
    }

    _isRefreshing = true;

    try {
      print('REFRESH TOKEN...');

      final response = await refreshDio.post(
        '/jwt/refresh',
        data: {
          'refreshToken': refreshToken,
        },
      );

      final newAccess = response.data['accesToken'];
      final newRefresh = response.data['refreshToken'];

      await storage.saveTokens(
        accessToken: newAccess,
        refreshToken: newRefresh,
      );

      final retryResponse = await dio.request(
        requestOptions.path,
        options: Options(
          method: requestOptions.method,
          headers: {
            ...requestOptions.headers,
            'Authorization': 'Bearer $newAccess',
          },
          extra: {
            ...requestOptions.extra,
            'retried': true,
          },
        ),
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
      );

      _isRefreshing = false;

      return handler.resolve(retryResponse);
    } catch (e) {
      _isRefreshing = false;

      await storage.clearTokens();

      return handler.next(e is DioException ? e : err);
    }
  }
}
