import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;

import '../../utils/constants/colors.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LatLng initialCenter = const LatLng(9.033849, 38.763629);

  // Predefined locations within a 50 km radius
  final List<LatLng> inspectionCenters = [
    const LatLng(9.037027, 38.764305),
    const LatLng(9.036339, 38.761879),
    const LatLng(9.033096, 38.761998),
    const LatLng(9.031719, 38.762491),
    const LatLng(9.032899, 38.766220),
    const LatLng(9.045000, 38.755000),
    const LatLng(9.025000, 38.775000),
    const LatLng(9.050000, 38.750000),
    const LatLng(9.020000, 38.780000),
    const LatLng(9.055000, 38.745000),
  ];

  List<String> inspectionCenterNames = [
    'Abebe',
    'Bekele',
    'Chaltu',
    'Dawit',
    'Eshetu',
    'Fikre',
    'Girma',
    'Hanna',
    'Ibrahim',
    'Jemal',
  ];

  String getRandomSuffix() {
    return math.Random().nextBool() ? "Bolo Inspection" : "Vehicle Inspection";
  }

  @override
  Widget build(BuildContext context) {
    final List<String> namedInspectionCenters =
        List.generate(inspectionCenterNames.length, (index) {
      return '${inspectionCenterNames[index]} ${getRandomSuffix()}';
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Map Screen')),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: initialCenter,
              initialZoom: 16.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: initialCenter,
                    child: const Icon(
                      Icons.location_on,
                      size: 30,
                      color: Colors.blue,
                    ),
                  ),
                  ...List.generate(inspectionCenters.length, (index) {
                    return Marker(
                      width: 80.0,
                      height: 80.0,
                      point: inspectionCenters[index],
                      child: Column(
                        children: [
                          const Icon(
                            Icons.car_repair,
                            size: 20,
                            color: TColors.dark,
                          ),
                          Text(
                            namedInspectionCenters[index],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 8,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
