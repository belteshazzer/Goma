import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
 import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'NotificationService.dart';
import 'notification_model.dart';

class NotificationListPage extends StatefulWidget {
  const NotificationListPage({super.key});

  @override
  _NotificationListPageState createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  List<NotificationItem> _notifications = [];
  String _userToken = '';
  String _ownerId = '';
  bool _isLoading = true;
  String? _error;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _loadUserData();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _loadUserData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      _userToken = prefs.getString('accessToken') ?? '';
      _ownerId = prefs.getString('ownerId') ?? '';
      print('id and token $_ownerId $_userToken');
      _notifications = await NotificationService.fetchAndShowNotifications(_ownerId, _userToken);
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom app bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back, size: 30, color: Colors.black),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Notifications",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert, size: 30, color: Colors.black),
                  ),
                ],
              ),
            ),
            // Notification list
            Expanded(
              child: _isLoading
                  ? Center(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: ListView.builder(
                          itemCount: 6,
                          itemBuilder: (_, __) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              height: 80,
                            ),
                          ),
                        ),
                      ),
                    )
                  : _notifications.isEmpty
                      ? Center(
                          child: _error != null
                              ? Text('Error: $_error')
                              : const Text('No notifications'),
                        )
                      : ListView.builder(
                          itemCount: _notifications.length,
                          itemBuilder: (context, index) {
                            final notification = _notifications[index];
                            return ListTile(
                              title: Text(notification.document.documentType),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${notification.notificationType} - ${notification.messageContent}"),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Expire date : ${notification.document.expiryDate}",
                                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              ),
                              trailing: notification.seen
                                  ? IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          _notifications.removeAt(index);
                                        });
                                      },
                                    )
                                  : null,
                              onTap: () {
                                setState(() {
                                  notification.seen = true;
                                });
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
