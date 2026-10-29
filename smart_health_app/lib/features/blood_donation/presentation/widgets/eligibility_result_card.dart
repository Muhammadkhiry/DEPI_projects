import 'package:flutter/material.dart';
import 'package:smart_health_app/core/theme/app_colors.dart';
import 'package:smart_health_app/core/theme/app_text_styles.dart';
import 'package:smart_health_app/features/blood_donation/presentation/models/donor_models.dart';
import 'package:smart_health_app/features/blood_donation/presentation/utils/date_formatter.dart';

class EligibilityResultCard extends StatelessWidget {
  final EligibilityResult? result;
  const EligibilityResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final r = result;
    final Color color;
    final IconData icon;
    final String title;
    final String message;

    if (r == null) {
      color = AppColors.textMuted;
      icon = Icons.hourglass_empty;
      title = 'Your result will appear here';
      message =
          'Fill in your blood type, weight and last donation date to get an instant assessment.';
    } else {
      title = r.title;
      message = r.message;
      switch (r.status) {
        case EligibilityStatus.eligible:
          color = AppColors.primary;
          icon = Icons.check_circle_outline;
        case EligibilityStatus.waitPeriod:
          color = const Color(0xFFE08A00);
          icon = Icons.schedule;
        case EligibilityStatus.ineligible:
          color = AppColors.secondary;
          icon = Icons.block;
      }
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title,
                    style: AppTextStyles.bodyLarge
                        .copyWith(fontWeight: FontWeight.w700, color: color)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(message, style: AppTextStyles.bodyMedium.copyWith(fontSize: 12)),
          if (r?.nextEligibleDate != null) ...[
            const SizedBox(height: 8),
            Text('Next eligible date: ${DateFormatter.long(r!.nextEligibleDate!)}',
                style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark)),
          ],
          if (r?.status == EligibilityStatus.eligible) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.event_available, size: 16, color: color),
                const SizedBox(width: 6),
                Text('Ready for Step 2 slot reservation',
                    style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: color)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
