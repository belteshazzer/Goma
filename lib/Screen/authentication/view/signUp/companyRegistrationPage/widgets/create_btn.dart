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
        onPressed: () {
          if (formKey.currentState?.validate() ?? false) {
            final rawPhoneNumber = phoneNumberController?.value.international;
            final formattedPhoneNumber = formatPhoneNumber(rawPhoneNumber);

            CoRegistrationController.createUser(
              username: controllers[2].text,
              companyName: controllers[0].text,
              phoneNumber: formattedPhoneNumber,
              city: controllers[1].text,
            );
            if(CoRegistrationController.registrationStatus){
              THelperFunctions.navigateToScreen(
                context,
                EmailVerificationScreen(email: controllers[2].text),
              );
            }
          }
        },
        child: const Text('create account'),
      ),
    );
  }

  String formatPhoneNumber(String? rawPhoneNumber) {
    if (rawPhoneNumber == null) return '';
    rawPhoneNumber = rawPhoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

    if (rawPhoneNumber.startsWith('+251') && rawPhoneNumber.length == 13) {
      return '+251 ${rawPhoneNumber.substring(4, 6)} ${rawPhoneNumber.substring(6, 9)} ${rawPhoneNumber.substring(9, 13)}';
    }
    print(rawPhoneNumber);

    return rawPhoneNumber;
  }
}
