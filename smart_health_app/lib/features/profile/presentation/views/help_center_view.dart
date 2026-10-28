import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class HelpCenterView extends StatelessWidget {
  const HelpCenterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralBg,
      appBar: AppBar(
        title: const Text('Help Center'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ExpansionTile(
            title: Text('How do I book an appointment?', style: AppTextStyles.bodyLarge),
            children: [
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Go to the Doctors tab, choose a specialty, select your doctor, pick a suitable time slot, and confirm your booking.',
                  style: AppTextStyles.bodyMedium,
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('How does blood donation request work?', style: AppTextStyles.bodyLarge),
            children: [
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'You can post an urgent blood request or search for nearby donors directly in the Blood Donation tab.',
                  style: AppTextStyles.bodyMedium,
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('Is my medical data secure?', style: AppTextStyles.bodyLarge),
            children: [
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Yes, all your health records and personal data are encrypted and accessible only by you.',
                  style: AppTextStyles.bodyMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}