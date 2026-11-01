import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Crash reporting and analytics (task 1.14).
///
/// Everyone logs through this class instead of calling Firebase directly, so
/// we can switch collection on/off in one place:
/// - only Android and iOS support these plugins (web/desktop are skipped),
/// - data is only collected in release builds, so debug runs and emulator
///   tests never pollute the Firebase dashboards.
abstract class MonitoringService {
  static bool get _supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  static bool get _collect => _supported && kReleaseMode;

  /// Call once from `main()` after `Firebase.initializeApp`.
  static Future<void> init() async {
    if (!_supported) return;

    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
      _collect,
    );
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(_collect);

    // Errors thrown inside Flutter code (build, layout, gestures...).
    FlutterError.onError = (details) {
      FlutterError.presentError(details); // keep the console output
      if (_collect) {
        unawaited(FirebaseCrashlytics.instance.recordFlutterFatalError(details));
      }
    };

    // Errors that escape async code.
    PlatformDispatcher.instance.onError = (error, stack) {
      if (_collect) {
        unawaited(
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true),
        );
      }
      // When true, Flutter treats the error as handled (it was reported).
      return _collect;
    };
  }

  /// Links reports and events to the signed-in user (pass null on sign-out).
  /// Only the Firebase uid is sent, never the email or name.
  static Future<void> setUser(String? uid) async {
    if (!_collect) return;
    await FirebaseCrashlytics.instance.setUserIdentifier(uid ?? '');
    await FirebaseAnalytics.instance.setUserId(id: uid);
  }

  /// Logs an analytics event, e.g. `MonitoringService.logEvent('book_appointment')`.
  /// Do not put health data or personal information in [parameters].
  static Future<void> logEvent(
    String name, {
    Map<String, Object>? parameters,
  }) async {
    if (!_collect) return;
    await FirebaseAnalytics.instance.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  /// Records an error that was caught and handled but is worth knowing about.
  static Future<void> recordError(
    Object error,
    StackTrace? stack, {
    String? reason,
  }) async {
    if (!_collect) return;
    await FirebaseCrashlytics.instance.recordError(
      error,
      stack,
      reason: reason,
    );
  }
}
