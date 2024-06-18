import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../../utils/theme/widget_themes/text_field_theme.dart';
import '../../../../utils/theme/widget_themes/text_theme.dart';
import '../../controllers/ForgetPassWordController/get_otp.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  _EmailPageState createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isValid = true;
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: THelperFunctions.isDarkMode(context) ? TTextFormFieldTheme.darkInputDecorationTheme : TTextFormFieldTheme.lightInputDecorationTheme,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with Text
                Column(
                  children: [
                    // Replace with your actual logo widget or image asset
                    Icon(Icons.email, size: 100, color: THelperFunctions.isDarkMode(context) ? Colors.white : Colors.black),
                    const SizedBox(height: 10),
                    Text('G-NOTIFY', style: THelperFunctions.isDarkMode(context) ? TTextTheme.darkTextTheme.headlineMedium : TTextTheme.lightTextTheme.headlineMedium),
                  ],
                ),
                const SizedBox(height: 40),
                Text('Enter Your Email Address', style: THelperFunctions.isDarkMode(context) ? TTextTheme.darkTextTheme.bodyLarge : TTextTheme.lightTextTheme.bodyLarge),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText: _isValid ? null : 'Please enter a valid email',
                    errorStyle: const TextStyle(fontWeight: FontWeight.w200),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (_) {
                    setState(() {
                      _isValid = EmailValidator.validate(_emailController.text);
                    });
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                ElevatedButton(
                  onPressed: () {
                    // Handle button press
                    if (_isValid) {
                      _getOtp(context, _emailController.text);
                      print('Email is valid: ${_emailController.text}');
                    } else {
                      print('Please enter a valid email');
                    }
                  },
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor: AlwaysStoppedAnimation<Color>(TColors.black),
                          ),
                        )
                      : const Text('Submit'),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                if (_errorMessage.isNotEmpty)
                  Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _getOtp(BuildContext context, String username) async {
    String username0 = username;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final result = await forgetPassword.getOtp(context, username0);

    setState(() {
      _isLoading = result['isLoading'];
      _errorMessage = result['errorMessage'];
    });
  }
}
