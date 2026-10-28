import 'blood_request_model.dart';
import 'request_details_models.dart';

enum RequestPreview { normal, noResponses, expired }

abstract class RequestDetailsMock {
  static DateTime _today(int h, int m) {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day, h, m);
  }

  static BloodRequestDetails request({
    RequestPreview preview = RequestPreview.normal,
  }) {
    final now = DateTime.now();
    final expired = preview == RequestPreview.expired;
    return BloodRequestDetails(
      id: '#REQ-90482',
      bloodType: 'O-',
      units: 2,
      unitsSecured: preview == RequestPreview.noResponses ? 0 : 1,
      urgency: UrgencyLevel.critical,
      hospitalName: 'St. Jude General Hospital',
      ward: 'ICU Wing B, Room 314',
      phone: '+20 (010) 9876-5432',
      patientInitials: 'S. J.',
      note: 'Emergency trauma prep. Scheduled for acute surgery. Please present at main blood bank triage desk.',
      postedAt: expired
          ? now.subtract(const Duration(hours: 25))
          : now.subtract(const Duration(minutes: 20)),
      expiresAt: expired
          ? now.subtract(const Duration(hours: 1))
          : now.add(const Duration(hours: 23, minutes: 40)),
      status: expired ? RequestStatus.expired : RequestStatus.active,
    );
  }

  static List<DonorResponseModel> responses(RequestPreview preview) {
    if (preview == RequestPreview.noResponses) return [];
    return [
      DonorResponseModel(
        id: 'r1',
        name: 'Ahmed K.',
        bloodType: 'O-',
        status: ResponseStatus.accepted,
        note: 'En route to triage',
        offeredAt: _today(9, 42),
      ),
      DonorResponseModel(
        id: 'r2',
        name: 'Sarah J.',
        bloodType: 'O-',
        status: ResponseStatus.offered,
        note: 'Available immediately',
        offeredAt: _today(9, 42),
      ),
      DonorResponseModel(
        id: 'r3',
        name: 'Mahmoud T.',
        bloodType: 'O-',
        status: ResponseStatus.donated,
        note: 'Donation recorded',
        offeredAt: _today(9, 50),
        completedAt: _today(10, 15),
      ),
    ];
  }

  static List<StatusLogEntry> log(RequestPreview preview) {
    if (preview == RequestPreview.noResponses) {
      return [
        StatusLogEntry(
          type: LogType.posted,
          title: 'Request Posted',
          description: 'Request #REQ-90482 published to Smart Health public bulletin by authorized family requester.',
          time: _today(9, 30),
        ),
      ];
    }
    return [
      StatusLogEntry(
        type: LogType.donated,
        title: 'Donated (1 Unit Secured)',
        description: 'Mahmoud T. completed donation intake at St. Jude triage desk. Unit cataloged for ICU Room 314.',
        time: _today(10, 15),
      ),
      StatusLogEntry(
        type: LogType.accepted,
        title: 'Donor Accepted',
        description: "Requester accepted Ahmed K.'s offer. Donor confirmed arrival time window directly.",
        time: _today(9, 55),
      ),
      StatusLogEntry(
        type: LogType.offered,
        title: 'Donor Offered',
        description: 'Sarah J. and Ahmed K. offered to donate in response to high-priority alert broadcast.',
        time: _today(9, 42),
      ),
      StatusLogEntry(
        type: LogType.posted,
        title: 'Request Posted',
        description: 'Request #REQ-90482 published to Smart Health public bulletin by authorized family requester.',
        time: _today(9, 30),
      ),
    ];
  }
}
