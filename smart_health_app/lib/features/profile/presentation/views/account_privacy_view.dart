import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';

class AccountPrivacyView extends StatelessWidget {
  const AccountPrivacyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralBg,
      appBar: AppBar(
        title: const Text('Account & Privacy'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Security', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.lock_reset, color: AppColors.primary),
              title: const Text('Change Password', style: AppTextStyles.bodyLarge),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            const Divider(height: 32),
            Text('Danger Zone', style: AppTextStyles.headlineMedium.copyWith(color: AppColors.secondary)),
            const SizedBox(height: 12),
            Text(
              'Once you delete your account, all your medical history and data will be permanently removed.',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Delete Account',
              type: ButtonType.secondary,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}