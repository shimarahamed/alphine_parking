import 'package:firebase_messaging/firebase_messaging.dart';

class FCMHandler {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void initialize() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // Handle when the app is in the foreground
      print("onMessage: ${message.data}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      // Handle when the app is terminated, and the user taps the notification
      print("onLaunch: ${message.data}");
    });

    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      // Handle when the app is in the background, and the user taps the notification
      print("onResume: ${message.data}");
    });
  }

  void subscribeToTopic(String topic) {
    _firebaseMessaging.subscribeToTopic(topic);
  }
}
