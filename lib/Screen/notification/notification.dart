import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../main.dart';
import 'NotificationService.dart';
import 'notification_model.dart';

class NotificationListPage extends StatefulWidget {
  const NotificationListPage({super.key});

  @override
  _NotificationListPageState createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  late FirebaseMessaging _messaging;
  List<NotificationItem> _notifications = [];
  String _userToken = '';
  String _ownerId = '';
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _setupFirebaseMessaging();
  }

  @override
  void dispose() {
    super.dispose();
  }

Future<void> _setupFirebaseMessaging() async {
  _messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await _messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message while in the foreground!');
      if (!mounted) return;

      // Show a local notification
      NotificationHelper.showNotification(message);

      final data = message.data;
      setState(() {
        _notifications.add(
          NotificationItem(
            id: data['id'] ?? '',
            messageContent: message.notification?.body ?? '',
            notificationType: data['type'] ?? 'Unknown',
            priorityLevel: data['priorityLevel'] ?? 'Normal',
            seen: data['seen'] == true,
            document: Document(
              id: data['documentId'] ?? '',
              documentType: data['documentType'] ?? '',
              renewalStatus: data['renewalStatus'] == true,
              renewalDate: data['renewalDate'] ?? '',
              expiryDate: data['expiryDate'] ?? '',
              vehicle: Vehicle.fromJson(data['vehicle'] ?? {}),
            ),
          ),
        );
      });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked!');
      // Handle the notification tap
    });

    String? token = await _messaging.getToken();
    print("Firebase Messaging Token: $token");
    // Save token to your backend if necessary
  } else {
    print('User declined or has not accepted permission');
  }
}


  Future<void> _loadUserData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      _userToken = prefs.getString('accessToken') ?? '';
      _ownerId = prefs.getString('ownerId') ?? '';
      print('id and token $_ownerId $_userToken');
      _notifications = await NotificationService.fetchAndShowNotifications(_ownerId, _userToken);
    } catch (e) {
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (!mounted) return; // Check if the widget is still mounted
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
