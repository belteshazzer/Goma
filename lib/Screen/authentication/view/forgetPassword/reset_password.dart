import 'package:flutter/material.dart';
import 'package:fancy_password_field/fancy_password_field.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/ForgetPassWordController/changepassword.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required this.username});
  final String username;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController1 = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  final TextEditingController otpController = TextEditingController();
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
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with Text
                const Column(
                  children: [
                    // Replace with your actual logo widget or image asset
                    Icon(Icons.notifications, size: 100, color: TColors.white),
                    SizedBox(height: 10),
                    Text(
                      'G-NOTIFY',
                      style: TextStyle(
                        fontSize: TSizes.fontSizeLg,
                        fontWeight: FontWeight.bold,
                        color: TColors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                const Text(
                  'We just sent you a verification number via your email, please enter it here:',
                  style: TextStyle(
                    fontSize: TSizes.fontSizeMd,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'OTP Code',
                    border: OutlineInputBorder(),
                    // borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                const SizedBox(height: 20),
                FancyPasswordField(
                  controller: _passwordController1,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(),
                    // borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                FancyPasswordField(
                  controller: _passwordController2,
                  hasStrengthIndicator: false,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                    // borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  validator: (value) {
                    if (_passwordController2.text != _passwordController1.text) {
                      return 'The password doesn\'t match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                ElevatedButton(
                  onPressed: () {
                    resetPassword();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                        )
                      : const Text(
                          'Confirm',
                          style: TextStyle(
                            fontSize: TSizes.fontSizeMd,
                          ),
                        ),
                ),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void resetPassword() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final result = await ChangePassword(
      username: widget.username,
      otpCode: otpController.text,
      password: _passwordController1.text,
    ).resetPassword(context);

    setState(() {
      _isLoading = result['isLoading'];
      _errorMessage = result['errorMessage'];
    });
  }
}
