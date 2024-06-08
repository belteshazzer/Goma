import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../api_path.dart';
import '../../models/company_model.dart';

class CoRegistrationController {
  static bool registrationStatus=false;
  static Future<void> createUser({
    required String username,
    required String companyName,
    required String phoneNumber,
    required String city,
  }) async {
    final Uri uri = Uri.parse('$AuthenticationUrl/users/co/create/');

    final CompanyModel companyData = CompanyModel(
      username: username,
      company_name: companyName,
      contact: Contact(
        phone_number: phoneNumber,
        city: city,
      ),
    );

    print('Request Payload: ${json.encode(companyData.toJson())}');

    try {
      final response = await http.post(
        uri,
        body: json.encode(companyData.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
      print(response.statusCode);
      if (response.statusCode == 201) {
        print('User created successfully');
        print(response.body);
        registrationStatus=true;

      } else if (response.statusCode == 400) {
        // Handle Bad Request error
        print('Bad Request: ${response.body}');
      } else {
        // Handle error
        print('Error creating user: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors
      print('Error creating user: $error');
    }
  }
}
