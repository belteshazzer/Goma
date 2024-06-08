import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';

import '../../../../../../utils/helpers/helper_functions.dart';
import '../../../../../../utils/theme/widget_themes/elevated_button_theme.dart';
import '../../../../controllers/SignUpController/I_registration_controller.dart';
import '../../emailVerificationPage/emailVerification.dart';


class CreateBtn extends StatelessWidget {
  const CreateBtn({required this.controllers,required this.phoneNumberNotifier,required this.formKey, super.key});

  final List<TextEditingController> controllers;
  final PhoneController? phoneNumberNotifier;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        elevatedButtonTheme: THelperFunctions.isDarkMode(context)? TElevatedButtonTheme.darkElevatedButtonTheme:TElevatedButtonTheme.lightElevatedButtonTheme,
      ),
      child:ElevatedButton(
        onPressed: () {

          if (formKey.currentState?.validate() ?? false) {
            final phoneNumber = phoneNumberNotifier?.value.international ?? '';
            IndividualRegistrationController.createUser(
              username: controllers[4].text,
              firstName: controllers[0].text,
              middleName: controllers[1].text,
              lastName: controllers[2].text,
              phoneNumber: phoneNumber,
              city:controllers[3].text,
            );
            print(IndividualRegistrationController.registrationStatus);
            if(IndividualRegistrationController.registrationStatus){
              THelperFunctions.navigateToScreen(context, EmailVerificationScreen(email:controllers[4].text));
            }
          }
        },
        child: const Text('create account'),
      ),
    );
  }
}