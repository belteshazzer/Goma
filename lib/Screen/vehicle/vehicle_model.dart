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
    required this.middleName,
    required this.lastName,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      username: json['username'],
      email: json['email'],
      firstName: json['first_name'],
      middleName: json['middle_name'],
      lastName: json['last_name'],
    );
  }
}

class Vehicle {
  final String id;
  final String plateNumber;
  final String chassisNumber;
  final Owner owner;
  final String uniqueId;

  Vehicle({
    required this.id,
    required this.plateNumber,
    required this.chassisNumber,
    required this.owner,
    required this.uniqueId,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    // Debug the JSON map for each vehicle
    print('Vehicle JSON map: $json');

    return Vehicle(
      id: json['id'] as String? ?? '',
      chassisNumber: json['chassis_number'] as String? ?? '',
      plateNumber: json['plate_number'] as String? ?? '',
      owner: Owner.fromJson(json['owner']),
      uniqueId: json['unique_id'] as String? ?? '',
    );
  }
}
