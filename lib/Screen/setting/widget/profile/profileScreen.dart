import 'package:flutter/material.dart';
import 'package:goma/Screen/setting/widget/profile/ProfileBody.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:shimmer/shimmer.dart'; // Import the shimmer package
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

  // Data loading flag
  bool isLoading = true;

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

    final url = Uri.parse("$AuthenticationUrl/users/in/create/$_userId/");
    final http.Response response = await http.get(url, headers: {"Authorization": "JWT $_userToken"});

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      setState(() {
        user = responseData;
        _updateControllers();
        isLoading = false;
      });
    } else {
      // Handle the case when the status code is not 200
      print("Failed to load user data");
      setState(() {
        isLoading = false;
      });
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
      body: isLoading
          ? _buildShimmerEffect() // Show shimmer effect while loading
          : ProfileBody(
              formKey: _formKey,
              emailController: _emailController,
              isEditMode: isEditMode,
              firstNameController: _firstNameController,
              middleNameController: _middleNameController,
              lastNameController: _lastNameController,
              phoneNumberController: _phoneNumberController,
              cityController: _cityController,
            ),
    );
  }

Widget _buildShimmerEffect() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      children: [
        // Circle Avatar shimmer
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 200.0,
                    height: 20.0,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    width: 150.0,
                    height: 20.0,
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 16.0),
        // Name field shimmer
        _shimmerItem(width: double.infinity, height: 40.0),
        SizedBox(height: 16.0),
        // Email field shimmer
        _shimmerItem(width: double.infinity, height: 40.0),
        SizedBox(height: 16.0),
        // Phone field shimmer
        _shimmerItem(width: double.infinity, height: 40.0),
        SizedBox(height: 16.0),
        // City field shimmer
        _shimmerItem(width: double.infinity, height: 40.0),
        SizedBox(height: 16.0),
        // Save button shimmer
        _shimmerItem(width: 150.0, height: 40.0),
      ],
    ),
  );
}

Widget _shimmerItem({required double width, required double height}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
  );
}

}
