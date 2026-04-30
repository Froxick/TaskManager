import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/shared/store/jwt_store.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final JwtStore storage;
  final ValueNotifier<bool> authNotifier;

  AuthInterceptor({
    required this.dio,
    required this.storage,
    required this.authNotifier,
  });

  Future<String?>? _refreshFuture;

  void log(String message) {
    debugPrint('[AUTH_INTERCEPTOR] $message');
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await storage.getJwtToken();

    log('➡️ REQUEST: ${options.method} ${options.uri}');
    log('Token attached: ${token != null}');

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode;
    final req = err.requestOptions;

    log('❌ ERROR: ${req.uri} | status: $status');

    if (status != 401) {
      return handler.next(err);
    }

    if (req.extra['retried'] == true) {
      log('🚨 Already retried → logout');
      await _logout();
      return handler.next(err);
    }

    final refreshToken = await storage.getRefreshToken();

    if (refreshToken == null) {
      log('🚨 No refresh token → logout');
      await _logout();
      return handler.next(err);
    }

    try {
      log('🔄 Starting refresh flow...');

      final newAccessToken = await _refresh(refreshToken);

      if (newAccessToken == null) {
        log('🚨 Refresh returned null → logout');
        await _logout();
        return handler.next(err);
      }

      log('✅ Refresh success → retry request');

      final options = Options(
        method: req.method,
        headers: {
          ...req.headers,
          'Authorization': 'Bearer $newAccessToken',
        },
      );

      final response = await dio.request(
        req.path,
        data: req.data,
        queryParameters: req.queryParameters,
        options: options.copyWith(
          extra: {
            ...req.extra,
            'retried': true,
          },
        ),
      );

      log('🎯 Retry success: ${req.uri}');

      return handler.resolve(response);
    } catch (e) {
      log('💥 Refresh or retry failed: $e');
      await _logout();
      return handler.next(err);
    }
  }

  Future<String?> _refresh(String refreshToken) async {
    if (_refreshFuture != null) {
      log('⏳ Waiting existing refresh...');
      return _refreshFuture;
    }

    _refreshFuture = _doRefresh(refreshToken);

    final result = await _refreshFuture;
    _refreshFuture = null;

    return result;
  }

  Future<String?> _doRefresh(String refreshToken) async {
    try {
      log('📡 POST /jwt/refresh');

      final response = await dio.post(
        '/jwt/refresh',
        data: {'refreshToken': refreshToken},
        options: Options(
          extra: {'skipAuth': true},
        ),
      );

      log('📦 Refresh response: ${response.data}');

      final accessToken = response.data['accessToken'];
      final newRefreshToken = response.data['refreshToken'];

      if (accessToken == null) {
        log('❌ accessToken is null');
        return null;
      }

      await storage.saveTokens(
        accessToken: accessToken,
        refreshToken: newRefreshToken,
      );

      log('💾 Tokens saved');

      return accessToken;
    } catch (e) {
      log('💥 Refresh request failed: $e');
      return null;
    }
  }

  Future<void> _logout() async {
    log('🚪 LOGOUT');
    await storage.clearTokens();
    authNotifier.value = false;
  }
}
