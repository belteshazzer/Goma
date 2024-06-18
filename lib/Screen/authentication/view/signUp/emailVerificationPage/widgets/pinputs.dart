import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/helpers/helper_functions.dart';
import '../../../../controllers/SignUpController/emailVerificationController.dart';
import '../../setPasswordPage/setPassword.dart';

class Pinputs extends StatefulWidget {
  final String username;
  const Pinputs({required this.username, super.key});

  @override
  State<Pinputs> createState() => _PinputsState();
}

class _PinputsState extends State<Pinputs> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  bool isVerified = false;
  bool isLoading = false;
  bool showError = false;

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = Color.fromRGBO(27, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = TColors.white;

    final defaultPinTheme = PinTheme(
      width: 46,
      height: 46,
      textStyle: const TextStyle(
        fontSize: 22,
        color: TColors.white,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
    );

    return Stack(
      children: [
        Form(
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
                  separatorBuilder: (index) => const SizedBox(width: 8),
                  validator: (value) {
                    if (showError) {
                      return 'Invalid pin';
                    }
                    return null;
                  },
                  hapticFeedbackType: HapticFeedbackType.lightImpact,
                  onChanged: (value) async {
                    if (value.length == 6) {
                      setState(() {
                        isLoading = true;
                        showError = false;
                      });
                      bool verified = await _checkFormValidation(widget.username, int.parse(value));
                      setState(() {
                        isLoading = false;
                        showError = !verified;
                      });
                      formKey.currentState?.validate();
                    }
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
                      borderRadius: BorderRadius.circular(10),
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
        ),
        if (isLoading)
          Container(
            color: Colors.black54,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  Future<bool> _checkFormValidation(String username, int pin) async {
    bool isVerified = await EmailVerificationController.verifyEmail(username, pin);
    if (isVerified) {
      THelperFunctions.navigateToScreen(context, PasswordScreen(username: widget.username));
    }
    return isVerified;
  }
}
