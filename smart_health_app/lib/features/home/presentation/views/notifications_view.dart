import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class NotificationSettingsView extends StatefulWidget {
  const NotificationSettingsView({super.key});

  @override
  State<NotificationSettingsView> createState() =>
      _NotificationSettingsViewState();
}

class _NotificationSettingsViewState extends State<NotificationSettingsView> {
  bool _appointments = true;
  bool _bloodRequests = true;
  bool _offers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralBg,
      appBar: AppBar(
        title: const Text('Notification Settings'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              activeThumbColor: AppColors.primary,
              title: const Text(
                'Appointment Reminders',
                style: AppTextStyles.bodyLarge,
              ),
              subtitle: const Text('Get notified about upcoming doctor visits'),
              value: _appointments,
              onChanged: (val) => setState(() => _appointments = val),
            ),
            const Divider(),
            SwitchListTile(
              activeThumbColor: AppColors.primary,
              title: const Text(
                'Urgent Blood Requests',
                style: AppTextStyles.bodyLarge,
              ),
              subtitle: const Text('Alerts when someone near you needs blood'),
              value: _bloodRequests,
              onChanged: (val) => setState(() => _bloodRequests = val),
            ),
            const Divider(),
            SwitchListTile(
              activeThumbColor: AppColors.primary,
              title: const Text(
                'Promotions & Offers',
                style: AppTextStyles.bodyLarge,
              ),
              value: _offers,
              onChanged: (val) => setState(() => _offers = val),
            ),
          ],
        ),
      ),
    );
  }
}
