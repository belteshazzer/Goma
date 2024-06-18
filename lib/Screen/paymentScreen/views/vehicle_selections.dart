import 'package:flutter/material.dart';
import 'package:goma/Screen/authentication/controllers/SignInController/get_vehicle.dart';
import 'package:goma/Screen/paymentScreen/views/payment_info_screen.dart';
import 'package:goma/utils/helpers/helper_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/constants/colors.dart';
import '../../vehicle/vehicle_model.dart';


class VehicleSelection extends StatefulWidget {
  const VehicleSelection({super.key, required this.docType});
  final String? docType;

  @override
  _VehicleSelectionState createState() => _VehicleSelectionState();
}

class _VehicleSelectionState extends State<VehicleSelection> {
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
    bool isDarkMode = THelperFunctions.isDarkMode(context);

    Color textColor = isDarkMode ? TColors.dark : TColors.light;
    Color cardBGColor = isDarkMode ? TColors.lightContainer : TColors.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Vehicle List for ${widget.docType}',
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
                                builder: (context) => PaymentInformationScreen(vehicle: vehicles[index], docType: widget.docType!,userToken: _userToken,),
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
                                              'chassis no_: ${vehicles[index].chassisnumber}',
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
