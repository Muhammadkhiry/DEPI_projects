import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralBg,
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Profile Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 44,
                    backgroundColor: AppColors.white,
                    child: Icon(Icons.person, size: 50, color: AppColors.primary),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Muhammad Khairy',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'khairy@example.com',
                    style: TextStyle(color: AppColors.white.withValues(alpha: 0.8)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Settings Options List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildProfileTile(
                    icon: Icons.person_outline,
                    title: 'Personal Information',
                    onTap: () => context.push('/profile/personal-info'),
                  ),
                  _buildProfileTile(
                    icon: Icons.medical_information_outlined,
                    title: 'Medical Details',
                    onTap: () => context.push('/profile/medical-info'),
                  ),
                  _buildProfileTile(
                    icon: Icons.notifications_none_outlined,
                    title: 'Notification Settings',
                    onTap: () => context.push('/profile/notification-settings'),
                  ),
                  _buildProfileTile(
                    icon: Icons.security_outlined,
                    title: 'Account & Privacy',
                    onTap: () => context.push('/profile/account-privacy'),
                  ),
                  _buildProfileTile(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: () => context.push('/profile/help-center'),
                  ),
                  _buildProfileTile(
                    icon: Icons.logout,
                    title: 'Log Out',
                    titleColor: AppColors.secondary,
                    onTap: () => context.go('/login'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color titleColor = AppColors.textDark,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      color: AppColors.white,
      child: ListTile(
        leading: Icon(icon, color: titleColor == AppColors.secondary ? AppColors.secondary : AppColors.primary),
        title: Text(title, style: AppTextStyles.bodyLarge.copyWith(color: titleColor, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textMuted),
        onTap: onTap,
      ),
    );
  }
}