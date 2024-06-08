import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../api_path.dart';

class SubmitPassword{


  static bool passwordAccepted=false;
  static String? errorMsg;

  static Future<void> submitPassword(String username, String password1) async {
    print("submitting password ");
    try {
      const String apiUrl = '$AuthenticationUrl/users/set-up-password';
      final http.Response response = await http.put(
        Uri.parse(apiUrl),
        body: json.encode({
          'username': username, 
          'password': password1,
        }),  
        headers: {'Content-Type': 'application/json'},
      );
      print(response.statusCode);
      if (response.statusCode == 204) {
        // Password set up successfully
        passwordAccepted=true;
      } else if (response.statusCode == 400){
        print('bad request');
        errorMsg='bad request';
      } else {
        print('Error setting up password: ${response.body}');
        errorMsg='Error setting up password';
      } 
    }catch (error) {
      print('Error setting up password: $error');
      errorMsg= 'Error setting up password';
    }
  }
}