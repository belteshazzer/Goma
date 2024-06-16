import 'package:flutter/material.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class DarkBgButtonWidget extends StatelessWidget {
  const DarkBgButtonWidget({super.key,this.screen, this.text});

  final dynamic screen;
  final  text;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: ElevatedButton(
          onPressed: () =>
              THelperFunctions.navigateToScreen(context,screen),
          style: ElevatedButton.styleFrom(
            backgroundColor: THelperFunctions.isDarkMode(context) ? TColors.dark : TColors.light,
            side:  BorderSide(color: THelperFunctions.isDarkMode(context) ? TColors.light : TColors.dark)
          ),
          child:  Text(text,style: TextStyle(color: THelperFunctions.isDarkMode(context) ? TColors.light : TColors.dark))
          
          ),
    );
  }
}
