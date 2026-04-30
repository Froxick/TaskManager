import 'package:flutter/material.dart';
import 'package:frontend/DI/di.dart';
import 'package:frontend/features/auth/auth_notifier.dart';
import 'package:frontend/features/user/controllers/user_controller.dart';
import 'package:frontend/main_app.dart';
import 'package:frontend/shared/store/jwt_store.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DI.init();
  final jwtStore = Get.find<JwtStore>();
  final hasToken = await jwtStore.hasTokens();
  authNotifier.value = hasToken;
  Get.put(UserController(jwtStore));

  runApp(MainApp());
}
