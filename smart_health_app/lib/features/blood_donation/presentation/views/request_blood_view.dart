import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_health_app/core/routing/routes.dart';
import 'package:smart_health_app/core/theme/app_colors.dart';
import 'package:smart_health_app/core/theme/app_text_styles.dart';
import 'package:smart_health_app/features/blood_donation/presentation/request_blood_cubit/request_blood_cubit.dart';
import 'package:smart_health_app/features/blood_donation/presentation/request_blood_cubit/request_blood_state.dart';
import 'package:smart_health_app/features/blood_donation/presentation/views/request_blood_step1_view.dart';
import 'package:smart_health_app/features/blood_donation/presentation/views/request_blood_step2_view.dart';

class RequestBloodView extends StatelessWidget {
  const RequestBloodView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RequestBloodCubit, RequestBloodState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status == RequestBloodStatus.success) {
          context.go(
            '${Routes.bloodDonation}/${Routes.requestBlood}/${Routes.requestSuccess}',
            extra: state.request,
          );
        } else if (state.status == RequestBloodStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'Error')),
          );
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: state.step == 1,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) context.read<RequestBloodCubit>().previousStep();
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
                  if (state.step == 2) {
                    context.read<RequestBloodCubit>().previousStep();
                  } else if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(Routes.bloodDonation);
                  }
                },
              ),
              title: Text(
                'Request Blood',
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
              child: state.step == 1
                  ? const RequestBloodStep1View(key: ValueKey('step1'))
                  : const RequestBloodStep2View(key: ValueKey('step2')),
            ),
          ),
        );
      },
    );
  }
}
