import 'package:dio/dio.dart';
import 'package:frontend/shared/api/interceptor/error_interceptor.dart';

class ApiClient {
  late final Dio dio;

  ApiClient() {
    dio = Dio(BaseOptions(
        baseUrl: 'http://localhost:3000',
        connectTimeout: Duration(seconds: 5),
        receiveTimeout: Duration(seconds: 5),
        headers: {'Content-Type': 'application/json'}));
    dio.interceptors.add(ErrorInterceptor());
  }
}
