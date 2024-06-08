import 'package:flutter/material.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget ({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 150,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(THelperFunctions.isDarkMode(context)? TImages.darkAppLogo:TImages.lightAppLogo,),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
