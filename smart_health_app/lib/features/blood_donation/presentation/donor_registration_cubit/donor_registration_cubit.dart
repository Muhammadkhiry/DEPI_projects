import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/donor_models.dart';
import 'donor_registration_state.dart';

class DonorRegistrationCubit extends Cubit<DonorRegistrationState> {
  final String donorName;

  DonorRegistrationCubit({this.donorName = 'Sarah Jenkins'})
    : super(const DonorRegistrationState());

  void selectBloodType(String type) =>
      emit(state.copyWith(bloodType: type, showStep1Errors: false));

  void setAge(int age) => emit(state.copyWith(age: age.clamp(10, 99)));
  void incrementAge() => setAge(state.age + 1);
  void decrementAge() => setAge(state.age - 1);

  void setWeightText(String text) {
    final parsed = double.tryParse(text.trim());
    if (parsed == null || parsed <= 0) {
      emit(state.copyWith(clearWeight: true));
    } else {
      emit(state.copyWith(weightValue: parsed));
    }
  }

  void setWeightUnit(WeightUnit unit) {
    if (unit == state.weightUnit) return;
    final v = state.weightValue;
    double? converted;
    if (v != null) {
      final raw = unit == WeightUnit.lb ? v * 2.20462 : v / 2.20462;
      converted = (raw * 10).round() / 10;
    }
    emit(
      state.copyWith(
        weightUnit: unit,
        weightValue: converted,
        clearWeight: converted == null,
      ),
    );
  }

  void setLastDonation(DateTime date) =>
      emit(state.copyWith(lastDonationDate: date, neverDonated: false));

  void setNeverDonated(bool value) =>
      emit(state.copyWith(neverDonated: value, clearLastDonation: value));

  String? goToPreferences() {
    final result = state.eligibility;
    if (result == null) {
      emit(state.copyWith(showStep1Errors: true));
      return 'Please complete your eligibility assessment first.';
    }
    if (result.status != EligibilityStatus.eligible) {
      emit(state.copyWith(showStep1Errors: true));
      return 'You are not eligible to donate right now.';
    }
    emit(state.copyWith(step: 2));
    return null;
  }

  void previousStep() {
    if (state.step > 1) emit(state.copyWith(step: state.step - 1));
  }

  void setFeelingWell(bool v) => emit(state.copyWith(feelingWell: v));
  void setNoInvasive(bool v) => emit(state.copyWith(noInvasiveProcedures: v));
  void setMedicationClear(bool v) => emit(state.copyWith(medicationClear: v));
  void setShowInFeed(bool v) => emit(state.copyWith(showInFeed: v));
  void setAllowCalls(bool v) => emit(state.copyWith(allowCalls: v));
  void setConsent(bool v) => emit(state.copyWith(consentAgreed: v));

  Future<void> register() async {
    if (!state.canRegister) {
      emit(state.copyWith(showStep2Errors: true));
      return;
    }
    emit(state.copyWith(status: DonorRegistrationStatus.submitting));
    try {
      await Future.delayed(const Duration(milliseconds: 900));

      final profile = DonorProfileModel(
        donorId: '#DBR-${80000 + Random().nextInt(9999)}',
        name: donorName,
        bloodType: state.bloodType!,
        showInFeed: state.showInFeed,
        allowCalls: state.allowCalls,
      );
      emit(
        state.copyWith(
          status: DonorRegistrationStatus.success,
          profile: profile,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: DonorRegistrationStatus.failure,
          errorMessage: 'Registration failed. Please try again.',
        ),
      );
    }
  }
}
