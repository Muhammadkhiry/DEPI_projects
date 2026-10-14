import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Reset Password 🔑', style: AppTextStyles.headlineLarge),
              const SizedBox(height: 8),
              Text(
                'Enter your registered email address and we will send you instructions to reset your password.',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 32),
              const CustomTextField(
                label: 'Email Address',
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email_outlined, color: AppColors.primary),
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Send Reset Link',
                onPressed: () => context.push('/reset-sent'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}