import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_health_app/core/routing/routes.dart';
import 'package:smart_health_app/core/theme/app_colors.dart';
import 'package:smart_health_app/core/theme/app_text_styles.dart';
import 'package:smart_health_app/features/blood_donation/presentation/donor_registration_cubit/donor_registration_cubit.dart';
import 'package:smart_health_app/features/blood_donation/presentation/donor_registration_cubit/donor_registration_state.dart';
import 'package:smart_health_app/features/blood_donation/presentation/views/donation_preferences_step.dart';
import 'package:smart_health_app/features/blood_donation/presentation/views/donor_eligibility_step.dart';

class DonorRegistrationView extends StatelessWidget {
  const DonorRegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DonorRegistrationCubit, DonorRegistrationState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status == DonorRegistrationStatus.success) {
          context.go(
            '${Routes.bloodDonation}/${Routes.donorRegistration}/${Routes.donorRegistered}',
            extra: state.profile,
          );
        } else if (state.status == DonorRegistrationStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'Error')),
          );
        }
      },
      builder: (context, state) {
        final isStep1 = state.step == 1;
        return PopScope(
          canPop: isStep1,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) context.read<DonorRegistrationCubit>().previousStep();
          },
          child: Scaffold(
            backgroundColor: AppColors.neutralBg,
            appBar: AppBar(
              backgroundColor: AppColors.neutralBg,
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
                onPressed: () {
                  if (!isStep1) {
                    context.read<DonorRegistrationCubit>().previousStep();
                  } else if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(Routes.bloodDonation);
                  }
                },
              ),
              title: Text(
                isStep1 ? 'Donor Eligibility' : 'Donation Preferences',
                style: AppTextStyles.headlineMedium.copyWith(fontSize: 18),
              ),
              actions: const [
                Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.person, size: 18, color: AppColors.white),
                  ),
                ),
              ],
            ),
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isStep1
                  ? const DonorEligibilityStep(key: ValueKey('eligibility'))
                  : const DonationPreferencesStep(key: ValueKey('prefs')),
            ),
          ),
        );
      },
    );
  }
}
