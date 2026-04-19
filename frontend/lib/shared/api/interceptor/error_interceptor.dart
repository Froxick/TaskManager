import 'package:dio/dio.dart';
import 'package:frontend/shared/api/errors/api_error.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final apiError = _handleError(err);
    final customError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: apiError,
      message: apiError.message,
    );

    handler.reject(customError);
  }

  ApiError _handleError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return ApiError(
        message: 'Превышено время ожидания',
        errorCode: 'TIMEOUT',
        timestamp: DateTime.now().toIso8601String(),
      );
    }

    if (error.type == DioExceptionType.connectionError) {
      return ApiError(
        message: 'Нет соединения с сервером',
        errorCode: 'NETWORK_ERROR',
        timestamp: DateTime.now().toIso8601String(),
      );
    }

    if (error.response != null) {
      final data = error.response!.data;
      final statusCode = error.response!.statusCode;

      if (data != null && data is Map<String, dynamic>) {
        return ApiError.fromJson(data);
      }

      return ApiError(
        message: error.response?.statusMessage ?? 'Ошибка сервера',
        errorCode: 'HTTP_$statusCode',
        timestamp: DateTime.now().toIso8601String(),
      );
    }

    return ApiError(
      message: error.message ?? 'Неизвестная ошибка',
      errorCode: 'UNKNOWN_ERROR',
      timestamp: DateTime.now().toIso8601String(),
    );
  }
}
