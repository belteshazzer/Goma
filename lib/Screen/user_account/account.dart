import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserAccountPage extends StatefulWidget {
  final token;
  final refreshToken;
  const UserAccountPage({required this.refreshToken, required this.token, super.key});
  @override
  State<UserAccountPage> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccountPage> {
 int? id; 
 String? email, username;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final url = Uri.parse('https://g-notify-user-auth-eb39843fac64.herokuapp.com/auth/users/me/');

    final response = await http.get(
      url,
      headers: {'Authorization': 'JWT ${widget.token}'},
    );

    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      setState(() {
        id = userData['id'];
        email = userData['email'];
        username = userData['username'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (id != null) Text('ID: $id'),
            if (email != null) Text('Email: $email'),
            if (username != null) Text('Username: $username'),
          ],
        ),
      ),
    );
  }
}