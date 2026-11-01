import 'package:flutter_test/flutter_test.dart';
import 'package:smart_health_app/core/routing/auth_redirect.dart';
import 'package:smart_health_app/core/routing/routes.dart';
import 'package:smart_health_app/core/services/auth_session.dart';

/// Shortcut with the defaults of a brand-new, signed-out visitor.
String? redirect(
  String location, {
  bool seen = true,
  bool loggedIn = false,
  bool verified = false,
  ProfileStatus profile = ProfileStatus.unknown,
  bool bypass = false,
}) {
  return resolveRedirect(
    location: location,
    isOnboardingSeen: seen,
    isLoggedIn: loggedIn,
    isEmailVerified: verified,
    profileStatus: profile,
    bypassAuth: bypass,
  );
}

void main() {
  group('onboarding not seen yet', () {
    test('every screen goes back to onboarding', () {
      expect(redirect(Routes.login, seen: false), Routes.onboarding);
      expect(redirect(Routes.home, seen: false), Routes.onboarding);
      expect(redirect(Routes.publicTerms, seen: false), Routes.onboarding);
    });

    test('onboarding itself is allowed', () {
      expect(redirect(Routes.onboarding, seen: false), isNull);
    });
  });

  group('signed out', () {
    test('can open the public auth screens and the terms', () {
      for (final route in [
        Routes.login,
        Routes.signUp,
        Routes.forgotPassword,
        Routes.resetSent,
        Routes.publicTerms,
      ]) {
        expect(redirect(route), isNull, reason: route);
      }
    });

    test('is sent to login from every private screen', () {
      for (final route in [
        Routes.home,
        Routes.doctors,
        Routes.profile,
        Routes.verifyEmail,
        Routes.completeProfile,
        Routes.splash,
      ]) {
        expect(redirect(route), Routes.login, reason: route);
      }
    });

    test('is sent to login after onboarding was seen', () {
      expect(redirect(Routes.onboarding), Routes.login);
    });
  });

  group('signed in but email not verified', () {
    test('stays on the verify screen', () {
      expect(redirect(Routes.verifyEmail, loggedIn: true), isNull);
    });

    test('everything else goes to the verify screen', () {
      for (final route in [
        Routes.home,
        Routes.login,
        Routes.completeProfile,
        Routes.profile,
      ]) {
        expect(
          redirect(route, loggedIn: true),
          Routes.verifyEmail,
          reason: route,
        );
      }
    });
  });

  group('verified, profile still loading', () {
    test('waits on the splash screen', () {
      expect(redirect(Routes.home, loggedIn: true, verified: true), Routes.splash);
      expect(redirect(Routes.login, loggedIn: true, verified: true), Routes.splash);
      expect(redirect(Routes.splash, loggedIn: true, verified: true), isNull);
    });
  });

  group('verified, profile completed', () {
    String? go(String location) => redirect(
      location,
      loggedIn: true,
      verified: true,
      profile: ProfileStatus.completed,
    );

    test('entry screens lead to home', () {
      for (final route in [
        Routes.login,
        Routes.signUp,
        Routes.forgotPassword,
        Routes.onboarding,
        Routes.verifyEmail,
        Routes.splash,
      ]) {
        expect(go(route), Routes.home, reason: route);
      }
    });

    test('app screens are allowed', () {
      for (final route in [
        Routes.home,
        Routes.doctors,
        Routes.bloodDonation,
        Routes.medicalRecords,
        Routes.profile,
        '${Routes.profile}/${Routes.personalInfo}',
        Routes.completeProfile,
        Routes.publicTerms,
      ]) {
        expect(go(route), isNull, reason: route);
      }
    });
  });

  group('verified, profile incomplete', () {
    String? go(String location) => redirect(
      location,
      loggedIn: true,
      verified: true,
      profile: ProfileStatus.incomplete,
    );

    test('entry screens lead to complete profile', () {
      for (final route in [
        Routes.login,
        Routes.onboarding,
        Routes.verifyEmail,
        Routes.splash,
      ]) {
        expect(go(route), Routes.completeProfile, reason: route);
      }
    });

    test('complete profile is allowed', () {
      expect(go(Routes.completeProfile), isNull);
    });

    test('"Skip for now" works: home is not forced back', () {
      expect(go(Routes.home), isNull);
    });
  });

  group('BYPASS_AUTH (developer shortcut)', () {
    test('skips every guard', () {
      expect(redirect(Routes.profile, bypass: true), isNull);
      expect(redirect(Routes.login, bypass: true), isNull);
      expect(redirect(Routes.verifyEmail, bypass: true), isNull);
    });

    test('onboarding leads straight to home', () {
      expect(redirect(Routes.onboarding, bypass: true), Routes.home);
    });

    test('onboarding is still required the first time', () {
      expect(
        redirect(Routes.home, bypass: true, seen: false),
        Routes.onboarding,
      );
    });
  });
}
