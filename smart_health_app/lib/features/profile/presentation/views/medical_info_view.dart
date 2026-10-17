import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';

class MedicalInfoView extends StatelessWidget {
  const MedicalInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralBg,
      appBar: AppBar(
        title: const Text('Medical Information'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CustomTextField(
              label: 'Blood Type',
              hintText: 'O+',
              prefixIcon: Icon(
                Icons.bloodtype_outlined,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 16),
            const CustomTextField(
              label: 'Allergies',
              hintText: 'Penicillin, Dust',
              prefixIcon: Icon(
                Icons.warning_amber_rounded,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            const CustomTextField(
              label: 'Chronic Conditions',
              hintText: 'None',
              prefixIcon: Icon(
                Icons.medical_services_outlined,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 32),
            CustomButton(text: 'Update Medical Profile', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
