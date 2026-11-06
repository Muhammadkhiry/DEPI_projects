import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_search_input.dart';
import '../../../../core/widgets/app_state_widgets.dart';
import 'emergency_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralBg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Home',
                    style: AppTextStyles.headlineLarge.copyWith(fontSize: 24),
                  ),
                ),
                IconButton(
                  tooltip: 'Notifications',
                  onPressed: () => context.push('/home/notifications'),
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(
                        Icons.notifications_none_rounded,
                        color: AppColors.primary,
                        size: 27,
                      ),
                      Positioned(
                        right: 1,
                        top: 1,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                const CircleAvatar(
                  radius: 19,
                  backgroundColor: Color(0xFFD9F3EF),
                  child: Text(
                    'SJ',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              'Good morning, Sarah',
              style: AppTextStyles.headlineMedium.copyWith(fontSize: 21),
            ),
            const SizedBox(height: 5),
            Text(
              'Your health journey starts with one small step.',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 18),
            AppSearchInput(
              hintText: 'Search doctors, clinics, tests...',
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  context.push('/home/search-global?q=${Uri.encodeComponent(value.trim())}');
                }
              },
              onFilterTap: () => AppToast.show(context, 'Search filters are coming soon.'),
            ),
            const SizedBox(height: 18),
            _EmergencyBanner(
              onTap: () => EmergencyNumbersSheet.show(context),
            ),
            const SizedBox(height: 23),
            AppSectionHeader(
              title: 'Quick Services',
              actionText: 'See all',
              onAction: () => context.go('/bloodDonation'),
            ),
            const SizedBox(height: 11),
            Row(
              children: [
                Expanded(
                  child: _QuickServiceCard(
                    icon: Icons.calendar_month_outlined,
                    title: 'Appointments',
                    color: AppColors.primary,
                    onTap: () => context.go('/doctors'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _QuickServiceCard(
                    icon: Icons.water_drop_outlined,
                    title: 'Donate Blood',
                    color: AppColors.secondary,
                    onTap: () => context.go('/bloodDonation'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _QuickServiceCard(
                    icon: Icons.folder_open_outlined,
                    title: 'My Records',
                    color: AppColors.tertiary,
                    onTap: () => context.go('/medicalRecords'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 23),
            AppSectionHeader(
              title: 'Upcoming Appointment',
              actionText: 'View all',
              onAction: () => context.go('/doctors'),
            ),
            const SizedBox(height: 11),
            const _UpcomingAppointmentCard(),
            const SizedBox(height: 23),
            AppSectionHeader(
              title: 'Health Tips',
              actionText: 'See all',
              onAction: () => context.push('/home/articles-list'),
            ),
            const SizedBox(height: 11),
            const _HealthTipCard(),
            const SizedBox(height: 23),
            AppSectionHeader(title: 'Blood Donation'),
            const SizedBox(height: 11),
            _BloodDonationCard(
              onTap: () => context.push('/bloodDonation/request-details?role=donor'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmergencyBanner extends StatelessWidget {
  const _EmergencyBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.secondary,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.emergency_outlined,
                  color: Colors.white,
                  size: 27,
                ),
              ),
              const SizedBox(width: 13),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Emergency Support',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Find important emergency numbers',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 17),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickServiceCard extends StatelessWidget {
  const _QuickServiceCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          constraints: const BoxConstraints(minHeight: 102),
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 25),
              const SizedBox(height: 9),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UpcomingAppointmentCard extends StatelessWidget {
  const _UpcomingAppointmentCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 25,
                backgroundColor: Color(0xFFE5F4F2),
                child: Icon(Icons.person, color: AppColors.primary, size: 27),
              ),
              const SizedBox(width: 11),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dr. Evelyn Reed',
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Cardiology Consultation',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const AppStatusChip(label: 'Upcoming', color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.neutralBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AppointmentInfoRow(
                  icon: Icons.calendar_today_outlined,
                  text: 'Thu, Oct 8 • 10:30 AM',
                ),
                SizedBox(height: 7),
                _AppointmentInfoRow(
                  icon: Icons.location_on_outlined,
                  text: 'Mercy Health Pavilion, Suite 402',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AppointmentInfoRow extends StatelessWidget {
  const _AppointmentInfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 17, color: AppColors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: AppColors.textDark, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class _HealthTipCard extends StatelessWidget {
  const _HealthTipCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            backgroundColor: Color(0xFFE2F3EE),
            child: Icon(Icons.water_drop_outlined, color: AppColors.primary),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stay hydrated',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  'Drink water regularly throughout your day.',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BloodDonationCard extends StatelessWidget {
  const _BloodDonationCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFF8E9EA),
            child: Icon(Icons.bloodtype, color: AppColors.secondary),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '2 Units Needed • O−',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 3),
                Text(
                  'Critical blood request nearby',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onTap,
            tooltip: 'View request',
            icon: const Icon(Icons.arrow_forward_ios, size: 17),
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
