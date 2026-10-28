enum WeightUnit { kg, lb }

enum EligibilityStatus { eligible, waitPeriod, ineligible }

class EligibilityResult {
  final EligibilityStatus status;
  final String title;
  final String message;
  final DateTime? nextEligibleDate;

  const EligibilityResult({
    required this.status,
    required this.title,
    required this.message,
    this.nextEligibleDate,
  });
}

String bloodTypeFullName(String type) =>
    type.endsWith('+') ? '$type Positive' : '$type Negative';

bool isUniversalRedCellDonor(String type) => type == 'O-';

class DonorProfileModel {
  final String donorId;
  final String name;
  final String bloodType;
  final bool showInFeed;
  final bool allowCalls;
  final DateTime? nextEligibleDate;

  const DonorProfileModel({
    required this.donorId,
    required this.name,
    required this.bloodType,
    required this.showInFeed,
    required this.allowCalls,
    this.nextEligibleDate,
  });

  String get firstName => name.trim().split(' ').first;
}

enum DonationStatus { confirmed, selfReported }

class DonationRecordModel {
  final String id;
  final DateTime date;
  final String location;
  final String type;
  final int volumeMl;
  final DonationStatus status;
  final String note;

  const DonationRecordModel({
    required this.id,
    required this.date,
    required this.location,
    required this.volumeMl,
    required this.status,
    required this.note,
    this.type = 'Whole Blood',
  });
}
