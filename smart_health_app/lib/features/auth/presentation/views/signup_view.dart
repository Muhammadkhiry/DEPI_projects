import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_health_app/core/constants/app_assets.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textDark),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(AppAssets.authIcon_2),
                  SizedBox(width: 10),
                  Text('Smart Health', style: AppTextStyles.headlineLarge),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 77,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create your account',
                      style: AppTextStyles.headlineLarge,
                    ),
                    SizedBox(height: 4),
                    Text('''Join Smart Health to manage appointments and
records.''', style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const CustomTextField(
                label: 'Full Name',
                hintText: 'Enter your full name',
              ),
              const SizedBox(height: 20),
              const CustomTextField(
                label: 'Email Address',
                hintText: 'Enter your email',
              ),
              const SizedBox(height: 20),
              const CustomTextField(
                label: 'Password',
                hintText: 'Create a strong password',
                isPassword: true,
              ),
              const SizedBox(height: 20),
              const CustomTextField(
                label: 'Confirm Password',
                hintText: 'Create a strong password',
                isPassword: true,
              ),
              const SizedBox(height: 28),

              CustomButton(
                text: 'Sign Up',
                onPressed: () => context.push('/verify-email'),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: AppTextStyles.bodyMedium,
                  ),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppAssets.lock),
                  const SizedBox(width: 3),
                  Text(
                    "Stored securely in your private account.",
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
