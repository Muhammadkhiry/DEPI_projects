import 'package:flutter/material.dart';
import 'package:smart_health_app/core/theme/app_colors.dart';
import 'package:smart_health_app/core/theme/app_text_styles.dart';
import 'package:smart_health_app/features/blood_donation/presentation/models/donor_models.dart';
import 'package:smart_health_app/features/blood_donation/presentation/utils/date_formatter.dart';

class DonationRecordCard extends StatelessWidget {
  final DonationRecordModel record;
  const DonationRecordCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final confirmed = record.status == DonationStatus.confirmed;
    final statusColor = confirmed ? AppColors.primary : AppColors.textMuted;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.water_drop_outlined,
                      size: 18, color: AppColors.secondary),
                  const SizedBox(width: 6),
                  Text(DateFormatter.short(record.date),
                      style: AppTextStyles.bodyLarge
                          .copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(confirmed ? 'Confirmed' : 'Self-reported',
                    style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: statusColor)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(record.location,
                style: AppTextStyles.bodyMedium.copyWith(fontSize: 12)),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.neutralBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Donation Type',
                    style: AppTextStyles.bodyMedium.copyWith(fontSize: 12)),
                Text('${record.type} · 1 Unit (${record.volumeMl} ml)',
                    style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(confirmed ? Icons.verified_outlined : Icons.edit_note,
                  size: 15, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Expanded(
                child: Text(record.note,
                    style: AppTextStyles.bodyMedium.copyWith(fontSize: 11)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
