import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsService {
  Future<String> subscribeForNotifications() async {
    final firebaseMessaging = FirebaseMessaging.instance;

    final request = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (request.authorizationStatus != AuthorizationStatus.authorized) {
      return null;
    }

    final token = await firebaseMessaging.getToken();
    return token;
  }

  Future<void> unsubscribeFromNotifications() async {
    final firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging.deleteToken();
  }
}
