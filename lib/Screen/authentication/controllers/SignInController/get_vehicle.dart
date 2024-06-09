import 'dart:convert';
import 'package:goma/Screen/api_path.dart';
import 'package:goma/Screen/vehicle/vehicle_model.dart';
import 'package:http/http.dart' as http;

class GetVehicle {
  static Future<List<Vehicle>?> getVehiclesByOwnerId(String ownerId) async {    
    String apiUrl = '$AuthenticationUrl/documents/owner/$ownerId';
    try {
      final http.Response response = await http.get(Uri.parse(apiUrl));
      
      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        List<Vehicle> vehicles = body.map((dynamic item) => Vehicle.fromJson(item)).toList();
        print(vehicles);
        return vehicles;
      } else {
        print('Failed to load vehicles. Status Code: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error fetching vehicles: $error');
      return null;
    }
  }
}