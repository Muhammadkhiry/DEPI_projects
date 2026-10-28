import '../models/request_details_mock.dart';
import '../models/request_details_models.dart';

enum RequestDetailsStatus { loading, loaded, failure }

class RequestDetailsState {
  final RequestDetailsStatus status;
  final BloodRequestDetails? request;
  final List<DonorResponseModel> responses;
  final List<StatusLogEntry> log;
  final RequestPreview preview;
  final bool isCancelling;
  final bool isCancelled;

  const RequestDetailsState({
    this.status = RequestDetailsStatus.loading,
    this.request,
    this.responses = const [],
    this.log = const [],
    this.preview = RequestPreview.normal,
    this.isCancelling = false,
    this.isCancelled = false,
  });

  int get committedCount => responses
      .where(
        (r) =>
            r.status == ResponseStatus.accepted ||
            r.status == ResponseStatus.donated,
      )
      .length;

  RequestDetailsState copyWith({
    RequestDetailsStatus? status,
    BloodRequestDetails? request,
    List<DonorResponseModel>? responses,
    List<StatusLogEntry>? log,
    RequestPreview? preview,
    bool? isCancelling,
    bool? isCancelled,
  }) {
    return RequestDetailsState(
      status: status ?? this.status,
      request: request ?? this.request,
      responses: responses ?? this.responses,
      log: log ?? this.log,
      preview: preview ?? this.preview,
      isCancelling: isCancelling ?? this.isCancelling,
      isCancelled: isCancelled ?? this.isCancelled,
    );
  }
}
