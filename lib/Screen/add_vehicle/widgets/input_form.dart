import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goma/common/bar/bar.dart';
import 'package:iconsax/iconsax.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';

class Vehicle {
  final String chassisNo;
  final String libreNo;
  final String make;
  final String model;
  final int year;

  Vehicle({
    required this.chassisNo,
    required this.libreNo,
    required this.make,
    required this.model,
    required this.year,
  });
}

// Sample data
List<Vehicle> sampleData = [
  Vehicle(chassisNo: '12345', libreNo: 'ABCDE', make: 'Toyota', model: 'Corolla', year: 2020),
  Vehicle(chassisNo: '67890', libreNo: 'FGHIJ', make: 'Honda', model: 'Civic', year: 2021),
  Vehicle(chassisNo: '54321', libreNo: 'KLMNO', make: 'Ford', model: 'Fusion', year: 2019),
  Vehicle(chassisNo: 'a', libreNo: 'a', make: 'Ford', model: 'Fusion', year: 2019),
];


class InputForm extends StatelessWidget {
  const InputForm({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    TextEditingController chassisNoController = TextEditingController();
    TextEditingController libreNoController = TextEditingController();

    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            /// Email
            Container(
              color: const Color(0xFF003A91).withOpacity(0.6),
              child: TextFormField(
                controller: chassisNoController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.direct),
                  labelText: TTexts.chassisNo,
                ),
              ),
            ),

            const SizedBox(
              height: TSizes.spaceBtwInputFields,
            ),

            /// Password
            Container(
              color: const Color(0xFF003A91).withOpacity(0.6),
              child: TextFormField(
                controller: libreNoController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.direct),
                  labelText: TTexts.libreNo,
                ),
              ),
            ),

            const SizedBox(
              height: TSizes.spaceBtwInputFields / 2,
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            // Sign in Button
            SizedBox(
              width: double.infinity,
              child:// Inside the InputForm widget
                ElevatedButton(
                onPressed: () {
                  // Retrieve the text from the controllers
                  String chassisNo = chassisNoController.text;
                  String libreNo = libreNoController.text;

                  // Search for the vehicle based on chassis number and libre number
                  Vehicle? foundVehicle;
                  for (Vehicle vehicle in sampleData) {
                    if (vehicle.chassisNo == chassisNo && vehicle.libreNo == libreNo) {
                      foundVehicle = vehicle;
                      break;
                    }
                  }

                  if (foundVehicle != null) {
                    // Show success snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Vehicle found!",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );

                    // Navigate to the next screen and pass the found vehicle information
                    Get.to(() => const BottomNavBar());
                  } else {
                    // Show snackbar indicating vehicle not found
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Vehicle not found!",
                          style:  TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                        duration:  Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },


                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(const Color(0xFF003A91)),
                ),
                child: const Text(TTexts.addVehicle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
