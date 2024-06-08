import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../api_path.dart';

class EmailVerificationController{

  static Future<bool> verifyEmail(String email, int verificationPin) async {
    const String apiUrl ='$AuthenticationUrl/users/verify-email/';
    final Map<String, dynamic> requestData = {
      "username": email,
      "verification_pin": verificationPin,
    };
    try {
      final http.Response response = await http.put(
        
        Uri.parse(apiUrl),
        body: json.encode(requestData),
        headers: {'Content-Type': 'application/json'},
      );
       // Debugging logs
      print("Request Data: ${json.encode(requestData)}");
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        print('Email verified successfully');
        return true;
      } 
      else if (response.statusCode == 400) {
        print('error occured');
        return false;
      }
      else {
        print('Failed to verify email. Status Code: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error verifying email: $error');
      return false;
    }
  }
}
