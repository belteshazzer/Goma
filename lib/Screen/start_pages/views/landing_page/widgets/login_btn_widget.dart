import 'package:flutter/material.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../../authentication/view/login/login.dart';

class LogInBtnWidget extends StatelessWidget {
  const LogInBtnWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () =>
            THelperFunctions.navigateToScreen(context, const LoginScreen()),
        child: const Text('Log In',
            style: TextStyle(
                color: TColors.textWhite,
                fontWeight: FontWeight.w300,
                fontSize: TSizes.fontSizeMd,
                fontFamily: 'poppins')));
  }
}
