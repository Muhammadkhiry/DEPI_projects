import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class TermsConditionsView extends StatelessWidget {
  const TermsConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralBg,
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Terms of Service', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 12),
            const Text(
              'Welcome to Smart Health. By using our application, you agree to comply with and be bound by the following terms and conditions regarding healthcare services, data privacy, and booking policies.',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text('Privacy Policy', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 12),
            const Text(
              'We collect personal and medical details solely to improve your healthcare experience. Your data will never be shared with third parties without your explicit consent.',
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}