import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppSearchInput extends StatelessWidget {
  const AppSearchInput({
    super.key,
    this.hintText = 'Search doctors, clinics, tests...',
    this.controller,
    this.onChanged,
    this.onFilterTap,
    this.onSubmitted,
  });

  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
          suffixIcon: onFilterTap == null
              ? null
              : IconButton(
                  tooltip: 'Filter',
                  onPressed: onFilterTap,
                  icon: const Icon(Icons.tune, color: AppColors.primary),
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
