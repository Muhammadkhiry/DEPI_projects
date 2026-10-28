import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/blood_request_model.dart';
import 'request_blood_state.dart';

class RequestBloodCubit extends Cubit<RequestBloodState> {
  RequestBloodCubit() : super(const RequestBloodState());

  static const int minUnits = 1;
  static const int maxUnits = 10;

  // Step 1
  void selectBloodType(String type) =>
      emit(state.copyWith(bloodType: type, showStep1Errors: false));

  void setUnits(int units) =>
      emit(state.copyWith(units: units.clamp(minUnits, maxUnits)));

  void incrementUnits() => setUnits(state.units + 1);
  void decrementUnits() => setUnits(state.units - 1);

  void selectUrgency(UrgencyLevel level) =>
      emit(state.copyWith(urgency: level));

  bool goToStep2() {
    if (!state.isStep1Valid) {
      emit(state.copyWith(showStep1Errors: true));
      return false;
    }
    emit(state.copyWith(step: 2));
    return true;
  }

  void previousStep() {
    if (state.step > 1) emit(state.copyWith(step: state.step - 1));
  }

  //Step 2
  void patientInitialsChanged(String v) =>
      emit(state.copyWith(patientInitials: v));
  void hospitalChanged(String v) => emit(state.copyWith(hospitalName: v));
  void wardChanged(String v) => emit(state.copyWith(ward: v));
  void phoneChanged(String v) => emit(state.copyWith(phone: v));
  void notesChanged(String v) => emit(state.copyWith(notes: v));

  Future<void> submit() async {
    emit(state.copyWith(status: RequestBloodStatus.submitting));
    try {
      await Future.delayed(const Duration(milliseconds: 900));

      final request = BloodRequestModel(
        requestId: '#REQ-${90000 + Random().nextInt(9999)}',
        bloodType: state.bloodType!,
        units: state.units,
        urgency: state.urgency,
        patientInitials: state.patientInitials.trim().toUpperCase(),
        hospitalName: state.hospitalName.trim(),
        ward: state.ward.trim(),
        phone: state.phone.trim(),
        notes: state.notes.trim(),
      );
      emit(
        state.copyWith(status: RequestBloodStatus.success, request: request),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RequestBloodStatus.failure,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );
    }
  }
}
