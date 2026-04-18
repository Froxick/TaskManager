import 'package:flutter/material.dart';
import 'package:frontend/features/auth/controllers/login_form_controller.dart';
import 'package:frontend/features/auth/controllers/regisrer_form_controller.dart';
import 'package:frontend/features/auth/widgets/login_form.dart';
import 'package:frontend/features/auth/widgets/register_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  String form = 'register';
  RegisterFormController registerControllers = RegisterFormController();
  LoginFormController loginControllers = LoginFormController();

  void setForm() {
    setState(() {
      form = form == 'register' ? 'login' : 'register';
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    double formWidth;
    if (width > 1200) {
      formWidth = width * 0.25;
    } else if (width > 600) {
      formWidth = width * 0.4;
    } else {
      formWidth = width * 0.85;
    }

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: formWidth,
          height: form == 'register' ? height * 0.60 : height * 0.5,
          child: form == 'register'
              ? RegisterForm(
                  changeForm: setForm,
                  controllers: registerControllers,
                )
              : LoginForm(
                  changeForm: setForm,
                  controllers: loginControllers,
                ),
        ),
      ),
    );
  }
}
