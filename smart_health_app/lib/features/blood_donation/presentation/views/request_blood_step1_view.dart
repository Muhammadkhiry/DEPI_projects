import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_health_app/core/theme/app_colors.dart';
import 'package:smart_health_app/core/theme/app_text_styles.dart';
import 'package:smart_health_app/core/widgets/custom_button.dart';
import 'package:smart_health_app/features/blood_donation/presentation/models/blood_request_model.dart';
import 'package:smart_health_app/features/blood_donation/presentation/request_blood_cubit/request_blood_cubit.dart';
import 'package:smart_health_app/features/blood_donation/presentation/request_blood_cubit/request_blood_state.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/blood_type_selector.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/bottom_action_bar.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/info_banner.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/section_label.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/step_progress_bar.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/units_stepper.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/urgency_option_card.dart';

class RequestBloodStep1View extends StatelessWidget {
  const RequestBloodStep1View({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RequestBloodCubit>();

    return BlocBuilder<RequestBloodCubit, RequestBloodState>(
      builder: (context, state) {
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
                      title: 'Patient & Blood details',
                    ),
                    const SizedBox(height: 16),
                    const _CriticalHeaderCard(),
                    const SizedBox(height: 22),
                    SectionLabel(
                      'Blood type needed',
                      required: true,
                      trailing: state.bloodType == null
                          ? null
                          : Text(
                              '${state.bloodType} Selected',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
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
                    SectionLabel(
                      'Units needed',
                      required: true,
                      trailing: Text(
                        'Max. 10 per request',
                        style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 10),
                    UnitsStepper(
                      units: state.units,
                      minUnits: RequestBloodCubit.minUnits,
                      maxUnits: RequestBloodCubit.maxUnits,
                      onIncrement: cubit.incrementUnits,
                      onDecrement: cubit.decrementUnits,
                      onPreset: cubit.setUnits,
                    ),
                    const SizedBox(height: 22),
                    SectionLabel(
                      'Urgency level',
                      required: true,
                      trailing: Text(
                        'Response timeline',
                        style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...UrgencyLevel.values.map(
                      (level) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: UrgencyOptionCard(
                          level: level,
                          selected: state.urgency == level,
                          onTap: () => cubit.selectUrgency(level),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const InfoBanner(
                      icon: Icons.info_outline,
                      color: AppColors.secondary,
                      title: 'PROTOCOL CONSTRAINT NOTICE',
                      message:
                          'Requests are published exclusively to the in-app verified donor public board. '
                          'Smart Health does not automatically blast, push-notify, or spam donors directly. '
                          'Donors voluntarily respond based on live availability.',
                    ),
                  ],
                ),
              ),
            ),
            BottomActionBar(
              child: CustomButton(
                type: ButtonType.secondary,
                text: 'Next: Hospital details',
                onPressed: cubit.goToStep2,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CriticalHeaderCard extends StatelessWidget {
  const _CriticalHeaderCard();

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
              Icons.monitor_heart_outlined,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Critical Transfusion Request',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Priority 1A',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 10,
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Verify ABO/Rh compatibility against the official patient wristband or blood slip.',
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
