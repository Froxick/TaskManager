import 'package:dio/dio.dart';
import 'package:frontend/shared/api/clients/api_client.dart';
import 'package:frontend/shared/api/errors/api_error.dart';

class AuthApi {
  final Dio dio = ApiClient().dio;

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/user/login',
        data: {'email': email, 'password': password},
      );
      return response.data;
    } on DioException catch (e) {
      if (e.error is ApiError) {
        throw e.error as ApiError;
      }
      throw ApiError(
        message: e.message ?? 'Ошибка при входе',
        errorCode: 'UNKNOWN_ERROR',
        timestamp: DateTime.now().toIso8601String(),
      );
    }
  }

  Future<Map<String, dynamic>> register(
    String email,
    String password,
    String name,
  ) async {
    try {
      final response = await dio.post(
        '/user/register',
        data: {'email': email, 'password': password, 'name': name},
      );
      return response.data;
    } on DioException catch (e) {
      if (e.error is ApiError) {
        throw e.error as ApiError;
      }
      throw ApiError(
        message: e.message ?? 'Ошибка при регистрации',
        errorCode: 'UNKNOWN_ERROR',
        timestamp: DateTime.now().toIso8601String(),
      );
    }
  }
}
