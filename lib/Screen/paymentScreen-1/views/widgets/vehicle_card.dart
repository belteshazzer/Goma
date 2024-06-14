import 'package:flutter/material.dart';
import '../vehicle_data.dart';

class VehicleCard extends StatelessWidget {
final Vehicle vehicle;

const VehicleCard({super.key, required this.vehicle});


@override
Widget build(BuildContext context){
  return Card(
    color: Colors.blue,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    elevation:20,
    child: ListTile(
      title: Text(vehicle.model),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('plate number: ${vehicle.plateNumber}'),
          Text('chassis number: ${vehicle.chassisNo}'),
        ],
      ),
    )
  );
}
}