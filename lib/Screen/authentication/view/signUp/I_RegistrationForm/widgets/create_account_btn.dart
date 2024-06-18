import 'package:flutter/material.dart';
import 'package:goma/utils/constants/colors.dart';
import 'package:phone_form_field/phone_form_field.dart';

import '../../../../../../utils/helpers/helper_functions.dart';
import '../../../../../../utils/theme/widget_themes/elevated_button_theme.dart';
import '../../../../controllers/SignUpController/I_registration_controller.dart';
import '../../emailVerificationPage/emailVerification.dart';

class CreateBtn extends StatelessWidget {
  const CreateBtn({
    required this.controllers,
    required this.phoneNumberNotifier,
    required this.formKey,
    super.key,
  });

  final List<TextEditingController> controllers;
  final PhoneController? phoneNumberNotifier;
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
            final phoneNumber = phoneNumberNotifier?.value.international ?? '';

            final result = await IndividualRegistrationController.createUser(
              username: controllers[4].text,
              firstName: controllers[0].text,
              middleName: controllers[1].text,
              lastName: controllers[2].text,
              phoneNumber: phoneNumber,
              city: controllers[3].text,
            );

            if (result['success']) {
              THelperFunctions.navigateToScreen(
                context,
                EmailVerificationScreen(email: controllers[4].text),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(result['message'])),
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              THelperFunctions.isDarkMode(context) ? TColors.light : TColors.dark,
          side: const BorderSide(
            color: Colors.grey,
          ),
        ),
        child: Text(
          'create account',
          style: TextStyle(
              color: THelperFunctions.isDarkMode(context) ? TColors.dark : TColors.light),
        ),
      ),
    );
  }
}
