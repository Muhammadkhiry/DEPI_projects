import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/request_details_mock.dart';
import '../models/request_details_models.dart';
import 'request_details_state.dart';

class RequestDetailsCubit extends Cubit<RequestDetailsState> {
  RequestDetailsCubit() : super(const RequestDetailsState());

  Future<void> load(
    String requestId, {
    RequestPreview preview = RequestPreview.normal,
  }) async {
    emit(
      state.copyWith(status: RequestDetailsStatus.loading, preview: preview),
    );
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      emit(
        state.copyWith(
          status: RequestDetailsStatus.loaded,
          request: RequestDetailsMock.request(preview: preview),
          responses: RequestDetailsMock.responses(preview),
          log: RequestDetailsMock.log(preview),
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: RequestDetailsStatus.failure));
    }
  }

  void debugPreview(RequestPreview preview) =>
      load(state.request?.id ?? '', preview: preview);

  String? acceptResponse(String id) {
    final req = state.request!;
    if (!req.isOpen) return 'This request is no longer open.';
    if (state.committedCount >= req.units) {
      return 'All ${req.units} units are already covered by accepted donors.';
    }
    final r = state.responses.firstWhere((e) => e.id == id);
    _updateResponse(
      id,
      (e) => e.copyWith(
        status: ResponseStatus.accepted,
        note: 'Accepted · awaiting arrival',
      ),
    );
    _addLog(
      StatusLogEntry(
        type: LogType.accepted,
        title: 'Donor Accepted',
        description:
            "Requester accepted ${r.name}'s offer. Donor confirmed arrival time window directly.",
        time: DateTime.now(),
      ),
    );
    return null;
  }

  void declineResponse(String id) {
    final r = state.responses.firstWhere((e) => e.id == id);
    _updateResponse(
      id,
      (e) => e.copyWith(status: ResponseStatus.declined, note: 'Declined'),
    );
    _addLog(
      StatusLogEntry(
        type: LogType.declined,
        title: 'Offer Declined',
        description: 'Requester declined ${r.name}\'s offer.',
        time: DateTime.now(),
      ),
    );
  }

  void markDonated(String id) {
    final req = state.request!;
    final r = state.responses.firstWhere((e) => e.id == id);
    final now = DateTime.now();
    _updateResponse(
      id,
      (e) => e.copyWith(
        status: ResponseStatus.donated,
        note: 'Donation recorded',
        completedAt: now,
      ),
    );

    final secured = req.unitsSecured + 1;
    final fulfilled = secured >= req.units;
    emit(
      state.copyWith(
        request: req.copyWith(
          unitsSecured: secured,
          status: fulfilled ? RequestStatus.fulfilled : null,
        ),
      ),
    );
    _addLog(
      StatusLogEntry(
        type: LogType.donated,
        title: 'Donated (1 Unit Secured)',
        description:
            '${r.name} completed donation intake at the triage desk. Unit cataloged for ${req.ward}.',
        time: now,
      ),
    );
  }

  Future<void> cancelRequest() async {
    emit(state.copyWith(isCancelling: true));

    await Future.delayed(const Duration(milliseconds: 700));
    _addLog(
      StatusLogEntry(
        type: LogType.cancelled,
        title: 'Request Cancelled',
        description:
            'Requester cancelled the request. Committed donors were released.',
        time: DateTime.now(),
      ),
    );
    emit(
      state.copyWith(
        isCancelling: false,
        isCancelled: true,
        request: state.request!.copyWith(status: RequestStatus.cancelled),
      ),
    );
  }

  void _updateResponse(
    String id,
    DonorResponseModel Function(DonorResponseModel) update,
  ) {
    emit(
      state.copyWith(
        responses: [
          for (final r in state.responses) r.id == id ? update(r) : r,
        ],
      ),
    );
  }

  void _addLog(StatusLogEntry entry) =>
      emit(state.copyWith(log: [entry, ...state.log]));
}
