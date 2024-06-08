import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Theme(
          data: Theme.of(context).copyWith(
            inputDecorationTheme: THelperFunctions.isDarkMode(context)? TTextFormFieldTheme.darkInputDecorationTheme:TTextFormFieldTheme.lightInputDecorationTheme,
          ),
          child: Column(
            children: [
              Text('Enter Your Email Address', style:THelperFunctions.isDarkMode(context)? TTextTheme.darkTextTheme.bodyLarge:TTextTheme.lightTextTheme.bodyLarge),
              const SizedBox(height: TSizes.spaceBtwInputFields,),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: _isValid? null : 'Please enter a valid email',
                  errorStyle: const TextStyle(fontWeight: FontWeight.w200)
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
                    // Show error message or prevent action
                    print('Please enter a valid email');
                  }
                },
                child: _isLoading? const CircularProgressIndicator(strokeWidth: 20.0,): const Text('Submit'),
              ),
            ],
          )
        )
      ),
    );
  }
  void _getOtp(BuildContext context, String username) async {
    String username0 = username ;

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