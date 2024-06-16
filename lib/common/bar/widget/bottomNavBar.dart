
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:goma/utils/helpers/helper_functions.dart';

import '../../../utils/constants/colors.dart';

class BottomNavigationBarCurved extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabTapped;

  const BottomNavigationBarCurved({
    super.key,
    required this.currentIndex,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = THelperFunctions.isDarkMode(context);
    return CurvedNavigationBar(
      backgroundColor:isDarkMode ? TColors.dark:TColors.light,  
      animationDuration: const Duration(milliseconds: 300),
      color: Colors.black,
      index: currentIndex,
      onTap: onTabTapped,
      items: const [
        Icon(Icons.home, color: Colors.white),
        Icon(Icons.payment, color: Colors.white),
        Icon(Icons.directions_car, color: Colors.white),
      ],
    );
  }
}

