// app_router.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_health_app/core/config/app_config.dart';
import 'package:smart_health_app/core/services/auth_session.dart';
import 'package:smart_health_app/core/services/service_locator.dart';
import 'package:smart_health_app/core/utils/cache_helper.dart';
import 'package:smart_health_app/features/auth/presentation/auth_cubit/auth_cubit.dart';
import 'package:smart_health_app/features/auth/presentation/views/complete_profile_view.dart';
import 'package:smart_health_app/features/auth/presentation/views/forgot_password_view.dart';
import 'package:smart_health_app/features/auth/presentation/views/login_view.dart';
import 'package:smart_health_app/features/auth/presentation/views/reset_sent_view.dart';
import 'package:smart_health_app/features/auth/presentation/views/signup_view.dart';
import 'package:smart_health_app/features/auth/presentation/views/verify_email_view.dart';
import 'package:smart_health_app/features/blood_donation/presentation/donation_history_cubit/donation_history_cubit.dart';
import 'package:smart_health_app/features/blood_donation/presentation/donor_registration_cubit/donor_registration_cubit.dart';
import 'package:smart_health_app/features/blood_donation/presentation/models/blood_request_model.dart';
import 'package:smart_health_app/features/blood_donation/presentation/models/donor_models.dart';
import 'package:smart_health_app/features/blood_donation/presentation/models/request_details_models.dart';
import 'package:smart_health_app/features/blood_donation/presentation/request_blood_cubit/request_blood_cubit.dart';
import 'package:smart_health_app/features/blood_donation/presentation/views/donation_history_view.dart';
import 'package:smart_health_app/features/blood_donation/presentation/views/donor_registered_view.dart';
import 'package:smart_health_app/features/blood_donation/presentation/views/donor_registration_view.dart';
import 'package:smart_health_app/features/blood_donation/presentation/views/request_blood_view.dart';
import 'package:smart_health_app/features/blood_donation/presentation/views/request_details_page.dart';
import 'package:smart_health_app/features/blood_donation/presentation/views/request_success_view.dart';
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

/// TEMP: launcher for the blood donation screens until the real
/// Blood Donation Dashboard is designed. Delete it afterwards.
class _BloodTempDashboard extends StatelessWidget {
  const _BloodTempDashboard();

