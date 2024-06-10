import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:goma/Screen/api_path.dart';
import 'package:goma/Screen/notification/notification_model.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static Future<List<NotificationItem>> fetchAndShowNotifications(String ownerId, String userToken) async {
    print("fetching notifications user token $userToken");
    final response = await http.get(Uri.parse('$AuthenticationUrl/notifications/'), headers: {"Authorization": "JWT $userToken"});

    print("fetching notifications ${response.body.toString()} ${response.statusCode}");
    List<NotificationItem> notificationItems = [];

    if (response.statusCode == 200) {
      List<dynamic> notifications = jsonDecode(response.body);

      for (var notification in notifications) {
        int notificationId = generateId(notification['id']);
        showNotification(
          notificationId,
          notification['message_content'],
          notification['notification_type'],
        );

        notificationItems.add(NotificationItem.fromJson(notification));
      }
    } else {
      print('Failed to fetch notifications. Status Code: ${response.statusCode}');
    }

    return notificationItems;
  }

  static void showNotification(int id, String title, String body) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: title,
        body: body,
      ),
    );
  }

  static int generateId(String id) {
    return id.hashCode;
  }
}
