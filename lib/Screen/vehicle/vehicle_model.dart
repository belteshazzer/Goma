class Vehicle {
  final String id;
  final String description;
  final String make;
  final String model;
  final int year;

  Vehicle({
    required this.id,
    required this.description,
    required this.make,
    required this.model,
    required this.year,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      description: json['description'],
      make: json['make'],
      model: json['model'],
      year: json['year'],
    );
  }
}
