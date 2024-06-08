import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import 'vehicle_data.dart';
import 'vehicle_details_page.dart';

// In vehicle_page.dart
class VehicleListPage extends StatelessWidget {
  final List<Vehicle> vehicles;

  const VehicleListPage({super.key, required this.vehicles});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    bool isDarkMode = theme.brightness == Brightness.dark;

    Color textColor = isDarkMode ? TColors.dark : TColors.light;
    Color cardBGColor = isDarkMode ? TColors.lightContainer : TColors.primary;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Vehicle List',
          style: TextStyle(color: cardBGColor),
        ),
      ),
      body: ListView.builder(
        itemCount: vehicles.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      VehicleDetailsPage(vehicle: vehicles[index]),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Card(
                color: cardBGColor,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.directions_car,color: TColors.primary),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${vehicles[index].id} - ${vehicles[index].description}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: textColor
                                ),
                              ),
                              Text(
                                '${vehicles[index].make} ${vehicles[index].model} (${vehicles[index].year})',
                                style: TextStyle(color: textColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios, color: textColor,),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
