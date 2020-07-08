import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsService {
  Future<String> subscribeForNotifications() async {
    final firebaseMessaging = FirebaseMessaging();
    final request = firebaseMessaging.requestNotificationPermissions();
    if (request != null) {
      final result = await request;
      if (!result) {
        return null;
      }
    }
    firebaseMessaging.configure();
    final token = await firebaseMessaging.getToken();
    return token;
  }

  Future<void> unsubscribeFromNotifications() async {
    final firebaseMessaging = FirebaseMessaging();
    await firebaseMessaging.deleteInstanceID();
  }
}