  @override
  Widget build(BuildContext context) {
    const base = Routes.bloodDonation;
    final items = <(String, String, Object?)>[
      ('Request Blood', '$base/${Routes.requestBlood}', null),
      ('Become a Donor', '$base/${Routes.donorRegistration}', null),
      ('Donation History', '$base/${Routes.donationHistory}', null),
      (
        'Request Details (requester view)',
        '$base/${Routes.requestDetails}',
        const RequestDetailsArgs(requestId: '#REQ-90482', isOwner: true),
      ),
      (
        'Request Details (donor view)',
        '$base/${Routes.requestDetails}',
        const RequestDetailsArgs(requestId: '#REQ-90482', isOwner: false),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Donation (temp)'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: ListView.separated(
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final item = items[i];
          return ListTile(
            title: Text(item.$1),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(item.$2, extra: item.$3),
          );
        },
      ),
    );
  }
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.onboarding,
  // Re-run `redirect` whenever the user signs in/out or verifies the email.
  refreshListenable: getIt<AuthSession>(),
  redirect: (context, state) {
    final session = getIt<AuthSession>();
    final bool isOnboardingSeen = CacheHelper.getBool(key: 'isOnboardingSeen');
    final String location = state.matchedLocation;

    final bool isOnboarding = location == Routes.onboarding;
    // Screens a signed-out user is allowed to see.
    final bool isPublicAuthRoute =
        location == Routes.login ||
        location == Routes.signUp ||
        location == Routes.forgotPassword ||
        location == Routes.resetSent;
    final bool isVerifyEmail = location == Routes.verifyEmail;
    final bool isCompleteProfile = location == Routes.completeProfile;

    // 1. Onboarding not seen yet: it is the only screen allowed.
    if (!isOnboardingSeen) {
      return isOnboarding ? null : Routes.onboarding;
    }

    // Terms must be readable before signing up.
    if (location == Routes.publicTerms) return null;

    // Dev shortcut (flutter run --dart-define=BYPASS_AUTH=true):
    // skip the login guards so every screen can be opened.
    if (AppConfig.bypassAuth) {
      return isOnboarding ? Routes.home : null;
    }

    // 2. Signed out: only login / sign up / forgot password screens.
    if (!session.isLoggedIn) {
      return isPublicAuthRoute ? null : Routes.login;
    }

    // 3. Signed in but email not verified yet: stay on the verify screen.
    if (!session.isEmailVerified) {
      return isVerifyEmail ? null : Routes.verifyEmail;
    }

    // 4. Signed in and verified.
    if (isCompleteProfile) return null;
    // Just verified the email: next step of onboarding is the profile.
    if (isVerifyEmail) return Routes.completeProfile;
    if (isPublicAuthRoute || isOnboarding) return Routes.home;

    return null;
  },
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
      builder: (context, state) =>
          ResetSentView(email: state.extra as String? ?? ''),
    ),
    GoRoute(
      path: Routes.publicTerms,
      builder: (context, state) => const TermsConditionsView(),
    ),
    GoRoute(
      path: Routes.verifyEmail,
      builder: (context, state) => const VerifyEmailView(),
    ),
    GoRoute(
      path: Routes.completeProfile,
      builder: (context, state) => BlocProvider(
        create: (context) => getIt<AuthCubit>(),
        child: const CompleteProfileView(),
      ),
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
              // TEMP launcher. Replace with the real dashboard later.
              builder: (context, state) => const _BloodTempDashboard(),
              routes: [
                GoRoute(
                  path: 'find-donors',
                  builder: (context, state) => _placeholder('Find Donors'),
                ),

                // --- Request Blood (2 steps) + confirmation ---
                GoRoute(
                  path: Routes.requestBlood,
                  builder: (context, state) => BlocProvider(
                    create: (_) => RequestBloodCubit(),
                    child: const RequestBloodView(),
                  ),
                  routes: [
                    GoRoute(
                      path: Routes.requestSuccess,
                      builder: (context, state) => RequestSuccessView(
                        request: state.extra as BloodRequestModel,
                      ),
                    ),
                  ],
                ),

                // --- Request Details (requester / donor view) ---
                GoRoute(
                  path: Routes.requestDetails,
                  builder: (context, state) => RequestDetailsPage(
                    args:
                        (state.extra as RequestDetailsArgs?) ??
                        // fallback so it opens without arguments while testing
                        const RequestDetailsArgs(
                          requestId: '#REQ-90482',
                          isOwner: true,
                        ),
                  ),
                ),

                // --- Donor registration (2 steps) + registered ---
                GoRoute(
                  path: Routes.donorRegistration,
                  builder: (context, state) => BlocProvider(
                    create: (_) => DonorRegistrationCubit(),
                    child: const DonorRegistrationView(),
                  ),
                  routes: [
                    GoRoute(
                      path: Routes.donorRegistered,
                      builder: (context, state) => DonorRegisteredView(
                        profile: state.extra as DonorProfileModel,
                      ),
                    ),
                  ],
                ),

                // --- Donation history ---
                GoRoute(
                  path: Routes.donationHistory,
                  builder: (context, state) => BlocProvider(
                    create: (_) => DonationHistoryCubit()..load(),
                    child: const DonationHistoryView(),
                  ),
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
                  builder: (context, state) => BlocProvider(
                    create: (context) => getIt<AuthCubit>(),
                    child: const PersonalInfoView(),
                  ),
                ),
                GoRoute(
                  path: Routes.medicalInfo,
                  builder: (context, state) => BlocProvider(
                    create: (context) => getIt<AuthCubit>(),
                    child: const MedicalInfoView(),
                  ),
                ),
                GoRoute(
                  path: Routes.notificationSettings,
                  builder: (context, state) => const NotificationSettingsView(),
                ),
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
