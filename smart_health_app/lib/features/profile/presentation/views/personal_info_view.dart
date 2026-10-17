import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';

class PersonalInfoView extends StatelessWidget {
  const PersonalInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralBg,
      appBar: AppBar(
        title: const Text('Personal Information'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CustomTextField(
              label: 'Full Name',
              hintText: 'Muhammad Khairy',
              prefixIcon: Icon(Icons.person_outline, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            const CustomTextField(
              label: 'Email Address',
              hintText: 'khairy@example.com',
              prefixIcon: Icon(Icons.email_outlined, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            const CustomTextField(
              label: 'Phone Number',
              hintText: '+20 123 456 7890',
              prefixIcon: Icon(Icons.phone_outlined, color: AppColors.primary),
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Save Changes',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}