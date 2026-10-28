import 'package:flutter/material.dart';
import 'package:smart_health_app/core/theme/app_colors.dart';
import 'package:smart_health_app/core/theme/app_text_styles.dart';

class BloodTypeSelector extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onSelected;

  const BloodTypeSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static const List<String> types = [
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-',
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.5,
      children: types.map((type) {
        final isSelected = type == selected;
        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onSelected(type),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.secondary : AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.secondary : AppColors.border,
              ),
            ),
            child: Text(
              type,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: isSelected ? AppColors.white : AppColors.textDark,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
