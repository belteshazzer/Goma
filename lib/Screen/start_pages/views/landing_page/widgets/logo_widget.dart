import 'package:flutter/material.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget ({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(

      child: Text('G-NOTIFY', style: TextStyle(color: THelperFunctions.isDarkMode(context)? Colors.white: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),),
    );
  }
}
