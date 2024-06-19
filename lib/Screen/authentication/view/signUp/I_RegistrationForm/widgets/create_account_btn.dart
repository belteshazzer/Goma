import 'package:flutter/material.dart';
import 'package:goma/utils/constants/colors.dart';
import 'package:phone_form_field/phone_form_field.dart';

import '../../../../../../utils/helpers/helper_functions.dart';
import '../../../../../../utils/theme/widget_themes/elevated_button_theme.dart';
import '../../../../controllers/SignUpController/I_registration_controller.dart';
import '../../emailVerificationPage/emailVerification.dart';

class CreateBtn extends StatefulWidget {
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
  _CreateBtnState createState() => _CreateBtnState();
}

class _CreateBtnState extends State<CreateBtn> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        elevatedButtonTheme: THelperFunctions.isDarkMode(context)
            ? TElevatedButtonTheme.darkElevatedButtonTheme
            : TElevatedButtonTheme.lightElevatedButtonTheme,
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : () async {
          if (widget.formKey.currentState?.validate() ?? false) {
            setState(() {
              isLoading = true;
            });

            final phoneNumber = widget.phoneNumberNotifier?.value.international ?? '';

            final result = await IndividualRegistrationController.createUser(
              username: widget.controllers[4].text,
              firstName: widget.controllers[0].text,
              middleName: widget.controllers[1].text,
              lastName: widget.controllers[2].text,
              phoneNumber: phoneNumber,
              city: widget.controllers[3].text,
            );

            if (result['success']) {
              THelperFunctions.navigateToScreen(
                context,
                EmailVerificationScreen(email: widget.controllers[4].text),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(result['message'])),
              );
            }

            setState(() {
              isLoading = false;
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: THelperFunctions.isDarkMode(context) ? TColors.light : TColors.dark,
          side: const BorderSide(color: Colors.grey),
        ),
        child: isLoading
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  THelperFunctions.isDarkMode(context) ? TColors.dark : TColors.light,
                ),
              )
            : Text(
                'create account',
                style: TextStyle(
                  color: THelperFunctions.isDarkMode(context) ? TColors.dark : TColors.light,
                ),
              ),
      ),
    );
  }
}
