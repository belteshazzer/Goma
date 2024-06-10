import 'package:flutter/material.dart';
import 'package:goma/Screen/home/home.dart';
import 'package:goma/Screen/notification/notification.dart';
import 'package:goma/common/bar/widget/bottomNavBar.dart';

import '../../Screen/vehicle/vehicle_page.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavigationBar_OutputState createState() =>
      _BottomNavigationBar_OutputState();
}

class _BottomNavigationBar_OutputState extends State<BottomNavBar> {
  int currentIndex = 0;
  final screens = [
    const HomePage(),
    const NotificationListPage(),
    const VehicleListPage()
  ];

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBarCurved(
        currentIndex: currentIndex,
        onTabTapped: onTabTapped,
      ),
    );
  }
}
