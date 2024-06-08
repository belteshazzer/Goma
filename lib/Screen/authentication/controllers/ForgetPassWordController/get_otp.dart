import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../utils/helpers/helper_functions.dart';
import '../../view/forgetPassword/reset_password.dart';

class forgetPassword {
  static Future<Map<String, dynamic>> getOtp(BuildContext context, String username) async {
    
    bool isLoading = false;
    String errorMessage = '';

    setState(bool loading, String error) {
      isLoading = loading;
      errorMessage = error;
    }

    const String apiUrl = 'https://g-notify-user-auth-eb39843fac64.herokuapp.com/users/reset-password-request/';

    try {
      setState(true, '');
      final http.Response response = await http.put(
        Uri.parse(apiUrl),
        body: json.encode({
          'username': username,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      print (response.body);
      if (response.statusCode == 200) {

        THelperFunctions.navigateToScreen(context, ResetPasswordScreen(username:username));
      } else {
        final Map<String, dynamic> errorData = json.decode(response.body);
        setState(false, errorData['detail']);
      }
    } catch (error) {
      setState(false, 'Failed to connect to the server. Please try again.');
    }

    return {'isLoading': isLoading, 'errorMessage': errorMessage};
  }
}