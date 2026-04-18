import 'package:flutter/material.dart';
import 'package:frontend/features/auth/screen/auth_screen.dart';
import 'package:frontend/features/home/screen/home_screen.dart';
import 'package:frontend/shared/theme/theme.dart';

class MainApp extends StatelessWidget {
  final bool hasToken;
  const MainApp({super.key, required this.hasToken});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: hasToken ? HomeScreen() : AuthScreen(),
    );
  }
}
