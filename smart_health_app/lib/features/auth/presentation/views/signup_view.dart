import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
              Text('Create Account 🚀', style: AppTextStyles.headlineLarge),
              const SizedBox(height: 8),
              Text(
                'Join Smart Health to connect with doctors and health services.',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 32),

              const CustomTextField(
                label: 'Full Name',
                hintText: 'Enter your full name',
                prefixIcon: Icon(Icons.person_outline, color: AppColors.primary),
              ),
              const SizedBox(height: 16),
              const CustomTextField(
                label: 'Email Address',
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email_outlined, color: AppColors.primary),
              ),
              const SizedBox(height: 16),
              const CustomTextField(
                label: 'Password',
                hintText: 'Create a strong password',
                isPassword: true,
                prefixIcon: Icon(Icons.lock_outline, color: AppColors.primary),
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
                  const Text('Already have an account? ', style: AppTextStyles.bodyMedium),
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
            ],
          ),
        ),
      ),
    );
  }
}