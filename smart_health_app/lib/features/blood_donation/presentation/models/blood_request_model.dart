enum UrgencyLevel { critical, urgent, scheduled }

extension UrgencyLevelX on UrgencyLevel {
  String get title => switch (this) {
    UrgencyLevel.critical => 'Critical',
    UrgencyLevel.urgent => 'Urgent',
    UrgencyLevel.scheduled => 'Scheduled',
  };

  String get badge => switch (this) {
    UrgencyLevel.critical => 'Needed within hours',
    UrgencyLevel.urgent => 'Within 12 hours',
    UrgencyLevel.scheduled => 'Planned (24-48h)',
  };

  String get description => switch (this) {
    UrgencyLevel.critical => 'Immediate trauma, emergency active hemorrhage, or acute intraoperative collapse.',
    UrgencyLevel.urgent => 'Intensive care stabilization, secondary oncology deficit, or scheduled procedure today.',
    UrgencyLevel.scheduled => 'Advance elective surgery prep, booked orthopedics, or routine chronic transfusion.',
  };
}

class BloodRequestModel {
  final String requestId;
  final String bloodType;
  final int units;
  final UrgencyLevel urgency;
  final String patientInitials;
  final String hospitalName;
  final String ward;
  final String phone;
  final String notes;

  const BloodRequestModel({
    required this.requestId,
    required this.bloodType,
    required this.units,
    required this.urgency,
    required this.patientInitials,
    required this.hospitalName,
    required this.ward,
    required this.phone,
    required this.notes,
  });
}
