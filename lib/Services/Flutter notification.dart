import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi{
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
    print('payload: ${message.data}');
  }

  Future<void> initNotifactions() async{
    await _firebaseMessaging.requestPermission();
    final FCMToken = await _firebaseMessaging.getToken();
    print('Token: $FCMToken');
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }


}