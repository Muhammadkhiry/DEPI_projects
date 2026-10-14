import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_health_app/core/routing/routes.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              // Header
              Text('Welcome Back 👋', style: AppTextStyles.headlineLarge),
              const SizedBox(height: 8),
              Text(
                'Sign in to access your health dashboard and appointments.',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 40),

              // Form
              const CustomTextField(
                label: 'Email Address',
                hintText: 'Enter your email',
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 20),
              const CustomTextField(
                label: 'Password',
                hintText: 'Enter your password',
                isPassword: true,
                prefixIcon: Icon(Icons.lock_outline, color: AppColors.primary),
                suffixIcon: Icon(
                  Icons.visibility_off_outlined,
                  color: AppColors.textMuted,
                ),
              ),

              // Forgot Password Link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.push(Routes.forgotPassword),
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              CustomButton(
                text: 'Log In',
                onPressed: () => context.go(Routes.home),
              ),
              const SizedBox(height: 24),

              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: AppTextStyles.bodyMedium,
                  ),
                  GestureDetector(
                    onTap: () => context.push(Routes.signUp),
                    child: const Text(
                      'Sign Up',
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
