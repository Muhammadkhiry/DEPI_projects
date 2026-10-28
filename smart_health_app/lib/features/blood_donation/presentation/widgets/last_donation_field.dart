import 'package:flutter/material.dart';
import 'package:smart_health_app/core/theme/app_colors.dart';
import 'package:smart_health_app/core/theme/app_text_styles.dart';
import 'package:smart_health_app/features/blood_donation/presentation/utils/date_formatter.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/check_tile.dart';

class LastDonationField extends StatelessWidget {
  final DateTime? date;
  final bool neverDonated;
  final ValueChanged<DateTime> onDatePicked;
  final ValueChanged<bool> onNeverChanged;

  const LastDonationField({
    super.key,
    required this.date,
    required this.neverDonated,
    required this.onDatePicked,
    required this.onNeverChanged,
  });

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: date ?? now,
      firstDate: DateTime(now.year - 10),
      lastDate: now,
    );
    if (picked != null) onDatePicked(picked);
  }

  @override
  Widget build(BuildContext context) {
    String? hint;
    bool eligible = true;
    if (date != null) {
      final days = DateTime.now().difference(date!).inDays;
      eligible = days >= 84;
      hint = eligible
          ? 'Over ${days ~/ 30} months ago (Eligible)'
          : '$days days ago (Wait period)';
    }

    return Column(
      children: [
        Opacity(
          opacity: neverDonated ? 0.45 : 1,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: neverDonated ? null : () => _pick(context),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month_outlined,
                      color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          date == null
                              ? 'Select date'
                              : DateFormatter.long(date!),
                          style: AppTextStyles.bodyLarge
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                        if (hint != null)
                          Text(hint,
                              style: AppTextStyles.bodyMedium.copyWith(
                                  fontSize: 12,
                                  color: eligible
                                      ? AppColors.primary
                                      : const Color(0xFFE08A00))),
                      ],
                    ),
                  ),
                  const Icon(Icons.edit_calendar_outlined,
                      size: 20, color: AppColors.textMuted),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        CheckTile(
          value: neverDonated,
          onChanged: onNeverChanged,
          title: 'Never donated before (First-time donor)',
        ),
      ],
    );
  }
}
