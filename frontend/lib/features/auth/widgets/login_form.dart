import 'package:flutter/material.dart';
import 'package:frontend/features/auth/controllers/login_form_controller.dart';
import 'package:frontend/features/auth/ui/form_button.dart';
import 'package:frontend/features/auth/ui/form_title.dart';
import 'package:frontend/shared/theme/colors.dart';
import 'package:frontend/shared/ui/input.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback changeForm;
  final LoginFormController controllers;
  const LoginForm(
      {super.key, required this.changeForm, required this.controllers});

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
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
                ),
                FormInput(
                  controller: widget.controllers.passwordController,
                  placeholder: 'Пароль',
                  height: height * 0.075,
                  type: TextInputType.text,
                  maxLength: 30,
                  label: 'Пароль',
                  isPassword: true,
                  validator: widget.controllers.validatePassword,
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                FormButton(
                    buttonTitle: 'Войти',
                    subTitle: 'Нет аккаунта? Создать',
                    navigate: widget.changeForm,
                    submit: () => {})
              ],
            )),
      ),
    );
  }
}
