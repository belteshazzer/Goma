import 'package:flutter/material.dart';
import 'package:goma/Screen/authentication/controllers/SignInController/get_vehicle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/constants/colors.dart';
import 'vehicle_details_page.dart';
import 'vehicle_model.dart';

class VehicleListPage extends StatefulWidget {
  const VehicleListPage({super.key});

  @override
  _VehicleListPageState createState() => _VehicleListPageState();
}

class _VehicleListPageState extends State<VehicleListPage> {
  late Future<List<Vehicle>?> futureVehicles;

  String _userToken='';
  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userToken = prefs.getString('accessToken') ?? '';
    });
  }
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
    futureVehicles = GetVehicle.getVehiclesByOwnerId(_userToken); 
  }

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
      body: FutureBuilder<List<Vehicle>?>(
        future: futureVehicles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No vehicles found'));
          } else {
            List<Vehicle> vehicles = snapshot.data!;
            return ListView.builder(
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VehicleDetailsPage(vehicle: vehicles[index]),
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
                                const Icon(Icons.directions_car, color: TColors.primary),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${vehicles[index].id} - ${vehicles[index].plate_number}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                    ),
                                    Text(
                                      'chassis no_: ${vehicles[index].chassis_number}',
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
        },
      ),
    );
  }
}
