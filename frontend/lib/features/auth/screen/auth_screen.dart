import 'package:flutter/material.dart';
import 'package:frontend/features/auth/controllers/auth_controller.dart';
import 'package:frontend/features/auth/controllers/login_form_controller.dart';
import 'package:frontend/features/auth/controllers/regisrer_form_controller.dart';
import 'package:frontend/features/auth/widgets/login_form.dart';
import 'package:frontend/features/auth/widgets/register_form.dart';
import 'package:frontend/features/home/screen/home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  String _formType = 'register';
  final RegisterFormController _registerControllers = RegisterFormController();
  final LoginFormController _loginControllers = LoginFormController();
  final AuthController _authController = AuthController();

  void setForm() {
    setState(() {
      _formType = _formType == 'register' ? 'login' : 'register';

      if (_formType == 'login') {
        _authController.clearLoginError();
      } else {
        _authController.clearRegisterError();
      }
    });
  }

  @override
  void dispose() {
    _registerControllers.dispose();
    _loginControllers.dispose();
    _authController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    void navigateToHome() {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomeScreen()));
    }

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
          height: _formType == 'register' ? height * 0.65 : height * 0.5,
          child: _formType == 'register'
              ? RegisterForm(
                  navigate: navigateToHome,
                  changeForm: setForm,
                  controllers: _registerControllers,
                  authController: _authController,
                )
              : LoginForm(
                  navigate: navigateToHome,
                  changeForm: setForm,
                  controllers: _loginControllers,
                  authController: _authController,
                ),
        ),
      ),
    );
  }
}
