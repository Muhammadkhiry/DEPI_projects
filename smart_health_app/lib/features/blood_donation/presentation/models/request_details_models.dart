import 'blood_request_model.dart'; // UrgencyLevel (from the Request Blood package)

enum RequestStatus { active, fulfilled, expired, cancelled }

class RequestDetailsArgs {
  final String requestId;

  final bool isOwner;

  const RequestDetailsArgs({required this.requestId, required this.isOwner});
}

class BloodRequestDetails {
  final String id;
  final String bloodType;
  final int units;
  final int unitsSecured;
  final UrgencyLevel urgency;
  final String productName;
  final String department;
  final String hospitalName;
  final String ward;
  final String triagePoint;
  final String phone;
  final String patientInitials;
  final String careArea;
  final String note;
  final DateTime postedAt;
  final DateTime expiresAt;
  final RequestStatus status;

  const BloodRequestDetails({
    required this.id,
    required this.bloodType,
    required this.units,
    required this.unitsSecured,
    required this.urgency,
    required this.hospitalName,
    required this.ward,
    required this.phone,
    required this.patientInitials,
    required this.postedAt,
    required this.expiresAt,
    this.productName = 'Whole Blood Needed',
    this.department = 'Adult Transfusion Unit',
    this.triagePoint = 'Donor Triage Counter',
    this.careArea = 'Emergency Room',
    this.note = '',
    this.status = RequestStatus.active,
  });

  double get progress => units == 0 ? 0 : (unitsSecured / units).clamp(0, 1);
  int get percent => (progress * 100).round();

  bool get isExpired =>
      status == RequestStatus.expired ||
      (status == RequestStatus.active && DateTime.now().isAfter(expiresAt));

  bool get isOpen => status == RequestStatus.active && !isExpired;

  BloodRequestDetails copyWith({int? unitsSecured, RequestStatus? status}) {
    return BloodRequestDetails(
      id: id,
      bloodType: bloodType,
      units: units,
      unitsSecured: unitsSecured ?? this.unitsSecured,
      urgency: urgency,
      hospitalName: hospitalName,
      ward: ward,
      phone: phone,
      patientInitials: patientInitials,
      postedAt: postedAt,
      expiresAt: expiresAt,
      productName: productName,
      department: department,
      triagePoint: triagePoint,
      careArea: careArea,
      note: note,
      status: status ?? this.status,
    );
  }
}

enum ResponseStatus { offered, accepted, donated, declined }

class DonorResponseModel {
  final String id;
  final String name;
  final bool isVerified;
  final String bloodType;
  final ResponseStatus status;
  final String note;
  final DateTime offeredAt;
  final DateTime? completedAt;

  const DonorResponseModel({
    required this.id,
    required this.name,
    required this.bloodType,
    required this.status,
    required this.note,
    required this.offeredAt,
    this.isVerified = true,
    this.completedAt,
  });

  bool get isUniversal => bloodType == 'O-';

  String get initials {
    final parts = name.replaceAll('.', '').trim().split(' ');
    return parts.take(2).map((p) => p.isEmpty ? '' : p[0].toUpperCase()).join();
  }

  DonorResponseModel copyWith({
    ResponseStatus? status,
    String? note,
    DateTime? completedAt,
  }) {
    return DonorResponseModel(
      id: id,
      name: name,
      bloodType: bloodType,
      isVerified: isVerified,
      offeredAt: offeredAt,
      status: status ?? this.status,
      note: note ?? this.note,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

enum LogType { posted, offered, accepted, donated, declined, cancelled }

class StatusLogEntry {
  final LogType type;
  final String title;
  final String description;
  final DateTime time;

  const StatusLogEntry({
    required this.type,
    required this.title,
    required this.description,
    required this.time,
  });
}

bool isCompatibleDonor({required String donor, required String recipient}) {
  const table = {
    'O-': ['O-', 'O+', 'A-', 'A+', 'B-', 'B+', 'AB-', 'AB+'],
    'O+': ['O+', 'A+', 'B+', 'AB+'],
    'A-': ['A-', 'A+', 'AB-', 'AB+'],
    'A+': ['A+', 'AB+'],
    'B-': ['B-', 'B+', 'AB-', 'AB+'],
    'B+': ['B+', 'AB+'],
    'AB-': ['AB-', 'AB+'],
    'AB+': ['AB+'],
  };
  return table[donor]?.contains(recipient) ?? false;
}
