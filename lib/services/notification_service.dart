import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:younifirst_app/models/notification_model.dart';

class NotificationService {
  static const String _notificationsKey = 'notifications';

  static Future<void> addNotification(String title, String message) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> notificationsJson = prefs.getStringList(_notificationsKey) ?? [];

    NotificationModel notification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      timestamp: DateTime.now(),
    );

    notificationsJson.add(jsonEncode(notification.toJson()));
    await prefs.setStringList(_notificationsKey, notificationsJson);
  }

  static Future<List<NotificationModel>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> notificationsJson = prefs.getStringList(_notificationsKey) ?? [];

    return notificationsJson.map((json) => NotificationModel.fromJson(jsonDecode(json))).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Sort by newest first
  }

  static Future<void> markAsRead(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> notificationsJson = prefs.getStringList(_notificationsKey) ?? [];

    List<NotificationModel> notifications = notificationsJson
        .map((json) => NotificationModel.fromJson(jsonDecode(json)))
        .toList();

    int index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index] = NotificationModel(
        id: notifications[index].id,
        title: notifications[index].title,
        message: notifications[index].message,
        timestamp: notifications[index].timestamp,
        isRead: true,
      );

      List<String> updatedJson = notifications.map((n) => jsonEncode(n.toJson())).toList();
      await prefs.setStringList(_notificationsKey, updatedJson);
    }
  }

  static Future<int> getUnreadCount() async {
    List<NotificationModel> notifications = await getNotifications();
    return notifications.where((n) => !n.isRead).length;
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_notificationsKey);
  }
}