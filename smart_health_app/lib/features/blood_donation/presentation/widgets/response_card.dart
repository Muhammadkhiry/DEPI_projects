import 'package:flutter/material.dart';
import 'package:smart_health_app/core/theme/app_colors.dart';
import 'package:smart_health_app/core/theme/app_text_styles.dart';
import 'package:smart_health_app/features/blood_donation/presentation/models/request_details_models.dart';
import 'package:smart_health_app/features/blood_donation/presentation/utils/time_helpers.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/status_pill.dart';

class ResponseCard extends StatelessWidget {
  final DonorResponseModel response;
  final bool canAct;
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final VoidCallback onMarkDonated;

  const ResponseCard({
    super.key,
    required this.response,
    required this.canAct,
    required this.onAccept,
    required this.onDecline,
    required this.onMarkDonated,
  });

  (String, Color, IconData?) get _pill => switch (response.status) {
    ResponseStatus.offered => ('Offered', kAmber, null),
    ResponseStatus.accepted => ('Accepted', AppColors.primary, null),
    ResponseStatus.donated => ('Donated', AppColors.primary, Icons.check),
    ResponseStatus.declined => ('Declined', AppColors.textMuted, null),
  };

  @override
  Widget build(BuildContext context) {
    final r = response;
    final (label, color, icon) = _pill;

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
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.neutralBg,
                child: Text(
                  r.initials,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            r.name,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (r.isVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified,
                            size: 14,
                            color: AppColors.primary,
                          ),
                        ],
                        if (r.isUniversal) ...[
                          const SizedBox(width: 6),
                          const StatusPill(
                            text: 'Universal',
                            color: AppColors.tertiary,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        StatusPill(
                          text: r.bloodType,
                          color: AppColors.secondary,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            r.note,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              StatusPill(text: label, color: color, icon: icon),
            ],
          ),
          const SizedBox(height: 12),
          if (r.status == ResponseStatus.donated)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '1 unit completed at ${TimeHelpers.clock(r.completedAt ?? r.offeredAt)} (Verified by Desk)',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.schedule,
                      size: 14,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Offered at ${TimeHelpers.clock(r.offeredAt)}',
                      style: AppTextStyles.bodyMedium.copyWith(fontSize: 11),
                    ),
                  ],
                ),
                if (canAct) _actions(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _actions() {
    switch (response.status) {
      case ResponseStatus.accepted:
        return ElevatedButton.icon(
          onPressed: onMarkDonated,
          icon: const Icon(Icons.check_circle_outline, size: 16),
          label: const Text('Mark as donated'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            elevation: 0,
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      case ResponseStatus.offered:
        return Row(
          children: [
            TextButton(
              onPressed: onDecline,
              child: Text(
                'Decline',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
            ),
            const SizedBox(width: 4),
            ElevatedButton(
              onPressed: onAccept,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Accept',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      case ResponseStatus.donated:
      case ResponseStatus.declined:
        return const SizedBox.shrink();
    }
  }
}
