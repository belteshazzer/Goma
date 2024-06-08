import 'package:flutter/material.dart';
import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:animated_list_plus/transitions.dart';

class Notification {
  final String title;
  final String description;
  final String date;
  bool isRead;

  Notification({
    required this.title,
    required this.description,
    required this.date,
    this.isRead = false,
  });
}

class NotificationListPage extends StatefulWidget {
  const NotificationListPage({super.key});

  @override
  _NotificationListPageState createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  final List<Notification> _notifications = [
    Notification(
      title: "Insurance Payment",
      description: "Your insurance payment is due.",
      date: "2024-06-07",
    ),
    Notification(
      title: "Road Fund Payment",
      description: "Your road fund payment is due.",
      date: "2024-06-08",
    ),
    Notification(
      title: "Car Renewal Payment",
      description: "Your car renewal payment is due.",
      date: "2024-06-09",
    ),
  ];

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

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
                child: ImplicitlyAnimatedList<Notification>(
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
