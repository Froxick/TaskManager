import 'package:dio/dio.dart';
import 'package:frontend/shared/api/interceptor/auth_interceptor.dart';
import 'package:frontend/shared/api/interceptor/error_interceptor.dart';
import 'package:frontend/shared/store/jwt_store.dart';

class ProtectedClient {
  late final Dio dio;
  final JwtStore jwtStore;

  ProtectedClient(this.jwtStore) {
    dio = Dio(BaseOptions(
        baseUrl: 'http://localhost:3000',
        connectTimeout: Duration(seconds: 5),
        receiveTimeout: Duration(seconds: 5),
        headers: {'Content-Type': 'application/json'}));

    dio.interceptors.add(AuthInterceptor(dio: dio, storage: jwtStore));
    dio.interceptors.add(ErrorInterceptor());
  }
}
