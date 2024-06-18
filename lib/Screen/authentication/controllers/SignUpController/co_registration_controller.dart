import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../api_path.dart';
import '../../models/company_model.dart';

class CoRegistrationController {
  static Future<bool> createUser({
    required String username,
    required String companyName,
    required String phoneNumber,
    required String city,
  }) async {
    final Uri uri = Uri.parse('$AuthenticationUrl/users/co/create/');

    final CompanyModel companyData = CompanyModel(
      username: username,
      companyName: companyName,
      contact: Contact(
        phoneNumber: phoneNumber,
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
      print('response ${response.body} status code ${response.statusCode}');
      if (response.statusCode == 201) {
        print('User created successfully');
        print(response.body);
        return true;
      } else if (response.statusCode == 400) {
        print('Bad Request: ${response.body}');
      } else {
        print('Error creating user: ${response.statusCode}');
      }
    } catch (error) {
      print('Error creating user: $error');
    }
    return false;
  }
}
