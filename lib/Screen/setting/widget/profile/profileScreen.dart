import 'package:flutter/material.dart';
import 'package:goma/Screen/setting/widget/profile/ProfileBody.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../api_path.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // User data
  Map<String, dynamic>? user;

  String? _userId;
  String _userToken = '';

  // Edit mode flag
  bool isEditMode = false;

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Text editing controllers
  late TextEditingController _usernameController;
  late TextEditingController _firstNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _cityController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadUserData();
  }

  void _initializeControllers() {
    _usernameController = TextEditingController();
    _firstNameController = TextEditingController();
    _middleNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _cityController = TextEditingController();
    _emailController = TextEditingController();
  }

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('ownerId');
    _userToken = prefs.getString('accessToken') ?? '';

    final url = Uri.parse("$AuthenticationUrl/users/in/create/$_userId");
    final http.Response response = await http.get(url, headers: {"Authorization": "JWT $_userToken"});

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      setState(() {
        user = responseData;
        _updateControllers();
      });
    } else {
      // Handle the case when the status code is not 200
      print("Failed to load user data");
    }
  }

  void _updateControllers() {
    if (user != null) {
      _usernameController.text = user!['username'] ?? '';
      _firstNameController.text = user!['first_name'] ?? '';
      _middleNameController.text = user!['middle_name'] ?? '';
      _lastNameController.text = user!['last_name'] ?? '';
      _phoneNumberController.text = user!['contact']['phone_number'] ?? '';
      _cityController.text = user!['contact']['city'] ?? '';
      _emailController.text = user!['username'] ?? '';
    }
  }

  Future<void> _saveUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('ownerId');
    final userToken = prefs.getString('accessToken') ?? '';

    final url = Uri.parse("$AuthenticationUrl/users/in/update/$userId/");
    final response = await http.put(
      url,
      headers: {
        "Authorization": "JWT $userToken",
        "Content-Type": "application/json"
      },
      body: json.encode({
        'username': _usernameController.text,
        'first_name': _firstNameController.text,
        'middle_name': _middleNameController.text,
        'last_name': _lastNameController.text,
        'contact': {
          'phone_number': _phoneNumberController.text,
          'city': _cityController.text,
        },
        'email': _emailController.text
      }),
    );
    
    if (response.statusCode == 200) {
      setState(() {
        user!['username'] = _usernameController.text;
        user!['first_name'] = _firstNameController.text;
        user!['middle_name'] = _middleNameController.text;
        user!['last_name'] = _lastNameController.text;
        user!['contact']['phone_number'] = _phoneNumberController.text;
        user!['contact']['city'] = _cityController.text;
        user!['email'] = _emailController.text;
        isEditMode = false;
      });
    } else {
      // Handle save error
      print("Failed to save user data");
    }
  }

  @override
  void dispose() {
    // Dispose text editing controllers
    _usernameController.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _cityController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(isEditMode ? Icons.save : Icons.edit),
            onPressed: () {
              if (isEditMode) {
                // Save changes
                if (_formKey.currentState!.validate()) {
                  _saveUserData();
                }
              } else {
                // Enable edit mode
                setState(() {
                  isEditMode = true;
                });
              }
            },
          ),
        ],
      ),
      body: ProfileBody(formKey: _formKey, emailController: _emailController, isEditMode: isEditMode, firstNameController: _firstNameController, middleNameController: _middleNameController, lastNameController: _lastNameController, phoneNumberController: _phoneNumberController, cityController: _cityController),
    );
  }
}

