import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:goma/common/bar/bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../api_path.dart';
import '../../../user_account/account.dart';

class LoginController {
  static Future<Map<String, dynamic>> login(BuildContext context, String username, String password) async {
    final TextEditingController usernameController = TextEditingController(text: username);
    final TextEditingController passwordController = TextEditingController(text: password);
    late SharedPreferences prefs;

    prefs = await SharedPreferences.getInstance();

    bool isLoading = false;
    String errorMessage = '';

    void setState(bool loading, String error) {
      isLoading = loading;
      errorMessage = error;
    }

    const String apiUrl = '$AuthenticationUrl/auth/jwt/create';

    try {
      setState(true, '');
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode({
          'username': usernameController.text,
          'password': passwordController.text,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Login successful
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String accessToken = responseData['access'];
        final String refreshToken = responseData['refresh'];

        print(accessToken);

        // Store tokens in SharedPreferences
        prefs.setString('accessToken', accessToken);
        prefs.setString('refreshToken', refreshToken);

        // Fetch user data to get the owner ID
        final userResponse = await http.get(
          Uri.parse('$AuthenticationUrl/users/get-user-id/'),
          headers: {'Authorization': 'JWT $accessToken'},
        );
        print(userResponse.statusCode);
        print(userResponse.body); 
        if (userResponse.statusCode == 200) {
          print("here");
          final responseData = json.decode(userResponse.body);
          print(responseData);
          final String ownerId = responseData['id'];
          print(ownerId);

          // Store owner ID in SharedPreferences
          prefs.setString('ownerId', ownerId);
          setState(false, '');
          
          THelperFunctions.navigateToScreen(
            context,
            BottomNavBar(),
          );
          
        } else {
          setState(false, 'Failed to fetch user data.');
        }
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
