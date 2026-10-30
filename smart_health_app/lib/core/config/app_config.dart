/// Build-time switches. Pass them with `--dart-define`, e.g.
/// `flutter run --dart-define=BYPASS_AUTH=true`.
abstract class AppConfig {
  /// When true the router skips the login / email-verification guards, so
  /// teammates can open any screen without creating an account.
  /// Never enable this in a release build.
  static const bool bypassAuth = bool.fromEnvironment('BYPASS_AUTH');

  /// When true the app talks to the local Firebase Emulator Suite instead of
  /// the real project (`flutter run --dart-define=USE_EMULATOR=true`).
  static const bool useEmulator = bool.fromEnvironment('USE_EMULATOR');

  /// Where the emulators run, as seen from the app.
  /// - Android emulator: 10.0.2.2 (default)
  /// - iOS simulator / desktop / web: localhost
  /// - real phone on the same Wi-Fi: your PC's IP, e.g. 192.168.1.20
  static const String emulatorHost = String.fromEnvironment(
    'EMULATOR_HOST',
    defaultValue: '10.0.2.2',
  );
}
