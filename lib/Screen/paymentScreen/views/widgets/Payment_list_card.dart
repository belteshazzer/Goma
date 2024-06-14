import 'package:flutter/material.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../../utils/theme/widget_themes/text_theme.dart';
import '../vehicle_selections.dart';

class PaymentTypeCards extends StatelessWidget {
  final String title;
  final String description;
  final Widget vehicleSelectionPage;

  const PaymentTypeCards({super.key, required this.title, required this.description, required this.vehicleSelectionPage});
  
  @override
  Widget build(BuildContext context) {
  final textTheme = THelperFunctions.isDarkMode(context)? TTextTheme.darkTextTheme : TTextTheme.lightTextTheme;

    return Card(
      color: const Color.fromRGBO(0, 58, 145, 1),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child:  ListTile( 
        minTileHeight: 40.0,
        title: Text(title),
        subtitle: Text(description),
        onTap: () {THelperFunctions.navigateToScreen(context,   vehicleSelectionPage);}
      ),
    );
  }
}