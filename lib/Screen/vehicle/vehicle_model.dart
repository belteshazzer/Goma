class Vehicle {
  final String id;
  final String plate_number;
  final String chassis_number;
  final String owner;

  Vehicle({
    required this.id,
    required this.plate_number,
    required this.chassis_number,
    required this.owner,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      chassis_number: json['description'],
      plate_number: json['make'],
      owner: json['model'],
    );
  }
}
