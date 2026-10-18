import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_health_app/features/auth/presentation/views/complete_profile_view.dart';
import 'package:smart_health_app/features/auth/presentation/views/forgot_password_view.dart';
import 'package:smart_health_app/features/auth/presentation/views/login_view.dart';
import 'package:smart_health_app/features/auth/presentation/views/reset_sent_view.dart';
import 'package:smart_health_app/features/auth/presentation/views/signup_view.dart';
import 'package:smart_health_app/features/auth/presentation/views/verify_email_view.dart';
import 'package:smart_health_app/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:smart_health_app/features/profile/presentation/views/account_privacy_view.dart';
import 'package:smart_health_app/features/profile/presentation/views/help_center_view.dart';
import 'package:smart_health_app/features/profile/presentation/views/medical_info_view.dart';
import 'package:smart_health_app/features/profile/presentation/views/notification_settings_view.dart';
import 'package:smart_health_app/features/profile/presentation/views/personal_info_view.dart';
import 'package:smart_health_app/features/profile/presentation/views/profile_view.dart';
import 'package:smart_health_app/features/profile/presentation/views/terms_conditions_view.dart';

import '../theme/app_colors.dart';
import 'routes.dart';

Widget _placeholder(String title) => Scaffold(
  appBar: AppBar(
    title: Text(title),
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.white,
  ),
  body: Center(
    child: Text(
      'Placeholder: $title',
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  ),
);

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.onboarding,
  routes: [
    // 1. Auth & Onboarding Flow
    GoRoute(
      path: Routes.onboarding,
      builder: (context, state) => const OnboardingView(),
    ),
    GoRoute(path: Routes.login, builder: (context, state) => const LoginView()),
    GoRoute(
      path: Routes.signUp,
      builder: (context, state) => const SignupView(),
    ),
    GoRoute(
      path: Routes.forgotPassword,
      builder: (context, state) => const ForgotPasswordView(),
    ),
    GoRoute(
      path: Routes.resetSent,
      builder: (context, state) => const ResetSentView(),
    ),
    GoRoute(
      path: Routes.verifyEmail,
      builder: (context, state) => const VerifyEmailView(),
    ),
    GoRoute(
      path: Routes.completeProfile,
      builder: (context, state) => const CompleteProfileView(),
    ),

    // 2. Main 5-Tab Shell Navigation
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: navigationShell.currentIndex,
            onTap: (index) => navigationShell.goBranch(index),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textMuted,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.medical_services_outlined),
                activeIcon: Icon(Icons.medical_services),
                label: 'Doctors',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bloodtype_outlined),
                activeIcon: Icon(Icons.bloodtype),
                label: 'Blood',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.folder_outlined),
                activeIcon: Icon(Icons.folder),
                label: 'Records',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
      branches: [
        // Tab 1: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.home,
              builder: (context, state) => _placeholder('Home Dashboard'),
              routes: [
                GoRoute(
                  path: 'notifications',
                  builder: (context, state) => _placeholder('Notifications'),
                ),
                GoRoute(
                  path: 'search-global',
                  builder: (context, state) => _placeholder('Global Search'),
                ),
                GoRoute(
                  path: 'emergency',
                  builder: (context, state) =>
                      _placeholder('Emergency Support'),
                ),
                GoRoute(
                  path: 'banner-details',
                  builder: (context, state) =>
                      _placeholder('Banner / Offer Details'),
                ),
                GoRoute(
                  path: 'articles-list',
                  builder: (context, state) => _placeholder('Health Articles'),
                ),
              ],
            ),
          ],
        ),
        // Tab 2: Doctors
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.doctors,
              builder: (context, state) => _placeholder('Doctors Search'),
              routes: [
                GoRoute(
                  path: 'specialties',
                  builder: (context, state) => _placeholder('Specialties List'),
                ),
                GoRoute(
                  path: 'doctor-details',
                  builder: (context, state) => _placeholder('Doctor Details'),
                ),
                GoRoute(
                  path: 'select-time-slot',
                  builder: (context, state) => _placeholder('Select Time Slot'),
                ),
                GoRoute(
                  path: 'booking-summary',
                  builder: (context, state) => _placeholder('Booking Summary'),
                ),
                GoRoute(
                  path: 'payment-method',
                  builder: (context, state) => _placeholder('Payment Method'),
                ),
                GoRoute(
                  path: 'booking-success',
                  builder: (context, state) => _placeholder('Booking Success'),
                ),
                GoRoute(
                  path: 'my-appointments',
                  builder: (context, state) => _placeholder('My Appointments'),
                ),
                GoRoute(
                  path: 'appointment-details',
                  builder: (context, state) =>
                      _placeholder('Appointment Details'),
                ),
                GoRoute(
                  path: 'write-review',
                  builder: (context, state) => _placeholder('Write Review'),
                ),
              ],
            ),
          ],
        ),
        // Tab 3: Blood Donation
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.bloodDonation,
              builder: (context, state) =>
                  _placeholder('Blood Donation Dashboard'),
              routes: [
                GoRoute(
                  path: 'find-donors',
                  builder: (context, state) => _placeholder('Find Donors'),
                ),
                GoRoute(
                  path: 'request-blood',
                  builder: (context, state) => _placeholder('Create Request'),
                ),
                GoRoute(
                  path: 'request-details',
                  builder: (context, state) => _placeholder('Request Details'),
                ),
                GoRoute(
                  path: 'donor-profile',
                  builder: (context, state) => _placeholder('Donor Profile'),
                ),
                GoRoute(
                  path: 'donation-history',
                  builder: (context, state) => _placeholder('Donation History'),
                ),
              ],
            ),
          ],
        ),
        // Tab 4: Records
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.medicalRecords,
              builder: (context, state) =>
                  _placeholder('Medical Records Vault'),
              routes: [
                GoRoute(
                  path: 'scan-document',
                  builder: (context, state) => _placeholder('Document Scanner'),
                ),
                GoRoute(
                  path: 'record-details',
                  builder: (context, state) => _placeholder('Record Details'),
                ),
                GoRoute(
                  path: 'upload-prescription',
                  builder: (context, state) =>
                      _placeholder('Upload Prescription'),
                ),
                GoRoute(
                  path: 'prescriptions-list',
                  builder: (context, state) =>
                      _placeholder('Prescriptions List'),
                ),
              ],
            ),
          ],
        ),
        // Tab 5: Profile
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.profile,
              builder: (context, state) => const ProfileView(),
              routes: [
                GoRoute(
                  path: Routes.personalInfo,
                  builder: (context, state) => const PersonalInfoView(),
                ),
                GoRoute(
                  path: Routes.medicalInfo,
                  builder: (context, state) => const MedicalInfoView(),
                ),
                GoRoute(
                  path: Routes.notificationSettings,
                  builder: (context, state) => const NotificationSettingsView(),
                ), // const NotificationSettingsView(),
                GoRoute(
                  path: Routes.accountPrivacy,
                  builder: (context, state) => const AccountPrivacyView(),
                ),
                GoRoute(
                  path: Routes.helpCenter,
                  builder: (context, state) => const HelpCenterView(),
                ),
                GoRoute(
                  path: Routes.termsConditions,
                  builder: (context, state) => const TermsConditionsView(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
