import 'package:flutter/material.dart';
import 'package:frontend/features/auth/api/auth_api.dart';
import 'package:frontend/features/auth/auth_notifier.dart';
import 'package:frontend/shared/api/errors/api_error.dart';
import 'package:frontend/shared/store/jwt_store.dart';
import 'package:get/get.dart';

class AuthController extends ChangeNotifier {
  final AuthApi _authApi = AuthApi();
  final JwtStore _jwtStore = Get.find<JwtStore>();

  bool _registerLoading = false;
  String? _registerError;

  bool _loginLoading = false;
  String? _loginError;

  bool get loginLoading => _loginLoading;
  String? get loginError => _loginError;
  bool get registerLoading => _registerLoading;
  String? get registerError => _registerError;

  void clearLoginError() {
    _loginError = null;
    notifyListeners();
  }

  void clearRegisterError() {
    _registerError = null;
    notifyListeners();
  }

  void reset() {
    _loginLoading = false;
    _registerLoading = false;
    _loginError = null;
    _registerError = null;
    notifyListeners();
  }

  Future<bool> login({required String email, required String password}) async {
    _loginError = null;
    _loginLoading = true;
    notifyListeners();

    try {
      final response = await _authApi.login(email, password);
      final tokens = response['tokens'];

      if (tokens != null) {
        final accessToken = tokens['accesToken'];
        final refreshToken = tokens['refreshToken'];

        if (accessToken != null && refreshToken != null) {
          await _jwtStore.saveTokens(
              accessToken: accessToken, refreshToken: refreshToken);
          _loginLoading = false;
          notifyListeners();
          authNotifier.value = true;
          return true;
        } else {
          throw Exception('Токены не найдены');
        }
      } else {
        throw Exception('Ответ сервера не содержит токены');
      }
    } on ApiError catch (error) {
      _loginError = error.message;
      _loginLoading = false;
      notifyListeners();
      return false;
    } catch (error) {
      _loginError = 'Произошла ошибка при входе: ${error.toString()}';
      _loginLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _registerError = null;
    _registerLoading = true;
    notifyListeners();

    try {
      final response = await _authApi.register(email, password, name);

      final tokens = response['tokens'];

      if (tokens != null) {
        final accessToken = tokens['accesToken'];
        final refreshToken = tokens['refreshToken'];

        if (accessToken != null && refreshToken != null) {
          await _jwtStore.saveTokens(
            accessToken: accessToken,
            refreshToken: refreshToken,
          );
          authNotifier.value = true;
        }
      }

      _registerLoading = false;
      notifyListeners();
      return true;
    } on ApiError catch (error) {
      _registerError = error.message;
      _registerLoading = false;
      notifyListeners();
      return false;
    } catch (error) {
      _registerError = 'Произошла ошибка при регистрации';
      _registerLoading = false;
      notifyListeners();
      return false;
    }
  }
}
