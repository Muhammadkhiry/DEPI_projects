/// Build-time switches. Pass them with `--dart-define`, e.g.
/// `flutter run --dart-define=BYPASS_AUTH=true`.
abstract class AppConfig {
  /// When true the router skips the login / email-verification guards, so
  /// teammates can open any screen without creating an account.
  /// Never enable this in a release build.
  static const bool bypassAuth = bool.fromEnvironment('BYPASS_AUTH');
}
