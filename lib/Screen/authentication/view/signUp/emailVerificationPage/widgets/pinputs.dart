import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../../../../../utils/helpers/helper_functions.dart';
import '../../../../controllers/SignUpController/emailVerificationController.dart';
import '../../setPasswordPage/setPassword.dart';

class pinputs extends StatefulWidget {
  final String username;
  const pinputs({required this.username, super.key});

  @override
  State<pinputs> createState() => _pinputsState();
}

class _pinputsState extends State<pinputs> {
  final pinController= TextEditingController();
  final focusNode=FocusNode();
  final formKey=GlobalKey<FormState>();
  bool isVerified=false;
  int Pin=0;

  @override
  void dispose(){
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }
    @override
  Widget build(BuildContext context) {
    const focusedBorderColor = Color.fromRGBO(27, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Directionality(
            textDirection: TextDirection.ltr, 
            child: Pinput(
              length: 6,
              controller: pinController,
              focusNode: focusNode,
              androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
              listenForMultipleSmsOnAndroid: true,
              defaultPinTheme: defaultPinTheme,
              separatorBuilder: (index) => const SizedBox(width: 8,),
              // onCompleted: (value){
              //   _checkFormValidation(widget.username, int.parse(value));
              // },
              validator: (value) {
                if (isVerified){
                  return null;
                }
                return 'invalid pin';
              },
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              onChanged: (value) {
                debugPrint('onChanged: $value');
                _checkFormValidation(widget.username, int.parse(value));
              },
              cursor: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 9),
                    width: 22,
                    height: 1,
                    color: focusedBorderColor,
                  ),
                ],
              ),
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              submittedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              errorPinTheme: defaultPinTheme.copyBorderWith(
                border: Border.all(color: Colors.redAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> _checkFormValidation(String username, int pin) async {
      print(pin);
      isVerified = await EmailVerificationController.verifyEmail(
        username,
        pin,
      );
      print(isVerified);
      if (isVerified) {
      THelperFunctions.navigateToScreen(context, PasswordScreen(username:widget.username));
      } 
  }
}