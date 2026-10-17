import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';

class CompleteProfileView extends StatelessWidget {
  const CompleteProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralBg,
      appBar: AppBar(
        title: const Text('Complete Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textDark,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Almost Done! 📋', style: AppTextStyles.headlineLarge),
              const SizedBox(height: 8),
              Text(
                'Complete your profile details to personalize your health experience.',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 24),

              // Profile Image Avatar Upload
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: const Icon(Icons.person, size: 60, color: AppColors.primary),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, size: 18, color: AppColors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              const CustomTextField(
                label: 'Phone Number',
                hintText: '+20 123 456 7890',
                prefixIcon: Icon(Icons.phone_outlined, color: AppColors.primary),
              ),
              const SizedBox(height: 16),
              const CustomTextField(
                label: 'Date of Birth',
                hintText: 'DD/MM/YYYY',
                prefixIcon: Icon(Icons.calendar_today_outlined, color: AppColors.primary),
              ),
              const SizedBox(height: 16),
              const CustomTextField(
                label: 'Gender',
                hintText: 'Select Gender',
                prefixIcon: Icon(Icons.person_outline, color: AppColors.primary),
              ),
              const SizedBox(height: 32),

              CustomButton(
                text: 'Save and Continue',
                onPressed: () => context.go('/home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}