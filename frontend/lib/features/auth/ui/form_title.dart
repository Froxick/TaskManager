import 'package:flutter/material.dart';
import 'package:frontend/shared/theme/colors.dart';

class FormTitle extends StatelessWidget {
  final String title;

  const FormTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 30,
          fontWeight: FontWeight.w700),
    );
  }
}
