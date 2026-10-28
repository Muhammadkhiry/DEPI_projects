import '../models/blood_request_model.dart';

enum RequestBloodStatus { initial, submitting, success, failure }

class RequestBloodState {
  final int step;
  final String? bloodType;
  final int units;
  final UrgencyLevel urgency;
  final String patientInitials;
  final String hospitalName;
  final String ward;
  final String phone;
  final String notes;
  final bool showStep1Errors;
  final RequestBloodStatus status;
  final String? errorMessage;
  final BloodRequestModel? request;

  const RequestBloodState({
    this.step = 1,
    this.bloodType,
    this.units = 2,
    this.urgency = UrgencyLevel.critical,
    this.patientInitials = '',
    this.hospitalName = '',
    this.ward = '',
    this.phone = '',
    this.notes = '',
    this.showStep1Errors = false,
    this.status = RequestBloodStatus.initial,
    this.errorMessage,
    this.request,
  });

  bool get isStep1Valid => bloodType != null;
  bool get isSubmitting => status == RequestBloodStatus.submitting;

  RequestBloodState copyWith({
    int? step,
    String? bloodType,
    int? units,
    UrgencyLevel? urgency,
    String? patientInitials,
    String? hospitalName,
    String? ward,
    String? phone,
    String? notes,
    bool? showStep1Errors,
    RequestBloodStatus? status,
    String? errorMessage,
    BloodRequestModel? request,
  }) {
    return RequestBloodState(
      step: step ?? this.step,
      bloodType: bloodType ?? this.bloodType,
      units: units ?? this.units,
      urgency: urgency ?? this.urgency,
      patientInitials: patientInitials ?? this.patientInitials,
      hospitalName: hospitalName ?? this.hospitalName,
      ward: ward ?? this.ward,
      phone: phone ?? this.phone,
      notes: notes ?? this.notes,
      showStep1Errors: showStep1Errors ?? this.showStep1Errors,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      request: request ?? this.request,
    );
  }
}
