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

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      setState(() {
        user = responseData;
      });
    } else {
      print("Failed to load user data");
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
      if (!_isUserInteracting && _scrollController.hasClients) {
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
                  _buildMainContent(isDarkMode),
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

  Widget _buildMainContent(bool isDarkMode) {
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
              const Text("G-NOTIFY", style: TextStyle(fontSize: 16)),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NotificationListPage()),
                      );
                    },
                    child: Icon(
                      Icons.notifications_active,
                      size: 35,
                      color: isDarkMode ? TColors.white : TColors.dark,
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsPage2()),
                      );
                    },
                    child: Icon(
                      Icons.person,
                      size: 35,
                      color: isDarkMode ? TColors.white : TColors.dark,
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
                "Welcome ${user?['first_name'] ?? ''},",
                style: TextStyle(fontSize: 20, color: isDarkMode ? TColors.white : TColors.dark),
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
        Flexible(
          child: Container(
            height: 150,
            color: isDarkMode ? TColors.darkGrey : TColors.lightGrey,
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
                padding: const EdgeInsets.all(8.0),
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
        ),
        const SizedBox(height: 20),
        MapNavigatorCard()
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
        Expanded(
          child: Container(
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
          ),
      ],
    );
  }
}


class BuildCard extends StatelessWidget {
  final IconData icon;
  final String statement;
  final VoidCallback? onPressed;


  const BuildCard({super.key, 
    required this.icon,
    required this.statement,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = THelperFunctions.isDarkMode(context);
    return Card(
      color: isDarkMode ? TColors.dark : TColors.light,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: isDarkMode ? TColors.white : TColors.black,
            ),
            const SizedBox(height: 10),
            Text(
              statement,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (onPressed != null) ...[
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode ? TColors.white : TColors.black,
                  foregroundColor:  isDarkMode ? TColors.black : TColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text('Open Map'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}


class MapNavigatorCard extends StatelessWidget {
  const MapNavigatorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BuildCard(
      icon: Icons.map,
      statement: 'Looking for a car Inspection centers?',
      onPressed: () {
        THelperFunctions.navigateToScreen(context, MapScreen());
      },
    );
  }


}