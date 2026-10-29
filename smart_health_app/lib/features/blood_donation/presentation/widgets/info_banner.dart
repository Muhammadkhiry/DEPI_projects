import 'package:flutter/material.dart';
import 'package:smart_health_app/core/theme/app_colors.dart';
import 'package:smart_health_app/core/theme/app_text_styles.dart';

class InfoBanner extends StatelessWidget {
  final IconData icon;
  final String? title;
  final String message;
  final Color color;

  const InfoBanner({
    super.key,
    required this.icon,
    required this.message,
    this.title,
    this.color = AppColors.tertiary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                Text(message,
                    style: AppTextStyles.bodyMedium.copyWith(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
