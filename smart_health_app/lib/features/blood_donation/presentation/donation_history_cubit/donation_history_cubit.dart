import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/donor_models.dart';
import 'donation_history_state.dart';

class DonationHistoryCubit extends Cubit<DonationHistoryState> {
  DonationHistoryCubit()
    : super(
        const DonationHistoryState(donorName: 'Sarah Jenkins', bloodType: 'O-'),
      );

  Future<void> load() async {
    emit(state.copyWith(status: DonationHistoryStatus.loading));
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      emit(
        state.copyWith(
          status: DonationHistoryStatus.loaded,
          records: _sorted(_mockRecords),
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: DonationHistoryStatus.failure));
    }
  }

  void addSelfReported({required DateTime date, required String location}) {
    final record = DonationRecordModel(
      id: 'local-${DateTime.now().microsecondsSinceEpoch}',
      date: date,
      location: location.trim().isEmpty
          ? 'Unspecified location'
          : location.trim(),
      volumeMl: 450,
      status: DonationStatus.selfReported,
      note: 'Manually entered by ${state.donorName} · Pending facility audit',
    );

    emit(state.copyWith(records: _sorted([...state.records, record])));
  }

  List<DonationRecordModel> _sorted(List<DonationRecordModel> list) =>
      [...list]..sort((a, b) => b.date.compareTo(a.date));

  static final List<DonationRecordModel> _mockRecords = [
    DonationRecordModel(
      id: '1',
      date: DateTime(2024, 8, 20),
      location: 'St. Jude General Hospital · Blood Bank',
      volumeMl: 450,
      status: DonationStatus.confirmed,
      note: 'Logged via Smart Health emergency request #REQ-78219',
    ),
    DonationRecordModel(
      id: '2',
      date: DateTime(2024, 3, 15),
      location: 'Central Regional Blood Bank',
      volumeMl: 450,
      status: DonationStatus.confirmed,
      note: 'Direct center walk-in · Biometric donor ID verified',
    ),
    DonationRecordModel(
      id: '3',
      date: DateTime(2023, 11, 2),
      location: 'Red Crescent Mobile Blood Drive',
      volumeMl: 450,
      status: DonationStatus.selfReported,
      note: 'Manually entered by Sarah Jenkins · Pending facility audit',
    ),
  ];
}
