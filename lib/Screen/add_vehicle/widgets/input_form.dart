import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goma/common/bar/bar.dart';
import 'package:goma/utils/constants/colors.dart';
import 'package:goma/utils/helpers/helper_functions.dart';
import 'package:iconsax/iconsax.dart';
import '../../api_path.dart';
import '../add_vehicles_controller.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class InputForm extends StatefulWidget {
  final bool dark;

  const InputForm({super.key, required this.dark});

  @override
  InputFormState createState() => InputFormState();
}

class InputFormState extends State<InputForm> {
  final TextEditingController chassisNoController = TextEditingController();
  final TextEditingController plateNumberController = TextEditingController();
  final ApiService apiService = ApiService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _userToken = '';
  String? _selectedInsuranceCompany;
  List<String> _insuranceCompanies = [];

  bool isLoading = false;

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userToken = prefs.getString('accessToken') ?? '';
    });
  }

  Future<void> _fetchInsuranceCompanies() async {
    final response = await http.get(Uri.parse('$AuthenticationUrl/institutions/'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _insuranceCompanies = data.map((company) => company['name'].toString()).toList();
      });
    } else {
      // Handle the error appropriately
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to fetch insurance companies', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchInsuranceCompanies();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = THelperFunctions.isDarkMode(context);
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            _buildTextField(controller: chassisNoController, label: TTexts.chassisNo),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            _buildDropdownField(),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            _buildTextField(controller: plateNumberController, label: TTexts.plateNumber),
            const SizedBox(height: TSizes.spaceBtwSections),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _submitForm,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(isDarkMode ? TColors.light : TColors.dark),
                ),
                child: isLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(isDarkMode ? TColors.dark : TColors.light),
                      )
                    : const Text(TTexts.addVehicle),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label}) {
    final isDarkMode = THelperFunctions.isDarkMode(context);
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? TColors.darkerGrey : TColors.lightGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: const Icon(Iconsax.direct),
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdownField() {
    final isDarkMode = THelperFunctions.isDarkMode(context);
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? TColors.darkerGrey : TColors.lightGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedInsuranceCompany,
        decoration: InputDecoration(
          prefixIcon: const Icon(Iconsax.direct),
          labelText: TTexts.insuranceCompany,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        items: _insuranceCompanies.map((String company) {
          return DropdownMenuItem<String>(
            value: company,
            child: Text(company),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedInsuranceCompany = newValue;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select an insurance company';
          }
          return null;
        },
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      final chassisNumber = int.parse(chassisNoController.text);
      final insuranceCompanyName = _selectedInsuranceCompany!;
      final plateNumber = plateNumberController.text;
      final result = await apiService.addVehicle(
        chassisNumber: chassisNumber,
        insuranceCompanyName: insuranceCompanyName,
        plateNumber: plateNumber,
        token: _userToken,
      );

      setState(() {
        isLoading = false;
      });

      if (result['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vehicle added successfully!', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
        _showAddMoreVehiclesDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'], style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showAddMoreVehiclesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Vehicle Added successfully!'),
          content: const Text('Do you want to add another vehicle?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No, Skip'),
              onPressed: () {
                THelperFunctions.navigateToScreen(context, BottomNavBar());
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                chassisNoController.clear();
                plateNumberController.clear();
                setState(() {
                  _selectedInsuranceCompany = null;
                });
              },
            ),
          ],
        );
      },
    );
  }
}
