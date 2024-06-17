class NotificationItem {
  final String id;
  final String messageContent;
  final String notificationType;
  final String priorityLevel;
  bool seen;
  final Document document;

  NotificationItem({
    required this.id,
    required this.messageContent,
    required this.notificationType,
    required this.priorityLevel,
    required this.seen,
    required this.document,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] ?? '',
      messageContent: json['message_content'] ?? '',
      notificationType: json['notification_type'] ?? '',
      priorityLevel: json['priority_level'] ?? '',
      seen: json['seen'] == true,
      document: Document.fromJson(json['document'] ?? {}),
    );
  }
}

class Document {
  final String id;
  final String documentType;
  final bool renewalStatus;
  final String renewalDate;
  final String expiryDate;
  final Vehicle vehicle;

  Document({
    required this.id,
    required this.documentType,
    required this.renewalStatus,
    required this.renewalDate,
    required this.expiryDate,
    required this.vehicle,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'] ?? '',
      documentType: json['document_type'] ?? '',
      renewalStatus: json['renewal_status'] == true,
      renewalDate: json['renewal_date'] ?? '',
      expiryDate: json['expiry_date'] ?? '',
      vehicle: Vehicle.fromJson(json['vehicle'] ?? {}),
    );
  }
}

class Vehicle {
  final String id;
  final String chassisNumber;
  final String plateNumber;
  final Owner owner;

  Vehicle({
    required this.id,
    required this.chassisNumber,
    required this.plateNumber,
    required this.owner,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] ?? '',
      chassisNumber: json['chassis_number'] ?? '',
      plateNumber: json['plate_number'] ?? '',
      owner: Owner.fromJson(json['owner'] ?? {}),
    );
  }
}

class Owner {
  final String username;
  final String email;
  final String firstName;
  final String? middleName;
  final String lastName;

  Owner({
    required this.username,
    required this.email,
    required this.firstName,
    this.middleName,
    required this.lastName,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      middleName: json['middle_name'],
      lastName: json['last_name'] ?? '',
    );
  }
}
