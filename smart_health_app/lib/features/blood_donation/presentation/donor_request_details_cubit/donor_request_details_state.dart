import '../models/request_details_models.dart';

enum DonorRequestStatus { loading, loaded, failure }

enum DonorOfferStatus { none, sent, accepted }

class DonorRequestDetailsState {
  final DonorRequestStatus status;
  final BloodRequestDetails? request;
  final DonorOfferStatus offer;
  final String donorBloodType;
  final bool isSubmitting;

  const DonorRequestDetailsState({
    this.status = DonorRequestStatus.loading,
    this.request,
    this.offer = DonorOfferStatus.none,
    this.donorBloodType = 'O-',
    this.isSubmitting = false,
  });

  bool get matchesProfile =>
      request != null &&
      isCompatibleDonor(donor: donorBloodType, recipient: request!.bloodType);

  DonorRequestDetailsState copyWith({
    DonorRequestStatus? status,
    BloodRequestDetails? request,
    DonorOfferStatus? offer,
    String? donorBloodType,
    bool? isSubmitting,
  }) {
    return DonorRequestDetailsState(
      status: status ?? this.status,
      request: request ?? this.request,
      offer: offer ?? this.offer,
      donorBloodType: donorBloodType ?? this.donorBloodType,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}
