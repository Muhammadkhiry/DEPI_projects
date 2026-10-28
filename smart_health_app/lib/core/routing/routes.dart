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

  // Sub-routes under /bloodDonation
  // (NO leading slash: nested GoRoute paths must be relative)
  static const String requestBlood = 'request-blood';
  static const String requestSuccess = 'request-success';
  static const String requestDetails = 'request-details';
  static const String donorRegistration = 'donor-registration';
  static const String donorRegistered = 'donor-registered';
  static const String donationHistory = 'donation-history';

  // Sub-routes under /profile
  static const String personalInfo = 'personalInfo';
  static const String medicalInfo = 'medicalInfo';
  static const String notificationSettings = 'notification';
  static const String accountPrivacy = 'accountPrivacy';
  static const String helpCenter = 'helpCenter';
  static const String termsConditions = 'termsConditions';
}
