import 'package:flutter/material.dart';
import 'package:smart_health_app/core/theme/app_colors.dart';
import 'package:smart_health_app/core/theme/app_text_styles.dart';

class AgeStepper extends StatelessWidget {
  final int age;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const AgeStepper({
    super.key,
    required this.age,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _btn(Icons.remove, false, onDecrement),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('$age',
                  style: AppTextStyles.headlineLarge
                      .copyWith(color: AppColors.primary)),
              const SizedBox(width: 6),
             const Text('years', style: AppTextStyles.bodyMedium),
            ],
          ),
          _btn(Icons.add, true, onIncrement),
        ],
      ),
    );
  }

  Widget _btn(IconData icon, bool filled, VoidCallback onTap) => InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled ? AppColors.primary : AppColors.neutralBg,
          ),
          child: Icon(icon, color: filled ? AppColors.white : AppColors.primary),
        ),
      );
}
