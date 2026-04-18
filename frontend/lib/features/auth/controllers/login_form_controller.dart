import 'package:flutter/material.dart';
import 'package:frontend/shared/utils/validator.dart';

class LoginFormController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? validateEmail(String? value) {
    if (value == null) return 'Обязательное поле';

    return Validator.validateString(value,
        required: true,
        pattern: RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'),
        patternError: 'Введите корректный email');
  }

  String? validatePassword(String? value) {
    if (value == null) return 'Обязательное поле';

    return Validator.validateString(
      value,
      required: true,
      minLength: 6,
      maxLength: 30,
    );
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
