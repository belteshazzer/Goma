import 'dart:async';
import 'package:flutter/material.dart';
import 'package:goma/Screen/api_path.dart';
import 'package:goma/Screen/notification/notification.dart';
import 'package:goma/Screen/user_account/account.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  var user;


  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('ownerId');
      _userToken = prefs.getString('accessToken') ?? '';
    });

    final url = Uri.parse("$AuthenticationUrl/users/in/create/$_userId");
    final http.Response response = await http.get(url,headers: {"Authorization": "JWT $_userToken"});

    print("response.body ${response.body} ${response.statusCode}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      user = responseData;
    } else {
      // Handle the case when the status code is not 200
      print("failed");
    }

  }

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
    _loadUserData();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!_isUserInteracting) {
        final double maxScrollExtent =
            _scrollController.position.maxScrollExtent;
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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Column(
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
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationListPage()),
                            );
                          },
                          icon: Icon(Icons.notifications_active,
                              size: 45, color: Colors.grey[800])),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SettingsPage2()),
                            );
                          },
                          icon: Icon(Icons.person,
                              size: 45, color: Colors.grey[800])),
                    
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
                    "Welcome ${user['first_name']},",
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
            )
          ],
        ),
      ),
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
        color: Colors.black,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 1,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 100,
            color: Colors.blue,
          ),
          const SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                statement,
                style: const TextStyle(fontSize: 15, color: Colors.white),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Button action
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Less curved
                  ),
                ),
                child: const Text('Pay Now'),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
}
