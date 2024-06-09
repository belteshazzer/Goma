import 'dart:convert';
import 'package:goma/Screen/api_path.dart';
import 'package:http/http.dart' as http;

class ApiService {

  Future<Map<String, dynamic>> addVehicle({
    required String chassisNumber,
    required String insuranceCompanyName,
    required String plateNumber,
    required String token,
  }) async {
    final url = Uri.parse('$AuthenticationUrl/add_vehicle/');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({
      'chassis_number': chassisNumber,
      'insurance_company_name': insuranceCompanyName,
      'plate_number': plateNumber,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return {'status': 'success'};
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return jsonDecode(response.body);
    } else {
      return {'status': 'error', 'message': 'Unexpected error occurred'};
    }
  }
}
