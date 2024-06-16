import 'package:flutter/material.dart';
import 'package:goma/utils/constants/colors.dart';
import 'package:goma/utils/constants/sizes.dart';
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
final isDarkMode = THelperFunctions.isDarkMode(context);
final titleColor = isDarkMode ? TColors.dark : TColors.light;
final subTitleColor = isDarkMode ? TColors.darkGrey : TColors.lightGrey;
    return Card(
      color:  isDarkMode ? TColors.light : TColors.dark,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child:  ListTile( 
        minTileHeight: 40.0,
        title: Text(title, style: TextStyle(color: titleColor),),
        subtitle: Text(description, style: TextStyle(color: subTitleColor,fontSize: 12)),
        onTap: () {THelperFunctions.navigateToScreen(context,   vehicleSelectionPage);}
      ),
    );
  }
}