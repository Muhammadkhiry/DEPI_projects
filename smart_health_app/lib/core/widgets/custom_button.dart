import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum ButtonType { primary, secondary, outlined, inverted }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  final double? width;
  final double height;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.width,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    BorderSide borderSide = BorderSide.none;

    switch (type) {
      case ButtonType.primary:
        backgroundColor = AppColors.primary;
        textColor = AppColors.white;
        break;
      case ButtonType.secondary:
        backgroundColor = AppColors.secondary;
        textColor = AppColors.white;
        break;
      case ButtonType.inverted:
        backgroundColor = AppColors.textDark;
        textColor = AppColors.white;
        break;
      case ButtonType.outlined:
        backgroundColor = Colors.transparent;
        textColor = AppColors.primary;
        borderSide = const BorderSide(color: AppColors.primary, width: 1.5);
        break;
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: borderSide,
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: AppTextStyles.buttonText.copyWith(color: textColor),
        ),
      ),
    );
  }
}