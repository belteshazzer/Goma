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
}


List<Vehicle> vehiclesData = [
  Vehicle(
    id: '1',
    description: 'SUV',
    make: 'Toyota',
    model: 'RAV4',
    year: 2022,
  ),
  Vehicle(
    id: '2',
    description: 'Sedan',
    make: 'Honda',
    model: 'Civic',
    year: 2021,
  ),
  Vehicle(
    id: '3',
    description: 'Truck',
    make: 'Ford',
    model: 'F-150',
    year: 2020,
  ),
];
