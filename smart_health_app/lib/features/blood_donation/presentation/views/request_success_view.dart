import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_health_app/core/routing/routes.dart';
import 'package:smart_health_app/core/theme/app_colors.dart';
import 'package:smart_health_app/core/theme/app_text_styles.dart';
import 'package:smart_health_app/core/widgets/custom_button.dart';
import 'package:smart_health_app/features/blood_donation/presentation/models/blood_request_model.dart';

class RequestSuccessView extends StatelessWidget {
  final BloodRequestModel request;
  const RequestSuccessView({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.go(Routes.bloodDonation);
      },
      child: Scaffold(
        backgroundColor: AppColors.neutralBg,
        appBar: AppBar(
          backgroundColor: AppColors.neutralBg,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            'Request Confirmation',
            style: AppTextStyles.headlineMedium.copyWith(fontSize: 18),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.12),
                ),
                child: Center(
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: AppColors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
             const Text('Request posted', style: AppTextStyles.headlineLarge),
              const SizedBox(height: 6),
              const Text(
                'Your blood request is now live on the Smart Health public board.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 14),
              _IdChip(id: request.requestId),
              const SizedBox(height: 20),
              _ShareCard(),
              const SizedBox(height: 16),
              _SummaryCard(request: request),
              const SizedBox(height: 20),
              CustomButton(
                type: ButtonType.secondary,
                text: 'Share request',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Share link copied')),
                  );
                },
              ),
              const SizedBox(height: 10),
              CustomButton(
                type: ButtonType.outlined,
                text: 'View request on public board',
                onPressed: () {
                  context.go(Routes.bloodDonation);
                },
              ),
              const SizedBox(height: 6),
              TextButton(
                onPressed: () => context.go(Routes.home),
                child: Text(
                  'Back to Home',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IdChip extends StatelessWidget {
  final String id;
  const _IdChip({required this.id});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'REQUEST ID: $id',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.copy, size: 14, color: AppColors.primary),
        ],
      ),
    );
  }
}

class _ShareCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.neutralBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.campaign_outlined,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Share it to reach more people',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Since automated donor alerts are disabled, sharing this request directly via messaging helps find matching donors faster.',
                  style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final BloodRequestModel request;
  const _SummaryCard({required this.request});

  @override
  Widget build(BuildContext context) {
    final location = request.ward.isEmpty
        ? request.hospitalName
        : '${request.hospitalName}\n${request.ward}';

    return Container(
      padding: const EdgeInsets.all(16),
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${request.bloodType} Blood Needed · ${request.urgency.title}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 11,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.circle, size: 8, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(
                    'Active',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 11,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.neutralBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                _row(
                  'Units required',
                  '${request.units} Units',
                  valueColor: AppColors.secondary,
                ),
                const SizedBox(height: 8),
                _row('Patient', '${request.patientInitials} (initials only)'),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _iconLine(Icons.local_hospital_outlined, location),
          const SizedBox(height: 10),
          _iconLine(Icons.phone_outlined, request.phone),
          const SizedBox(height: 10),
          _iconLine(Icons.access_time, 'Just now · Expires in 24 hours'),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {Color? valueColor}) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: AppTextStyles.bodyMedium.copyWith(fontSize: 12)),
      Text(
        value,
        style: AppTextStyles.bodyMedium.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: valueColor ?? AppColors.textDark,
        ),
      ),
    ],
  );

  Widget _iconLine(IconData icon, String text) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 18, color: AppColors.textMuted),
      const SizedBox(width: 10),
      Expanded(
        child: Text(
          text,
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: 12,
            color: AppColors.textDark,
          ),
        ),
      ),
    ],
  );
}
