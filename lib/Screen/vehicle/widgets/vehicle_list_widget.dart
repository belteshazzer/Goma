import 'package:flutter/material.dart';
import 'package:goma/Screen/vehicle/vehicle_model.dart';
import 'package:goma/utils/helpers/helper_functions.dart';

import '../../../utils/constants/colors.dart';

class VehicleListWidget extends StatelessWidget {
  final List<Vehicle> vehicles;
  final bool isLoading;
  final String? error;
  final screen;

  const VehicleListWidget({
    super.key,
    required this.screen,
    required this.vehicles,
    required this.isLoading,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    bool isDarkMode = theme.brightness == Brightness.dark;

    Color textColor = isDarkMode ? TColors.light : TColors.dark;
    Color cardBGColor = isDarkMode ? TColors.black : TColors.primary;

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : error != null
            ? Center(child: Text('Error: $error'))
            : vehicles.isEmpty
                ? const Center(child: Text('No vehicles found'))
                : ListView.builder(
                    itemCount: vehicles.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          THelperFunctions.navigateToScreen(context,screen); //VehicleDetail(vehicle: vehicles[index]
                          
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
                                      const Icon(Icons.directions_car, color: TColors.light),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Plate no_: ${vehicles[index].platenumber}',
                                            style: TextStyle(color: textColor),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Icon(Icons.arrow_forward_ios, color: textColor),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
  }
}
