import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_health_app/core/routing/routes.dart';
import 'package:smart_health_app/core/theme/app_colors.dart';
import 'package:smart_health_app/core/theme/app_text_styles.dart';
import 'package:smart_health_app/core/widgets/custom_button.dart';
import 'package:smart_health_app/features/blood_donation/presentation/models/donor_models.dart';
import 'package:smart_health_app/features/blood_donation/presentation/utils/date_formatter.dart';

class DonorRegisteredView extends StatelessWidget {
  final DonorProfileModel profile;
  const DonorRegisteredView({super.key, required this.profile});

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
            'Registration Complete',
            style: AppTextStyles.headlineMedium.copyWith(fontSize: 18),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.12),
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
              Text("You're registered!", style: AppTextStyles.headlineLarge),
              const SizedBox(height: 6),
              Text(
                'Welcome to the Smart Health voluntary donor network, ${profile.firstName}. Your commitment helps save lives.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  _Chip(
                    text: 'ID: ${profile.donorId}',
                    color: AppColors.textDark,
                    icon: Icons.copy,
                  ),
                  _Chip(
                    text: isUniversalRedCellDonor(profile.bloodType)
                        ? 'Verified ${profile.bloodType} Universal'
                        : 'Verified ${profile.bloodType} Donor',
                    color: AppColors.primary,
                    icon: Icons.verified_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _ProfileCard(profile: profile),
              const SizedBox(height: 16),
              const _WhatNextCard(),
              const SizedBox(height: 20),
              CustomButton(
                type: ButtonType.secondary,
                text: 'View open blood requests',
                onPressed: () => context.go(Routes.bloodDonation),
              ),
              const SizedBox(height: 10),
              CustomButton(
                type: ButtonType.outlined,
                text: 'View donation history',
                onPressed: () => context.go(
                  '${Routes.bloodDonation}/${Routes.donationHistory}',
                ),
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

class _Chip extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;
  const _Chip({required this.text, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(width: 6),
          Icon(icon, size: 14, color: color),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final DonorProfileModel profile;
  const _ProfileCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final next = profile.nextEligibleDate;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.medical_information_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Clinical Donor Profile',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Active',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _row(
            'Blood Profile',
            bloodTypeFullName(profile.bloodType).replaceFirst(' ', ''),
          ),
          _row('Eligibility Status', 'Eligible now · Ready'),
          _row(
            'Next Donation',
            next == null ? 'Immediate' : DateFormatter.short(next),
          ),
          _row(
            'In-App Matching',
            profile.showInFeed ? 'No push blasts' : 'Feed highlights off',
          ),
          _row(
            'Contact Sharing',
            profile.allowCalls ? 'Mutual acceptance only' : 'Disabled',
            last: true,
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool last = false}) => Padding(
    padding: EdgeInsets.only(bottom: last ? 0 : 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium.copyWith(fontSize: 12)),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
      ],
    ),
  );
}

class _WhatNextCard extends StatelessWidget {
  const _WhatNextCard();

  static const _steps = [
    'Browse urgent blood requests anytime under the Donate tab.',
    'Tap "I can donate" when you are available to travel to the partner hospital.',
    'Hospital triage desk will verify your ID and hemoglobin on site before safe draw.',
  ];

  @override
  Widget build(BuildContext context) {
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
            children: [
              const Icon(
                Icons.explore_outlined,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'What to Expect Next',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < _steps.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: i == _steps.length - 1 ? 0 : 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                    child: Text(
                      '${i + 1}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _steps[i],
                      style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
