import 'package:flutter/material.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/helpers/helper_functions.dart';
import '../../../../../../utils/theme/widget_themes/text_theme.dart';
import '../../../login/login.dart';

class HaveAccount extends StatelessWidget {
  const HaveAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Already have an Account?',
          style: THelperFunctions.isDarkMode(context)
              ? TTextTheme.darkTextTheme.bodyMedium
              : TTextTheme.lightTextTheme.bodyMedium,
        ),
        TextButton(
            onPressed: () =>
                THelperFunctions.navigateToScreen(context, const LoginScreen()),
            child: Text(
              'Login',
              style: TextStyle(
                  color: THelperFunctions.isDarkMode(context)
                      ? TColors.white
                      : TColors.dark,
                  fontFamily: 'Poppins',
                  fontSize: TSizes.fontSizeSm
                  ,decoration: TextDecoration.underline),
            )),
      ],
    );
  }
}
