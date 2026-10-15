import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_health_app/core/constants/app_assets.dart';
import 'package:smart_health_app/core/routing/routes.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool isObscure = true;

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
              SizedBox(
                height: 36,
                child: Row(
                  children: [
                    SvgPicture.asset(AppAssets.authIcon_1),
                    SizedBox(width: 10),
                    Text('Smart Health', style: AppTextStyles.headlineLarge),
                  ],
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                height: 61,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome back', style: AppTextStyles.headlineLarge),
                    SizedBox(height: 4),
                    Text(
                      'Log in to manage your appointments and records.',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Form
              const CustomTextField(
                label: 'Email Address',
                hintText: 'e.g. example@gmail.com',
                suffixIcon: Icon(
                  Icons.email_outlined,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Password',
                hintText: '••••••••••••',
                isPassword: isObscure,
                suffixIcon: IconButton(
                  color: AppColors.textMuted,
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                  icon: Icon(
                    isObscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Forgot Password Link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.push(Routes.forgotPassword),
                  child: const Text(
                    'Forgot Password?',
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Submit Button
              CustomButton(
                text: 'Log In',
                onPressed: () => context.go(Routes.home),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppAssets.lock),
                  const SizedBox(width: 3),
                  Text(
                    "Your health data stays private to your account.",
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 40),
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
