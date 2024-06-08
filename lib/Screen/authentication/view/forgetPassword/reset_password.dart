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
  final TextEditingController _passwordController1= TextEditingController();
  final TextEditingController _passwordController2= TextEditingController();
  final TextEditingController otpController = TextEditingController();
  bool _isLoading=false;
  String _errorMessage='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [

            const Text(
              'we just send you a verification number via your email, please ensert it here,',
              style: TextStyle(
                fontSize: TSizes.fontSizeMd,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'OTP Code',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            FancyPasswordField(
              controller: _passwordController1,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'new password',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields),

            FancyPasswordField(
              controller: _passwordController2,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if(_passwordController2.text !=_passwordController1.text){
                  return 'the password doesn\'t match';
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
                backgroundColor: TColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              ),
              child: const Text(
                'Confirm',
                style: TextStyle(
                  fontSize: TSizes.fontSizeMd,
                ),
              ),
            ),
          ],
        )
      )
    );
  }
  
  void resetPassword() async{

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final result = await ChangePassword(username:widget.username, otpCode:otpController.text, password:_passwordController1.text).resetPassword(context);

    setState(() {
      _isLoading = result['isLoading'];
      _errorMessage = result['errorMessage'];
    });
  }
}