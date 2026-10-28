import 'package:flutter/material.dart';
import 'package:smart_health_app/core/theme/app_colors.dart';
import 'package:smart_health_app/core/theme/app_text_styles.dart';

class UnitsProgress extends StatelessWidget {
  final int secured;
  final int total;
  final String percentLabel;
  final Color color;

  const UnitsProgress({
    super.key,
    required this.secured,
    required this.total,
    this.percentLabel = 'Secured',
    this.color = AppColors.secondary,
  });

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : (secured / total).clamp(0.0, 1.0);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$secured of $total ${total == 1 ? 'Unit' : 'Units'}'
              '${percentLabel == 'Secured' ? '' : ' secured'}',
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            Text(
              '${(progress * 100).round()}% $percentLabel',
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 7,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}
