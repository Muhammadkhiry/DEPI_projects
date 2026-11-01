import 'package:smart_health_app/core/routing/routes.dart';
import 'package:smart_health_app/core/services/auth_session.dart';

/// Decides where the router must send the user (task 1.8).
///
/// Returns the route to redirect to, or `null` to stay where they are. It is a
/// plain function (no Firebase, no globals) so it can be unit tested.
String? resolveRedirect({
  required String location,
  required bool isOnboardingSeen,
  required bool isLoggedIn,
  required bool isEmailVerified,
  required ProfileStatus profileStatus,
  bool bypassAuth = false,
}) {
  final isOnboarding = location == Routes.onboarding;
  // Screens a signed-out user is allowed to see.
  final isPublicAuthRoute =
      location == Routes.login ||
      location == Routes.signUp ||
      location == Routes.forgotPassword ||
      location == Routes.resetSent;
  final isVerifyEmail = location == Routes.verifyEmail;
  final isCompleteProfile = location == Routes.completeProfile;

  // 1. Onboarding not seen yet: it is the only screen allowed.
  if (!isOnboardingSeen) {
    return isOnboarding ? null : Routes.onboarding;
  }

  // Terms must be readable before signing up.
  if (location == Routes.publicTerms) return null;

  // Dev shortcut (flutter run --dart-define=BYPASS_AUTH=true):
  // skip the login guards so every screen can be opened.
  if (bypassAuth) {
    return isOnboarding ? Routes.home : null;
  }

  // 2. Signed out: only login / sign up / forgot password screens.
  if (!isLoggedIn) {
    return isPublicAuthRoute ? null : Routes.login;
  }

  // 3. Signed in but email not verified yet: stay on the verify screen.
  if (!isEmailVerified) {
    return isVerifyEmail ? null : Routes.verifyEmail;
  }

  // 4. Signed in and verified: wait until we know whether the profile is
  //    complete (a moment on the splash screen).
  if (profileStatus == ProfileStatus.unknown) {
    return location == Routes.splash ? null : Routes.splash;
  }

  // Where a user lands after signing in or verifying the email.
  final landing = profileStatus == ProfileStatus.completed
      ? Routes.home
      : Routes.completeProfile;

  // Stay on "Complete profile" (its "Skip for now" still works because only
  // these entry screens are redirected, not Home).
  if (isCompleteProfile) return null;
  if (isVerifyEmail ||
      isPublicAuthRoute ||
      isOnboarding ||
      location == Routes.splash) {
    return landing;
  }

  return null;
}
