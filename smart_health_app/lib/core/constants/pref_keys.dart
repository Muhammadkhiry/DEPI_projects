/// Keys used with CacheHelper (SharedPreferences).
///
/// The notification keys are read by NotificationService (Dev2, task 2.5) to
/// decide which local notifications to schedule.
abstract class PrefKeys {
  static const String isOnboardingSeen = 'isOnboardingSeen';

  static const String notifAppointments = 'notif_appointments';
  static const String notifBloodRequests = 'notif_blood_requests';
  static const String notifRecordSaved = 'notif_record_saved';

  /// One of: '30 mins before', '1 hour before', '2 hours before'.
  static const String notifSchedule = 'notif_schedule';
}
