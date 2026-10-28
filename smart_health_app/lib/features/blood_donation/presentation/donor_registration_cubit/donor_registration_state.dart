import '../models/donor_models.dart';

enum DonorRegistrationStatus { initial, submitting, success, failure }

class DonorRegistrationState {
  static const int minAge = 18;
  static const int maxAge = 65;
  static const double minWeightKg = 50;
  static const int intervalDays = 84;
  static const double _kgToLb = 2.20462;

  final int step;
  final String? bloodType;
  final int age;
  final double? weightValue;
  final WeightUnit weightUnit;
  final DateTime? lastDonationDate;
  final bool neverDonated;
  final bool showStep1Errors;

  final bool feelingWell;
  final bool noInvasiveProcedures;
  final bool medicationClear;
  final bool showInFeed;
  final bool allowCalls;
  final bool consentAgreed;
  final bool showStep2Errors;

  final DonorRegistrationStatus status;
  final String? errorMessage;
  final DonorProfileModel? profile;

  const DonorRegistrationState({
    this.step = 1,
    this.bloodType,
    this.age = 25,
    this.weightValue,
    this.weightUnit = WeightUnit.kg,
    this.lastDonationDate,
    this.neverDonated = false,
    this.showStep1Errors = false,
    this.feelingWell = false,
    this.noInvasiveProcedures = false,
    this.medicationClear = false,
    this.showInFeed = true,
    this.allowCalls = true,
    this.consentAgreed = false,
    this.showStep2Errors = false,
    this.status = DonorRegistrationStatus.initial,
    this.errorMessage,
    this.profile,
  });

  bool get isSubmitting => status == DonorRegistrationStatus.submitting;

  double? get weightKg {
    final v = weightValue;
    if (v == null) return null;
    return weightUnit == WeightUnit.kg ? v : v / _kgToLb;
  }

  bool get canRegister =>
      feelingWell && noInvasiveProcedures && medicationClear && consentAgreed;

  EligibilityResult? get eligibility {
    final kg = weightKg;
    if (bloodType == null || kg == null) return null;
    if (!neverDonated && lastDonationDate == null) return null;

    if (age < minAge || age > maxAge) {
      return const EligibilityResult(
        status: EligibilityStatus.ineligible,
        title: 'Age requirement not met',
        message: 'Donors must be between 18 and 65 years old.',
      );
    }
    if (kg < minWeightKg) {
      return const EligibilityResult(
        status: EligibilityStatus.ineligible,
        title: 'Weight below safety threshold',
        message: 'A minimum body weight of 50 kg (110 lbs) is required to protect your blood volume safety.',
      );
    }
    if (!neverDonated) {
      final days = DateTime.now().difference(lastDonationDate!).inDays;
      if (days < intervalDays) {
        final remaining = intervalDays - days;
        return EligibilityResult(
          status: EligibilityStatus.waitPeriod,
          title: 'Please wait $remaining more day${remaining == 1 ? '' : 's'}',
          message: 'A minimum of 84 days (12 weeks) is needed between whole blood donations so your iron stores can recover.',
          nextEligibleDate: lastDonationDate!.add(
            const Duration(days: intervalDays),
          ),
        );
      }
    }
    return EligibilityResult(
      status: EligibilityStatus.eligible,
      title: "You're eligible to donate!",
      message: neverDonated
          ? 'Welcome, first-time donor! Your weight meets the clinical safety threshold (50+ kg). Eligibility is calculated securely on this device.'
          : 'Your last donation was over 12 weeks ago and your weight meets the clinical safety threshold (50+ kg). Eligibility is calculated securely on this device.',
    );
  }

  DonorRegistrationState copyWith({
    int? step,
    String? bloodType,
    int? age,
    double? weightValue,
    WeightUnit? weightUnit,
    DateTime? lastDonationDate,
    bool clearLastDonation = false,
    bool? neverDonated,
    bool? showStep1Errors,
    bool? feelingWell,
    bool? noInvasiveProcedures,
    bool? medicationClear,
    bool? showInFeed,
    bool? allowCalls,
    bool? consentAgreed,
    bool? showStep2Errors,
    DonorRegistrationStatus? status,
    String? errorMessage,
    DonorProfileModel? profile,
    bool clearWeight = false,
  }) {
    return DonorRegistrationState(
      step: step ?? this.step,
      bloodType: bloodType ?? this.bloodType,
      age: age ?? this.age,
      weightValue: clearWeight ? null : (weightValue ?? this.weightValue),
      weightUnit: weightUnit ?? this.weightUnit,
      lastDonationDate: clearLastDonation
          ? null
          : (lastDonationDate ?? this.lastDonationDate),
      neverDonated: neverDonated ?? this.neverDonated,
      showStep1Errors: showStep1Errors ?? this.showStep1Errors,
      feelingWell: feelingWell ?? this.feelingWell,
      noInvasiveProcedures: noInvasiveProcedures ?? this.noInvasiveProcedures,
      medicationClear: medicationClear ?? this.medicationClear,
      showInFeed: showInFeed ?? this.showInFeed,
      allowCalls: allowCalls ?? this.allowCalls,
      consentAgreed: consentAgreed ?? this.consentAgreed,
      showStep2Errors: showStep2Errors ?? this.showStep2Errors,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      profile: profile ?? this.profile,
    );
  }
}
