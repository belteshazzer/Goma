import 'package:flutter/material.dart';
// import 'package:goma_notify/screens/add_vehicle/widgets/input_form.dart';
import '../vehicle_model.dart';

class VehicleDetailsCard extends StatelessWidget {
  final Vehicle vehicle;
  final Color darkColor;
  final Color textColor;

  const VehicleDetailsCard({super.key, 
    required this.vehicle,
    required this.darkColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: darkColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Vehicle Details',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            _buildDetailRow('ID', vehicle.id, textColor),
            _buildDetailRow(
                'Owner', vehicle.owner, textColor),
            _buildDetailRow('Make', vehicle.plate_number, textColor),
          ],
        ),
      ),
    );
  }

 Widget _buildDetailRow(String label, String value, Color textColor) {
  return Center(
    child: Container(
      padding: const EdgeInsets.all(8.0),
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    value,
                    style: TextStyle(color: textColor),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
}
