import 'dart:async';
import 'package:flutter/material.dart';
import 'package:goma/Screen/api_path.dart';
import 'package:goma/Screen/map/map.dart';
import 'package:goma/Screen/notification/notification.dart';
import 'package:goma/Screen/setting/account.dart';
import 'package:goma/utils/helpers/helper_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shimmer/shimmer.dart';

import '../../utils/constants/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  final ScrollController _scrollController = ScrollController();
  Timer? _timer;
  bool _isUserInteracting = false;

  String? _userId;
  String _userToken = '';
  Map<String, dynamic>? user;
  late Future<void> _futureUserData;

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('ownerId');
    _userToken = prefs.getString('accessToken') ?? '';

    final url = Uri.parse("$AuthenticationUrl/users/in/create/$_userId/");
    final http.Response response = await http.get(url, headers: {"Authorization": "JWT $_userToken"});
    
    print("response ${response.body} ${response.statusCode}");
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      setState(() {
        user = responseData;
      });
    } else {
      // Handle the case when the status code is not 200
      print("failed");
    }
  }

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
    _futureUserData = _loadUserData();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!_isUserInteracting) {
        final double maxScrollExtent = _scrollController.position.maxScrollExtent;
        final double pixels = _scrollController.position.pixels;
        if (pixels + 200 >= maxScrollExtent) {
          _scrollController.animateTo(0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.linear);
        } else {
          _scrollController.animateTo(pixels + 200,
              duration: const Duration(seconds: 1), curve: Curves.linear);
        }
      }
    });
  }

  void _stopAutoScroll() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = THelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: isDarkMode ? TColors.dark : TColors.light,
      body: SafeArea(
        child: FutureBuilder<void>(
          future: _futureUserData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerEffect();
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Stack(
                children: [
                  _buildMainContent(),
                  if (snapshot.connectionState == ConnectionState.waiting)
                    _buildShimmerEffect(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("G-NOTIFY"),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NotificationListPage()),
                      );
                    },
                    child: Icon(
                      Icons.notifications_active,
                      size: 45,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsPage2()),
                      );
                    },
                    child: Icon(
                      Icons.person,
                      size: 45,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome ${user?['first_name']},",
                style: TextStyle(fontSize: 20, color: Colors.grey.shade800),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: Divider(
            thickness: 1,
            color: Color.fromARGB(255, 204, 204, 204),
          ),
        ),
        const SizedBox(height: 25),
        Container(
          height: 200,
          color: Colors.white,
          child: GestureDetector(
            onPanDown: (_) {
              setState(() {
                _isUserInteracting = true;
                _stopAutoScroll();  
              });
            },
            onPanCancel: () {
              setState(() {
                _isUserInteracting = false;
                _startAutoScroll();
              });
            },
            onPanEnd: (_) {
              setState(() {
                _isUserInteracting = false;
                _startAutoScroll();
              });
            },
            child: ListView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(16.0),
              children: const [
                BuildCard(
                  icon: Icons.policy,
                  statement: 'Insurance Payment',
                ),
                SizedBox(width: 12),
                BuildCard(
                  icon: Icons.money,
                  statement: 'Road Fund Payment',
                ),
                SizedBox(width: 12),
                BuildCard(
                  icon: Icons.car_rental,
                  statement: 'Car Renewal Payment',
                ),
                SizedBox(width: 12),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20), // Add some space before the button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: ElevatedButton(
            onPressed: () {
              // Button action
              THelperFunctions.navigateToScreen(context, MapScreen());
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text('New Action Button'),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerEffect() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 100,
                  height: 20,
                  color: Colors.grey,
                ),
              ),
              Row(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 45,
                      height: 45,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 45,
                      height: 45,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 150,
                  height: 20,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: Divider(
            thickness: 1,
            color: Color.fromARGB(255, 204, 204, 204),
          ),
        ),
        const SizedBox(height: 25),
        Container(
          height: 200,
          color: Colors.white,
          child: ListView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16.0),
            children: List.generate(3, (index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 200,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class BuildCard extends StatelessWidget {
  const BuildCard({super.key, required this.icon, required this.statement});

  final IconData icon;
  final String statement;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white, // Ensure the card is visible with a white background
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 1,
            offset: const Offset(0, 3), // Changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 100,
            color: Colors.blue,
          ),
          const SizedBox(height: 10),
          Text(
            statement,
            style: const TextStyle(fontSize: 15, color: Colors.black),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Button action
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text('Pay Now'),
          ),
        ],
      ),
    );
  }
}
