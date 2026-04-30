import 'package:dio/dio.dart';
import 'package:frontend/features/user/model/user_model.dart';
import 'package:frontend/shared/api/clients/protected_client.dart';
import 'package:frontend/shared/api/errors/api_error.dart';
import 'package:frontend/shared/store/jwt_store.dart';
import 'package:get/get.dart';

class UserApi {
  late final JwtStore jwtStore = Get.find<JwtStore>();
  late final Dio dio = ProtectedClient(jwtStore).dio;

  Future<UserModel> getUser() async {
    try {
      final response = await dio.get('/user/profile');
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.error is ApiError) {
        throw e.error as ApiError;
      }
      throw ApiError(
          message: e.message ?? 'Ошибка при запросе',
          errorCode: 'UNKNOWN_ERROR',
          timestamp: DateTime.now().toIso8601String());
    }
  }

  Future<void> logout() async {
    try {
      final String? refreshToken = await jwtStore.getRefreshToken();
      await dio.post('/jwt/logout', data: {'refreshToken': refreshToken});
    } on DioException catch (e) {
      if (e.error is ApiError) {
        throw e.error as ApiError;
      }
      throw ApiError(
          message: e.message ?? 'Ошибка при запросе',
          errorCode: 'UNKNOWN_ERROR',
          timestamp: DateTime.now().toIso8601String());
    }
  }
}
