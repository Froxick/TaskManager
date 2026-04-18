import 'package:flutter/material.dart';
import 'package:frontend/features/auth/controllers/login_form_controller.dart';
import 'package:frontend/shared/utils/validator.dart';

class RegisterFormController extends LoginFormController {
  final TextEditingController nameController = TextEditingController();

  String? validateName(String? value) {
    if (value == null) return 'Обязательное поле';

    return Validator.validateString(value,
        required: true,
        maxLength: 12,
        minLength: 3,
        pattern: RegExp(r'^[a-zA-Zа-яА-Я\s]+$'),
        patternError: 'Только буквы и пробелы');
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
