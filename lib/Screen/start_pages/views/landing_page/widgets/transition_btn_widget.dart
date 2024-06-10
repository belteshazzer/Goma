import 'package:flutter/material.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../../../utils/theme/widget_themes/elevated_button_theme.dart';

class TransitionButton extends StatelessWidget {
  final Widget destination;
  final String label;

  const TransitionButton({super.key, required this.destination, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: ElevatedButton(
        onPressed: () => THelperFunctions.navigateToScreen(context, destination),
        style: ElevatedButton.styleFrom(
          foregroundColor: THelperFunctions.isDarkMode(context)
              ? TElevatedButtonTheme.darkElevatedButtonTheme.style?.backgroundColor?.resolve({})
              : TElevatedButtonTheme.lightElevatedButtonTheme.style?.backgroundColor?.resolve({}),
            backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Set the desired border radius here
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
