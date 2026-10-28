import 'package:flutter/material.dart';
import 'package:smart_health_app/core/theme/app_colors.dart';
import 'package:smart_health_app/core/theme/app_text_styles.dart';

class SectionLabel extends StatelessWidget {
  final String text;
  final bool required;
  final Widget? trailing;

  const SectionLabel(this.text, {super.key, this.required = false, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text.rich(
          TextSpan(
            text: text,
            style: AppTextStyles.bodyLarge
                .copyWith(fontWeight: FontWeight.w700, fontSize: 15),
            children: [
              if (required)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: AppColors.secondary),
                ),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
