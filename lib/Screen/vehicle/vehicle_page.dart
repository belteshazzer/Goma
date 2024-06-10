import 'package:flutter/material.dart';
import 'package:goma/Screen/authentication/controllers/SignInController/get_vehicle.dart';
import 'package:goma/Screen/vehicle/widgets/vehicleService.dart';
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
  List<Vehicle> vehicles = [];
  String _userToken = '';
  String _ownerId = '';
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      _userToken = prefs.getString('accessToken') ?? '';
      _ownerId = prefs.getString('ownerId') ?? '';

      List<Vehicle>? fetchedVehicles = await GetVehicle.getVehiclesByOwnerId(_ownerId, _userToken);
      if (fetchedVehicles != null) {
        setState(() {
          vehicles = fetchedVehicles;
        });
      } else {
        setState(() {
          _error = 'Failed to load vehicles';
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }finally {
      setState(() {
        _isLoading = false;
      });
    }
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : vehicles.isEmpty
                  ? const Center(child: Text('No vehicles found'))
                  : ListView.builder(
                      itemCount: vehicles.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VehicleDetail(vehicle: vehicles[index]),
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
                                              'chassis no_: ${vehicles[index].chassisNumber}',
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
                    ),
    );
  }
}
