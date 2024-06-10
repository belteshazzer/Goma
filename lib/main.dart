import 'package:flutter/material.dart';
import 'package:goma/Screen/start_pages/views/splash_screen/splashScreen.dart';
import 'package:goma/common/bar/bar.dart';
import 'Screen/add_vehicle/add_vehicle.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:const SplashScreen(),
      
    );
  }
}

