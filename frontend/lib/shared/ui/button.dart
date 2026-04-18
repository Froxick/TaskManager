import 'package:flutter/material.dart';
import 'package:frontend/shared/theme/colors.dart';

class Button extends StatelessWidget {
  final String title;
  final VoidCallback onPress;
  final bool bold;
  final double padding;
  final bool isValid;
  final double? width;
  final double? height;

  const Button(
      {super.key,
      required this.title,
      required this.bold,
      required this.onPress,
      required this.padding,
      required this.isValid,
      this.width,
      this.height});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: SizedBox(
        width: width ?? double.infinity,
        height: height ?? 50,
        child: ElevatedButton(
            onPressed: isValid ? onPress : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.all(padding),
              disabledBackgroundColor: const Color.fromARGB(255, 61, 61, 61),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: isValid ? 2 : 0,
            ),
            child: Text(
              title,
              style: TextStyle(
                  color:
                      isValid ? AppColors.buttonText : AppColors.textDisabled,
                  fontSize: 16,
                  fontWeight: bold ? FontWeight.w700 : FontWeight.normal),
            )),
      ),
    );
  }
}
