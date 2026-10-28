import '../models/donor_models.dart';

enum DonationHistoryStatus { loading, loaded, failure }

class DonationHistoryState {
  static const int intervalDays = 84;

  final DonationHistoryStatus status;
  final String donorName;
  final String bloodType;
  final List<DonationRecordModel> records; // newest first

  const DonationHistoryState({
    this.status = DonationHistoryStatus.loading,
    this.donorName = '',
    this.bloodType = 'O-',
    this.records = const [],
  });

  int get totalDonations => records.length;
  int get totalMl => records.fold(0, (sum, r) => sum + r.volumeMl);

  int get livesImpacted => totalDonations * 3;

  DateTime? get lastDonation => records.isEmpty ? null : records.first.date;

  DateTime? get nextEligibleDate =>
      lastDonation?.add(const Duration(days: intervalDays));

  int get daysUntilEligible {
    final next = nextEligibleDate;
    if (next == null) return 0;
    return next.difference(DateTime.now()).inDays + 1;
  }

  String get initials {
    final parts = donorName.trim().split(' ').where((p) => p.isNotEmpty);
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }

  DonationHistoryState copyWith({
    DonationHistoryStatus? status,
    String? donorName,
    String? bloodType,
    List<DonationRecordModel>? records,
  }) {
    return DonationHistoryState(
      status: status ?? this.status,
      donorName: donorName ?? this.donorName,
      bloodType: bloodType ?? this.bloodType,
      records: records ?? this.records,
    );
  }
}
