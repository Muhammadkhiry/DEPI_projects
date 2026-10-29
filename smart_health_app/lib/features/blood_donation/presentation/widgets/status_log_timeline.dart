import 'package:flutter/material.dart';
import 'package:smart_health_app/core/theme/app_colors.dart';
import 'package:smart_health_app/core/theme/app_text_styles.dart';
import 'package:smart_health_app/features/blood_donation/presentation/models/request_details_models.dart';
import 'package:smart_health_app/features/blood_donation/presentation/utils/time_helpers.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/status_pill.dart';

class StatusLogTimeline extends StatelessWidget {
  final List<StatusLogEntry> entries;
  const StatusLogTimeline({super.key, required this.entries});

  (IconData, Color) _style(LogType t) => switch (t) {
    LogType.donated => (Icons.check, AppColors.primary),
    LogType.accepted => (Icons.person_add_alt_1_outlined, AppColors.tertiary),
    LogType.offered => (Icons.back_hand_outlined, kAmber),
    LogType.posted => (Icons.bloodtype_outlined, AppColors.secondary),
    LogType.declined => (Icons.close, AppColors.textMuted),
    LogType.cancelled => (Icons.cancel_outlined, AppColors.secondary),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          for (var i = 0; i < entries.length; i++)
            _row(entries[i], isLast: i == entries.length - 1),
        ],
      ),
    );
  }

  Widget _row(StatusLogEntry e, {required bool isLast}) {
    final (icon, color) = _style(e.type);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 30,
            child: Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(alpha: 0.12),
                  ),
                  child: Icon(icon, size: 15, color: color),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 1.5, color: AppColors.border),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          e.title,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Text(
                        TimeHelpers.clock(e.time),
                        style: AppTextStyles.bodyMedium.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    e.description,
                    style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
