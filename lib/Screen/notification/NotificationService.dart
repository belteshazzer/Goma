import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_path.dart';
import 'notification_model.dart';

class NotificationService {
  static Future<List<NotificationItem>> fetchAndShowNotifications(String ownerId, String userToken) async {
    print("fetching notifications user token $userToken");
    final response = await http.get(
      Uri.parse('$AuthenticationUrl/notifications/'),
      headers: {"Authorization": "JWT $userToken"},
    );

    print("fetching notifications ${response.body.toString()} ${response.statusCode}");
    List<NotificationItem> notificationItems = [];

    if (response.statusCode == 200) {
      List<dynamic> notifications = jsonDecode(response.body);

      for (var notification in notifications) {
        int notificationId = generateId(notification['id']);
        notificationItems.add(NotificationItem.fromJson(notification));
      }
    } else {
      print('Failed to fetch notifications. Status Code: ${response.statusCode}');
    }

    return notificationItems;
  }

  static int generateId(String id) {
    return id.hashCode;
  }
}
