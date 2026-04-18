import 'package:flutter/material.dart';
import 'package:frontend/main_app.dart';
import 'package:frontend/shared/store/jwt_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final jwtStore = JwtStore();
  final isTokens = await jwtStore.hasTokens();
  runApp(MainApp(
    hasToken: isTokens,
  ));
}
