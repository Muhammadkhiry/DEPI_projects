import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_health_app/core/theme/app_colors.dart';
import 'package:smart_health_app/core/theme/app_text_styles.dart';
import 'package:smart_health_app/core/widgets/custom_button.dart';
import 'package:smart_health_app/features/blood_donation/presentation/donor_registration_cubit/donor_registration_cubit.dart';
import 'package:smart_health_app/features/blood_donation/presentation/donor_registration_cubit/donor_registration_state.dart';
import 'package:smart_health_app/features/blood_donation/presentation/models/donor_models.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/age_stepper.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/blood_type_selector.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/bottom_action_bar.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/eligibility_result_card.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/info_banner.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/last_donation_field.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/section_label.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/step_progress_bar.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/weight_input.dart';

class DonorEligibilityStep extends StatelessWidget {
  const DonorEligibilityStep({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DonorRegistrationCubit>();

    return BlocBuilder<DonorRegistrationCubit, DonorRegistrationState>(
      builder: (context, state) {
        final result = state.eligibility;
        final eligible = result?.status == EligibilityStatus.eligible;

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const StepProgressBar(
                      current: 1,
                      title: 'Eligibility Assessment',
                    ),
                    const SizedBox(height: 16),
                    const InfoBanner(
                      icon: Icons.shield_outlined,
                      color: AppColors.primary,
                      title: 'Instant on-device assessment',
                      message: 'Private & offline-ready. Eligibility is calculated securely on your phone with zero network sync delays.',
                    ),
                    const SizedBox(height: 22),

                    // Blood type
                    SectionLabel(
                      'Blood Type',
                      required: true,
                      trailing:
                          (state.bloodType != null &&
                              isUniversalRedCellDonor(state.bloodType!))
                          ? Text(
                              'Universal Red Cell',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.secondary,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Select your ABO and Rh factor. Don't worry if unsure; staff will verify.",
                      style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    BloodTypeSelector(
                      selected: state.bloodType,
                      onSelected: cubit.selectBloodType,
                    ),
                    if (state.showStep1Errors && state.bloodType == null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Please select a blood type',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const SizedBox(height: 22),

                    // Age
                    SectionLabel(
                      'Age',
                      required: true,
                      trailing: Text(
                        'Must be 18-65 yrs',
                        style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 10),
                    AgeStepper(
                      age: state.age,
                      onIncrement: cubit.incrementAge,
                      onDecrement: cubit.decrementAge,
                    ),
                    const SizedBox(height: 22),

                    // Weight
                    SectionLabel(
                      'Body Weight',
                      required: true,
                      trailing: WeightUnitToggle(
                        unit: state.weightUnit,
                        onChanged: cubit.setWeightUnit,
                      ),
                    ),
                    const SizedBox(height: 10),
                    WeightInput(
                      value: state.weightValue,
                      valueKg: state.weightKg,
                      unit: state.weightUnit,
                      onChanged: cubit.setWeightText,
                      onUnitChanged: cubit.setWeightUnit,
                    ),
                    const SizedBox(height: 22),

                    // Last donation
                    SectionLabel(
                      'Last Whole Blood Donation Date',
                      trailing: Text(
                        '84-day spacing',
                        style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 10),
                    LastDonationField(
                      date: state.lastDonationDate,
                      neverDonated: state.neverDonated,
                      onDatePicked: cubit.setLastDonation,
                      onNeverChanged: cubit.setNeverDonated,
                    ),
                    const SizedBox(height: 22),

                    EligibilityResultCard(result: result),
                  ],
                ),
              ),
            ),
            BottomActionBar(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.bloodType != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${bloodTypeFullName(state.bloodType!)}'
                            '${eligible ? ' · Eligible to Donate' : ''}',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: eligible
                                  ? AppColors.secondary
                                  : AppColors.textMuted,
                            ),
                          ),
                          Text(
                            '1 min left',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  CustomButton(
                    type: ButtonType.secondary,
                    text: 'Next: Preferences',
                    onPressed: () {
                      final error = cubit.goToPreferences();
                      if (error != null) {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(SnackBar(content: Text(error)));
                      }
                    },
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
