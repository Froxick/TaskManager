import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/shared/theme/colors.dart';

class FormInput extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final TextInputType type;
  final int maxLength;
  final bool isPassword;
  final String? label;
  final double? height;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const FormInput(
      {super.key,
      required this.controller,
      required this.placeholder,
      required this.type,
      required this.maxLength,
      this.validator,
      this.isPassword = false,
      this.label,
      this.height,
      this.errorText,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        SizedBox(
          height: height,
          child: TextFormField(
            controller: controller,
            maxLength: maxLength,
            onChanged: onChanged,
            validator: validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: type,
            obscureText: isPassword,
            obscuringCharacter: '*',
            inputFormatters: [
              if (type == TextInputType.numberWithOptions(decimal: true))
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
              if (type == TextInputType.number)
                FilteringTextInputFormatter.digitsOnly
            ],
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
            decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: TextStyle(color: Colors.grey),
                labelText: label,
                labelStyle: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                errorText: errorText,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border, width: 1)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary)),
                filled: true,
                fillColor: AppColors.surfaceVariant),
          ),
        )
      ],
    );
  }
}
