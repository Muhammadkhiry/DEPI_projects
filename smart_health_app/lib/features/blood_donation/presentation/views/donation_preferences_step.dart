import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_health_app/core/theme/app_colors.dart';
import 'package:smart_health_app/core/theme/app_text_styles.dart';
import 'package:smart_health_app/core/widgets/custom_button.dart';
import 'package:smart_health_app/features/blood_donation/presentation/donor_registration_cubit/donor_registration_cubit.dart';
import 'package:smart_health_app/features/blood_donation/presentation/donor_registration_cubit/donor_registration_state.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/bottom_action_bar.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/check_tile.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/info_banner.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/preference_switch_tile.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/step_progress_bar.dart';

class DonationPreferencesStep extends StatelessWidget {
  const DonationPreferencesStep({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DonorRegistrationCubit>();

    return BlocBuilder<DonorRegistrationCubit, DonorRegistrationState>(
      builder: (context, s) {
        final type = s.bloodType ?? '';
        final err = s.showStep2Errors;

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const StepProgressBar(
                      current: 2,
                      title: 'Preferences & Consent',
                    ),
                    const SizedBox(height: 20),

                    _SectionTitle(
                      'Health & Safety Self-Declaration',
                      subtitle:
                          'Confirm you meet standard clinical criteria today:',
                    ),
                    CheckTile(
                      value: s.feelingWell,
                      onChanged: cubit.setFeelingWell,
                      hasError: err,
                      title: 'Feeling well, rested, and clear of symptoms',
                      subtitle: 'No fever, persistent cough, chills, or flu-like fatigue within the last 48 hours.',
                    ),
                    const SizedBox(height: 10),
                    CheckTile(
                      value: s.noInvasiveProcedures,
                      onChanged: cubit.setNoInvasive,
                      hasError: err,
                      title: 'No recent invasive blood procedures',
                      subtitle: 'No dental surgery, professional tattoos, or piercing needles in the last 6 months.',
                    ),
                    const SizedBox(height: 10),
                    CheckTile(
                      value: s.medicationClear,
                      onChanged: cubit.setMedicationClear,
                      hasError: err,
                      title: 'Medication clearance',
                      subtitle: 'I am not currently taking oral antibiotics or active prescription blood thinners.',
                    ),
                    const SizedBox(height: 24),

                    _SectionTitle(
                      'In-App Coordination',
                      subtitle: 'Control how hospital appeals appear when you check the app:',
                    ),
                    const InfoBanner(
                      icon: Icons.notifications_off_outlined,
                      message: 'Smart Health never sends push blasts or unprompted noise.',
                    ),
                    const SizedBox(height: 10),
                    PreferenceSwitchTile(
                      icon: Icons.dynamic_feed_outlined,
                      title: 'Show matching requests in feed',
                      subtitle:
                          'Highlights matching $type urgent cases on your Blood Donation map and hospital feed when you open the app. No push notifications or spam blasts.',
                      value: s.showInFeed,
                      onChanged: cubit.setShowInFeed,
                    ),
                    const SizedBox(height: 10),
                    PreferenceSwitchTile(
                      icon: Icons.phone_callback_outlined,
                      title: 'Let requesters call me after I offer',
                      subtitle: 'When you tap "I can donate" on an open request and the requester accepts your offer, your registered phone number is shared for direct hospital intake coordination.',
                      value: s.allowCalls,
                      onChanged: cubit.setAllowCalls,
                    ),
                    const SizedBox(height: 24),

                    _SectionTitle('Clinical Consent'),
                    CheckTile(
                      value: s.consentAgreed,
                      onChanged: cubit.setConsent,
                      hasError: err,
                      title: 'Voluntary blood donation agreement',
                      subtitle: 'I consent to voluntary blood donation and agree to standard hospital verification protocols upon arrival at the intake triage desk.',
                    ),
                    const SizedBox(height: 12),
                    const InfoBanner(
                      icon: Icons.lock_outline,
                      color: AppColors.primary,
                      title: 'Patient & Donor Privacy Guarantee',
                      message: 'Your information stays private. Only verified requesters receive your contact when you explicitly choose to offer. Smart Health never sells data, spams donors, or reveals your direct contacts on public boards.',
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        'Standardized under Red Cross & WHO Blood Donor Triage Standards',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BottomActionBar(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ready to register · $type Donor',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondary,
                          ),
                        ),
                        Text(
                          'Triage Step 2/2',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomButton(
                    type: ButtonType.secondary,
                    text: s.isSubmitting
                        ? 'Registering...'
                        : 'Register as donor',
                    onPressed: s.isSubmitting ? () {} : cubit.register,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Your information stays private. Only verified requesters receive contact after offer.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  const _SectionTitle(this.title, {this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}
