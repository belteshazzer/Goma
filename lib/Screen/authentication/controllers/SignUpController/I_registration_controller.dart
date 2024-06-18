import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/user_model.dart';
import '../../../api_path.dart';

class IndividualRegistrationController {
  static Future<bool> createUser({
    required String username,
    required String firstName,
    required String middleName,
    required String lastName,
    required String? phoneNumber,
    required String city,
  }) async {
    final Uri uri = Uri.parse('$AuthenticationUrl/users/in/create/');

    final UserModel userData = UserModel(
      username: username,
      first_name: firstName,
      middle_name: middleName,
      last_name: lastName,
      contact: Contact(phone_number: phoneNumber, city: city),
    );

    print('Request Payload: ${json.encode(userData.toJson())}');

    try {
      final response = await http.post(
        uri,
        body: json.encode(userData.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
      print("response ${response.body} status ${response.statusCode}");
      if (response.statusCode == 201) {
        print('User created successfully');
        return true;
      } else if (response.statusCode == 400) {
        print('Bad Request: ${response.body}');
      } else {
        print('Error creating user: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors
      print('Error creating user: $error');
    }
    return false;
  }
}
