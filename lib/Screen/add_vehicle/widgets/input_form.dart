import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goma/Screen/home/home.dart';
import 'package:iconsax/iconsax.dart';
import '../add_vehicles_controller.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputForm extends StatefulWidget {
  final bool dark;

  const InputForm({super.key, required this.dark});

  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final TextEditingController chassisNoController = TextEditingController();
  final TextEditingController insuranceCompanyController = TextEditingController();
  final TextEditingController plateNumberController = TextEditingController();
  final ApiService apiService = ApiService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _userToken='';

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userToken = prefs.getString('accessToken') ?? '';
    });
  }
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            _buildTextField(controller: chassisNoController, label: TTexts.chassisNo),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            _buildTextField(controller: insuranceCompanyController, label: TTexts.insuranceCompany),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            _buildTextField(controller: plateNumberController, label: TTexts.plateNumber),
            const SizedBox(height: TSizes.spaceBtwSections),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(const Color(0xFF003A91)),
                ),
                child: const Text(TTexts.addVehicle),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label}) {
    return Container(
      color: const Color(0xFF003A91).withOpacity(0.6),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: const Icon(Iconsax.direct),
          labelText: label,
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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final chassisNumber = chassisNoController.text;
      final insuranceCompanyName = insuranceCompanyController.text;
      final plateNumber = plateNumberController.text;

      final result = await apiService.addVehicle(
        chassisNumber: chassisNumber,
        insuranceCompanyName: insuranceCompanyName,
        plateNumber: plateNumber,
        token: _userToken,
      );

      if (result['status'] == 'success') {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text('Vehicle added successfully!', style: TextStyle(color: Colors.white)),
        //     backgroundColor: Colors.green,
        //     duration: Duration(seconds: 1),
        //     behavior: SnackBarBehavior.floating,
        //   ),
        // );
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
                Navigator.of(context).pop(); 
                Get.to(() => const HomePage()); 
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(); 
                chassisNoController.clear();
                insuranceCompanyController.clear();
                plateNumberController.clear();
              },
            ),
          ],
        );
      },
    );
  }
}
