import 'package:flutter/material.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../../utils/theme/widget_themes/text_theme.dart';

class PaymentTypeCards extends StatelessWidget {
  final String title;
  final String description;

  const PaymentTypeCards({super.key, required this.title, required this.description});
  
  @override
  Widget build(BuildContext context) {
  final textTheme = THelperFunctions.isDarkMode(context)? TTextTheme.darkTextTheme : TTextTheme.lightTextTheme;

    return Card(
      color: const Color.fromRGBO(0, 58, 145, 1),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: textTheme.headlineMedium,
                  ),
                ),
                Text(
                  description,
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}