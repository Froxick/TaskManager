import 'package:flutter/material.dart';
import 'package:frontend/features/auth/controllers/auth_controller.dart';
import 'package:frontend/features/auth/controllers/login_form_controller.dart';
import 'package:frontend/features/auth/ui/form_button.dart';
import 'package:frontend/features/auth/ui/form_title.dart';
import 'package:frontend/shared/theme/colors.dart';
import 'package:frontend/shared/ui/input.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback changeForm;
  final LoginFormController controllers;
  final AuthController authController;
  final VoidCallback navigate;
  const LoginForm(
      {super.key,
      required this.changeForm,
      required this.controllers,
      required this.authController,
      required this.navigate});

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;

  void _validateForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final success = await widget.authController.login(
        email: widget.controllers.emailController.text,
        password: widget.controllers.passwordController.text);
    if (success && mounted) {
      widget.navigate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    return AnimatedBuilder(
        animation: widget.authController,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(25),
              child: Form(
                  key: _formKey,
                  onChanged: _validateForm,
                  child: Column(
                    spacing: height * 0.02,
                    children: [
                      FormTitle(title: 'Вход'),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      FormInput(
                          controller: widget.controllers.emailController,
                          placeholder: 'Почта',
                          type: TextInputType.emailAddress,
                          maxLength: 20,
                          label: 'Почта',
                          height: height * 0.075,
                          validator: widget.controllers.validateEmail,
                          onChanged: (value) => _validateForm()),
                      FormInput(
                          controller: widget.controllers.passwordController,
                          placeholder: 'Пароль',
                          height: height * 0.075,
                          type: TextInputType.text,
                          maxLength: 30,
                          label: 'Пароль',
                          isPassword: true,
                          validator: widget.controllers.validatePassword,
                          onChanged: (value) => _validateForm()),
                      SizedBox(
                        height: widget.authController.loginError != null
                            ? 0
                            : height * 0.01,
                      ),
                      if (widget.authController.loginError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            widget.authController.loginError!,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 14),
                          ),
                        ),
                      if (widget.authController.loginLoading)
                        const CircularProgressIndicator()
                      else
                        FormButton(
                            isValid: _isFormValid,
                            buttonTitle: 'Войти',
                            subTitle: 'Нет аккаунта? Создать',
                            navigate: widget.changeForm,
                            submit: _isFormValid ? _handleLogin : () {})
                    ],
                  )),
            ),
          );
        });
  }
}
