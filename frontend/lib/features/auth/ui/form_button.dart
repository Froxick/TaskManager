import 'package:flutter/material.dart';
import 'package:frontend/shared/theme/colors.dart';
import 'package:frontend/shared/ui/button.dart';

class FormButton extends StatelessWidget {
  final String buttonTitle;
  final String subTitle;
  final VoidCallback submit;
  final VoidCallback navigate;

  const FormButton(
      {super.key,
      required this.buttonTitle,
      required this.subTitle,
      required this.navigate,
      required this.submit});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    return Column(
      children: [
        Button(
            title: buttonTitle,
            bold: true,
            onPress: submit,
            padding: height * 0.01,
            height: height * 0.06,
            isValid: true),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: navigate,
            child: Text(
              subTitle,
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: AppColors.primary,
                  decorationColor: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}
