import 'package:flutter/material.dart';
import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:animated_list_plus/transitions.dart';
import 'package:goma/Screen/vehicle/vehicle_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../authentication/controllers/SignInController/get_vehicle.dart';

class NotificationListPage extends StatefulWidget {
  const NotificationListPage({super.key});

  @override
  _NotificationListPageState createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  List<Vehicle> vehicles = [];
  List<Notification> _notifications = [];
  String _userToken = '';
  String _ownerId = '';
  bool _isLoading = true;
  String? _error;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _loadUserData();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification(
      int id, String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'vehicle_notifications', // channel id
            'Vehicle Notifications', // channel name
           channelDescription:  'Notifications related to vehicle documents and renewals', // channel description
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        id, title, body, platformChannelSpecifics);
  }

  Future<void> _loadUserData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      _userToken = prefs.getString('accessToken') ?? '';
      _ownerId = prefs.getString('ownerId') ?? '';

      List<Vehicle>? fetchedVehicles =
          await GetVehicle.getVehiclesByOwnerId(_ownerId, _userToken);
      if (fetchedVehicles != null) {
        setState(() {
          vehicles = fetchedVehicles;
        });
        _loadDocumentsForVehicles();
      } else {
        setState(() {
          _error = 'Failed to load vehicles';
        });
      }
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

  Future<void> _loadDocumentsForVehicles() async {
    for (var vehicle in vehicles) {
      // Load documents for each vehicle here and create notifications
      // Dummy data for illustration
      _notifications.addAll([
        Notification(
          title: 'Insurance Renewal',
          description: 'Your insurance needs to be renewed.',
          date: '2024-06-25',
        ),
        Notification(
          title: 'Road Tax Renewal',
          description: 'Your road tax needs to be renewed.',
          date: '2024-07-05',
        ),
      ]);
    }
    _checkNotificationDueDates();
  }

  void _checkNotificationDueDates() {
    DateTime now = DateTime.now();
    for (var notification in _notifications) {
      DateTime dueDate = DateTime.parse(notification.date);
      int daysLeft = dueDate.difference(now).inDays;

      if (daysLeft == 15 || daysLeft == 7 || daysLeft == 3) {
        _showNotification(
          _notifications.indexOf(notification),
          notification.title,
          '${notification.description} You have $daysLeft days left.',
        );
      }
    }
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
  }

  void _removeNotification(int index) {
    if (index < 0 || index >= _notifications.length) return;
    final removedItem = _notifications.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => SizeFadeTransition(
        sizeFraction: 0.7,
        curve: Curves.easeInOut,
        animation: animation,
        child: _buildNotificationItem(removedItem, index),
      ),
    );
  }

  Widget _buildNotificationItem(Notification notification, int index) {
    return ListTile(
      tileColor: notification.isRead ? Colors.grey[200] : Colors.white,
      title: Text(notification.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(notification.description),
          const SizedBox(height: 5),
          Text(
            notification.date,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
      trailing: notification.isRead
          ? IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _removeNotification(index);
              },
            )
          : null,
      onTap: () {
        setState(() {
          notification.isRead = true;
        });
        _navigateToPaymentPage(notification);
      },
    );
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.mark_email_read),
              title: const Text('Mark all as read'),
              onTap: () {
                Navigator.pop(context);
                _markAllAsRead();
              },
            ),
            // Add more options here
          ],
        );
      },
    );
  }

  void _navigateToPaymentPage(Notification notification) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(notification: notification),
      ),
    );
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
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: _showOptionsMenu,
                    icon: const Icon(Icons.more_vert, size: 30, color: Colors.black),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Notification list
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _isLoading
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Container(
                                width: double.infinity,
                                height: 20.0,
                                color: Colors.white,
                              ),
                              subtitle: Container(
                                width: double.infinity,
                                height: 14.0,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      )
                    : ImplicitlyAnimatedList<Notification>(
                        key: _listKey,
                        items: _notifications,
                        areItemsTheSame: (a, b) => a.title == b.title,
                        itemBuilder: (context, animation, item, index) {
                          return SizeFadeTransition(
                            sizeFraction: 0.7,
                            curve: Curves.easeInOut,
                            animation: animation,
                            child: _buildNotificationItem(item, index),
                          );
                        },
                        removeItemBuilder: (context, animation, oldItem) {
                          return SizeFadeTransition(
                            sizeFraction: 0.7,
                            curve: Curves.easeInOut,
                            animation: animation,
                            child: _buildNotificationItem(
                                oldItem, _notifications.indexOf(oldItem)),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentPage extends StatelessWidget {
  final Notification notification;

  const PaymentPage({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Pay Now'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                notification.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                notification.description,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Due Date: ${notification.date}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Payment action
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, // Button color
                  backgroundColor: Colors.black, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 16.0),
                ),
                child: const Text(
                  'Pay Now',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Notification {
  String title;
  String description;
  String date;
  bool isRead;

  Notification({
    required this.title,
    required this.description,
    required this.date,
    this.isRead = false,
  });
}
