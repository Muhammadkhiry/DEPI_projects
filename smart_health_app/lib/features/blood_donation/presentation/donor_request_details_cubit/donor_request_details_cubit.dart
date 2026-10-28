import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/request_details_mock.dart';
import 'donor_request_details_state.dart';

class DonorRequestDetailsCubit extends Cubit<DonorRequestDetailsState> {
  DonorRequestDetailsCubit({String donorBloodType = 'O-'})
    : super(DonorRequestDetailsState(donorBloodType: donorBloodType));

  Future<void> load(String requestId) async {
    emit(state.copyWith(status: DonorRequestStatus.loading));
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      emit(
        state.copyWith(
          status: DonorRequestStatus.loaded,
          request: RequestDetailsMock.request(),
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: DonorRequestStatus.failure));
    }
  }

  Future<String?> sendOffer() async {
    final req = state.request;
    if (req == null) return 'Request not loaded yet.';
    if (!req.isOpen) return 'This request is no longer open.';
    if (!state.matchesProfile) {
      return 'Your blood type (${state.donorBloodType}) is not compatible with this request.';
    }
    emit(state.copyWith(isSubmitting: true));

    await Future.delayed(const Duration(milliseconds: 700));
    emit(state.copyWith(isSubmitting: false, offer: DonorOfferStatus.sent));
    return null;
  }

  Future<void> withdrawOffer() async {
    emit(state.copyWith(isSubmitting: true));

    await Future.delayed(const Duration(milliseconds: 500));
    emit(state.copyWith(isSubmitting: false, offer: DonorOfferStatus.none));
  }

  void debugSetOffer(DonorOfferStatus offer) =>
      emit(state.copyWith(offer: offer));
}
