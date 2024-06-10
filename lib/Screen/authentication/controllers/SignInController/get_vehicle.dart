import 'dart:convert';
import 'package:goma/Screen/api_path.dart';
import 'package:goma/Screen/vehicle/vehicle_model.dart';
import 'package:http/http.dart' as http;

class GetVehicle {
  static Future<List<Vehicle>?> getVehiclesByOwnerId(String ownerId, String userToken) async {
    String apiUrl = '$AuthenticationUrl/vehicles/owner_vehicle/$ownerId/';
    try {
      final http.Response response = await http.get(Uri.parse(apiUrl), headers: {"Authorization": "JWT $userToken"});
      print("response ${response.body} status ${response.statusCode}");
      if (response.statusCode == 200) {
        // Debug the raw JSON response
        print('Raw JSON response: ${response.body}');

        // Decode the JSON response
        List<dynamic> jsonBody = json.decode(response.body);

        // Ensure the decoded response is a list
        if (jsonBody is List) {
          List<Vehicle> vehicles = jsonBody.map((item) => Vehicle.fromJson(item)).toList();
          
          print(vehicles);
          return vehicles;
        } else {
          print('JSON response is not a list');
          return null;
        }
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
