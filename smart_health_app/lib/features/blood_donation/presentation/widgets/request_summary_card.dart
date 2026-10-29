import 'package:flutter/material.dart';
import 'package:smart_health_app/core/theme/app_colors.dart';
import 'package:smart_health_app/core/theme/app_text_styles.dart';
import 'package:smart_health_app/features/blood_donation/presentation/models/blood_request_model.dart';
import 'package:smart_health_app/features/blood_donation/presentation/models/request_details_models.dart';
import 'package:smart_health_app/features/blood_donation/presentation/utils/time_helpers.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/expiry_chip.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/status_pill.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/units_progress.dart';

/// Header card shared by the requester and donor views.
class RequestSummaryCard extends StatelessWidget {
  final BloodRequestDetails request;
  final VoidCallback onDirections;
  final VoidCallback onCall;

  /// Donor view: red accent bar + "Matches your profile" tag + extra subtitle.
  final bool donorMode;
  final bool matchesProfile;
  final String donorBloodType;

  const RequestSummaryCard({
    super.key,
    required this.request,
    required this.onDirections,
    required this.onCall,
    this.donorMode = false,
    this.matchesProfile = true,
    this.donorBloodType = '',
  });

  String get _priorityLabel {
    if (request.status == RequestStatus.cancelled) return 'CANCELLED';
    if (request.status == RequestStatus.fulfilled) return 'FULFILLED';
    if (request.isExpired) return 'EXPIRED';
    final base = request.urgency.title.toUpperCase();
    return donorMode ? '$base PRIORITY' : base;
  }

  @override
  Widget build(BuildContext context) {
    final color = request.isOpen
        ? urgencyColorOf(request.urgency)
        : (request.status == RequestStatus.fulfilled
              ? AppColors.primary
              : AppColors.textMuted);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (donorMode) Container(width: 4, color: color),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatusPill(text: _priorityLabel, color: color),
                        ExpiryChip(
                          expiresAt: request.expiresAt,
                          closed: !request.isOpen,
                        ),
                      ],
                    ),
                    if (donorMode) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              (matchesProfile
                                      ? AppColors.primary
                                      : AppColors.secondary)
                                  .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              matchesProfile
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              size: 14,
                              color: matchesProfile
                                  ? AppColors.primary
                                  : AppColors.secondary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              matchesProfile
                                  ? 'Matches your $donorBloodType profile'
                                  : 'Not compatible with your $donorBloodType profile',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: matchesProfile
                                    ? AppColors.primary
                                    : AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: color.withValues(alpha: 0.4)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                request.bloodType,
                                style: AppTextStyles.headlineMedium.copyWith(
                                  color: color,
                                  fontSize: 20,
                                ),
                              ),
                              if (request.bloodType == 'O-')
                                Text(
                                  'UNIVERSAL',
                                  style: TextStyle(
                                    fontSize: 7,
                                    fontWeight: FontWeight.w700,
                                    color: color,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                request.productName,
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (donorMode)
                                Text(
                                  request.department,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    UnitsProgress(
                      secured: request.unitsSecured,
                      total: request.units,
                      percentLabel: donorMode ? 'Complete' : 'Secured',
                      color: request.status == RequestStatus.fulfilled
                          ? AppColors.primary
                          : AppColors.secondary,
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.neutralBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.local_hospital_outlined,
                                size: 18,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  request.hospitalName,
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.only(left: 26),
                            child: Text(
                              '${request.ward} · ${request.triagePoint}',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(left: 26),
                            child: Wrap(
                              spacing: 12,
                              children: [
                                Text(
                                  'Posted ${TimeHelpers.ago(request.postedAt)}',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontSize: 11,
                                  ),
                                ),
                                Text(
                                  donorMode
                                      ? 'Request ID: ${request.id}'
                                      : request.id,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _ActionButton(
                            icon: Icons.near_me_outlined,
                            label: 'Directions',
                            onTap: onDirections,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _ActionButton(
                            icon: Icons.phone_outlined,
                            label: 'Call Hospital',
                            onTap: onCall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.border),
        backgroundColor: AppColors.neutralBg,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
