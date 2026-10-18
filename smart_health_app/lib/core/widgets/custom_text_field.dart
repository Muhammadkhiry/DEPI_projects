import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String? value)? validator; 

  const CustomTextField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator, 
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField( 
          controller: controller,
          obscureText: isPassword,
          validator: validator, 
          style: AppTextStyles.bodyLarge,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.bodyMedium,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.0,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}