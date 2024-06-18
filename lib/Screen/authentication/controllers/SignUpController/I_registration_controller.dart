import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/user_model.dart';
import '../../../api_path.dart';

class IndividualRegistrationController {
  static Future<Map<String, dynamic>> createUser({
    required String username,
    required String firstName,
    required String middleName,
    required String lastName,
    required String? phoneNumber,
    required String city,
  }) async {
    final Uri uri = Uri.parse('$AuthenticationUrl/users/in/create/');
    print('uri: $uri');
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
      
      switch (response.statusCode) {
        case 201:
          print('User created successfully');
          return {'success': true};
        case 400:
          return {'success': false, 'message': 'Bad Request: ${response.body}'};
        case 401:
          return {'success': false, 'message': 'Unauthorized: ${response.body}'};
        case 403:
          return {'success': false, 'message': 'Forbidden: ${response.body}'};

        case 409:
          return {'success': false, 'message': 'User already exists.'};
        case 500:
          return {'success': false, 'message': 'Server is currently unavailable. Please try again later.'};
        default:
          return {'success': false, 'message': 'Unexpected Error: ${response.statusCode} - ${response.body}'};
      }
    } on http.ClientException catch (e) {
      return {'success': false, 'message': 'Network Error: $e'};
    } on FormatException catch (e) {
      return {'success': false, 'message': 'Invalid Response Format: $e'};
    } catch (e) {
      return {'success': false, 'message': 'Unexpected Error: $e'};
    }
  }
}
