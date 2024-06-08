import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../utils/helpers/helper_functions.dart';
import '../../../api_path.dart';
import '../../view/login/login.dart';

class ChangePassword {
  ChangePassword ({required this.username, required this.otpCode, required this.password});
  final String username;
  final String otpCode;
  final String password;

  bool isLoading = false;
  String errorMessage = '';

  setState(bool loading, String error) {
    isLoading = loading;
    errorMessage = error;
  }
  Future<Map<String, dynamic>> resetPassword(BuildContext context) async {
    try {
      const String apiUrl = '$AuthenticationUrl/users/reset-password-change/';
      setState(true, '');
      final http.Response response = await http.put(
        Uri.parse(apiUrl),
        body: json.encode({
          'username': username,
          'password': password,
          'password_reset_pin': otpCode,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        THelperFunctions.navigateToScreen(context, const LoginScreen());
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