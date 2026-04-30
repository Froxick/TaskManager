import 'package:flutter/material.dart';

import 'package:frontend/router/router.dart';
import 'package:frontend/shared/theme/theme.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}
