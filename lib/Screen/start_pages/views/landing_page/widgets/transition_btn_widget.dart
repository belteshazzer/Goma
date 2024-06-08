import 'package:flutter/material.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../../../utils/theme/widget_themes/elevated_button_theme.dart';

class TransitionButton extends StatelessWidget {

  final Widget destination;
  final String lable;
  const TransitionButton({super.key, required this.destination, required this.lable});


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () => THelperFunctions.navigateToScreen(context, destination), style: THelperFunctions.isDarkMode(context)? TElevatedButtonTheme.darkElevatedButtonTheme.style: TElevatedButtonTheme.lightElevatedButtonTheme.style, child: Text(lable, style: const TextStyle(color:Colors.white,)),);
  }
}