import 'package:flutter/material.dart';
import 'package:goma/Screen/start_pages/views/landing_page/widgets/login_btn_widget.dart';
import 'package:goma/utils/constants/colors.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../../../utils/theme/widget_themes/elevated_button_theme.dart';
import '../../../controllers/SignInController/log_in_controller.dart';
import '../../forgetPassword/insert_email_screen.dart';
import '../../signUp/userType/user_type.dart';
// import 'package:t_store/common/widgets_login_signup/social_button.dart';
// import 'package:t_store/common/widgets_login_signup/form_divider.dart';

class TLoginForm extends StatefulWidget {
  const TLoginForm({super.key, required this.dark});

  final bool dark;

  @override
  State<TLoginForm> createState() => _TLoginFormState();
}

class _TLoginFormState extends State<TLoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isPasswordVisible =
      false; // Added variable to track password visibility

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ElevatedButtonTheme(
      data: THelperFunctions.isDarkMode(context)
          ? TElevatedButtonTheme.darkElevatedButtonTheme
          : TElevatedButtonTheme.lightElevatedButtonTheme,
      child: Form(
        key: _formKey,
        child: Padding(
          padding:
              const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
          child: Center(
            child: Column(
              children: [
                /// Email
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.direct_right),
                    labelText: TTexts.email,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: TSizes.spaceBtwInputFields,
                ),

                /// Password
                TextFormField(
                  controller: _passwordController,
                  obscureText:
                      !_isPasswordVisible, // Toggle visibility based on state
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Iconsax.password_check),
                    labelText: TTexts.password,
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordVisible
                          ? Iconsax.eye
                          : Iconsax.eye_slash), // Change icon based on state
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible =
                              !_isPasswordVisible; // Toggle visibility state
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    // You can add more specific validation rules here if needed
                    return null;
                  },
                ),

                const SizedBox(
                  height: TSizes.spaceBtwInputFields / 2,
                ),

                /// Remember me and Forget Password
                Row(
                  children: [
                    ///Remember me
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Checkbox(value: true, onChanged: (value) {}),
                        const Text(TTexts.rememberMe),
                      ],
                    ),

                    ///Forgot Password
                    TextButton(
                      onPressed: () => THelperFunctions.navigateToScreen(
                          context, const EmailPage()),
                      child: const Text(TTexts.forgetPassword),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                // sign in Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _login(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                    
                      backgroundColor:THelperFunctions.isDarkMode(context) ? TColors.light : TColors.dark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8), 
                             // Set the desired border radius here
                      ),
                      side: const BorderSide(color: Colors.grey),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        :  Text('Login',style: TextStyle(color:THelperFunctions.isDarkMode(context) ? Colors.black: Colors.white),),
                  ),
                ),

                if (_errorMessage.isNotEmpty)
                  Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),

                const SizedBox(height: TSizes.spaceBtwItems),
                const SizedBox(
                  width: double.infinity,
                  child: DarkBgButtonWidget(text: "Create Account",screen: ChooseUserType(),),
                ),

                const SizedBox(
                  height: TSizes.defaultSpace,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login(BuildContext context) async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final result = await LoginController.login(context, username, password);

    setState(() {
      _isLoading = result['isLoading'];
      _errorMessage = result['errorMessage'];
    });
  }
}
