import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';
import '../../../../../../utils/helpers/helper_functions.dart';
import '../../../../../../utils/theme/widget_themes/elevated_button_theme.dart';
import '../../../../controllers/SignUpController/co_registration_controller.dart';
import '../../emailVerificationPage/emailVerification.dart';

class CreateBtn extends StatelessWidget {
  const CreateBtn({
    required this.controllers,
    required this.phoneNumberController,
    required this.formKey,
    super.key,
  });

  final List<TextEditingController> controllers;
  final PhoneController? phoneNumberController;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        elevatedButtonTheme: THelperFunctions.isDarkMode(context)
            ? TElevatedButtonTheme.darkElevatedButtonTheme
            : TElevatedButtonTheme.lightElevatedButtonTheme,
      ),
      child: ElevatedButton(
        onPressed: () async {
          if (formKey.currentState?.validate() ?? false) {
            final rawPhoneNumber = phoneNumberController?.value.international;
            final formattedPhoneNumber = formatPhoneNumber(rawPhoneNumber);

            bool success = await CoRegistrationController.createUser(
              username: controllers[2].text,
              companyName: controllers[0].text,
              phoneNumber: formattedPhoneNumber,
              city: controllers[1].text,
            );

            if (success) {
              THelperFunctions.navigateToScreen(
                context,
                EmailVerificationScreen(email: controllers[2].text),
              );
            } else {
              // Handle registration failure (e.g., show an error message)
              print('Registration failed');
            }
          }
        },
        child: const Text('Create Account'),
      ),
    );
  }

  String formatPhoneNumber(String? rawPhoneNumber) {
    if (rawPhoneNumber == null) return '';
    rawPhoneNumber = rawPhoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

    // Ensure the phone number is in the format +251999999
    if (rawPhoneNumber.startsWith('+251')) {
      rawPhoneNumber = rawPhoneNumber.substring(0, 13);
    }
    return rawPhoneNumber;
  }
}
