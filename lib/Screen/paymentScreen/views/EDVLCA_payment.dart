// import 'package:flutter/material.dart';
// import 'vehicle_data.dart';
// import 'package:goma_notify/utils/helpers/helper_functions.dart';
// import 'package:goma_notify/utils/theme/widget_themes/text_theme.dart';
// import 'widgets/vehicle_card.dart';
// import 'widgets/last_payment_item.dart';

// class EDVLCAPaymentPage extends StatelessWidget {
//   const EDVLCAPaymentPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final tTextTheme = THelperFunctions.isDarkMode(context)
//         ? TTextTheme.darkTextTheme
//         : TTextTheme.lightTextTheme;

//     // Get dummy vehicles
//     final vehicles = getDummyVehicles();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'EDVLCA payment',
//           style: tTextTheme.headlineLarge,
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text('Select a vehicle to continue'),
//             const Text(
//                 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.'),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: vehicles.length,
//                 itemBuilder: (context, index) {
//                   return VehicleCard(vehicle: vehicles[index]);
//                 },
//               ),
//             ),
//             ClipPath(
//               clipper: CurvedClipper(),
//               child: Container(
//                 height: 40,
//                 color: Colors.grey[850],
//               ),
//             ),
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16.0),
//               child: Text(
//                 'Last EDVLCA Payments',
//                 style: TextStyle(color: Colors.white, fontSize: 18),
//               ),
//             ),
//             Expanded(
//               child: ListView(
//                 children: [
//                   LastPaymentItem(title: 'Lorem ipsum dolor sit amet', date: 'Nov 17'),
//                   LastPaymentItem(title: 'Lorem ipsum dolor sit amet', date: 'Dec 29'),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       )
//     );
//   }
// }

// class CurvedClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var path = Path();
//     path.lineTo(0, size.height - 20);
//     path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 20);
//     path.lineTo(size.width, 0);
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }

// // Dummy vehicle data until we got the api working
// List<Vehicle> getDummyVehicles() {
//   return [
//     Vehicle(model: 'Toyota Camry', plateNumber: 'ABC123', chassisNo: '1234567890'),
//     Vehicle(model: 'Honda Accord', plateNumber: 'XYZ456', chassisNo: '0987654321'),
//     Vehicle(model: 'Ford Mustang', plateNumber: 'MUS789', chassisNo: '1122334455'),
//     Vehicle(model: 'Chevrolet Camaro', plateNumber: 'CAM999', chassisNo: '6677889900'),
//     // Add more dummy vehicles as needed
//   ];
// }
