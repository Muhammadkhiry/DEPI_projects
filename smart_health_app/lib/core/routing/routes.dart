abstract class Routes {
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signUp = '/signUp';
  static const String forgotPassword = '/forgotPassword';
  static const String resetSent = '/resetSent';
  static const String verifyEmail = '/verifyEmail';
  static const String completeProfile = '/completeProfile';

  // Shell Tabs
  static const String home = '/home';
  static const String doctors = '/doctors';
  static const String bloodDonation = '/bloodDonation';
  static const String medicalRecords = '/medicalRecords';
  static const String profile = '/profile';

  // Sub-routes under /profile
  static const String personalInfo = 'personalInfo';
  static const String medicalInfo = 'medicalInfo';
  static const String notification = 'notification';
}
