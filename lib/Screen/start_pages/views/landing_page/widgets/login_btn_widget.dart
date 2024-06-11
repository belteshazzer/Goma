import 'package:flutter/material.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class DarkBgButtonWidget extends StatelessWidget {
  const DarkBgButtonWidget({super.key,this.screen, this.text});

  final dynamic screen;
  final  text;


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () =>
            THelperFunctions.navigateToScreen(context,screen),
        style: ElevatedButton.styleFrom(

          backgroundColor: THelperFunctions.isDarkMode(context)
          ? TColors.black : TColors.light,
          side: const BorderSide(color: TColors.grey)
        ),
        child:  Text(text,style:THelperFunctions.isDarkMode(context) ? const TextStyle(color: Colors.white):const TextStyle(color: Colors.black)),
        
        );
  }
}
