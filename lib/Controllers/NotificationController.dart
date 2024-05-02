import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
      final FirebaseMessaging _fcm = FirebaseMessaging.instance;
      final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      Future<void> initialise() async {
            // Request permission to send notifications
            NotificationSettings settings = await _fcm.requestPermission(
                  alert: true,
                  announcement: false,
                  badge: true,
                  carPlay: false,
                  criticalAlert: false,
                  provisional: false,
                  sound: true,
            );

            if (settings.authorizationStatus == AuthorizationStatus.authorized) {
                  print('User granted permission for notifications');

                  // Retrieve the device's FCM token
                  String? token = await getDeviceToken();
                  //FireStoreController().addFCMTokenToCollection(token!);

                  _fcm.subscribeToTopic('all');

                  // Handle incoming notifications
                  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
                        print('Received message: ${message.notification?.title}');
                        displayNotification(message);
                  });
            } else {
                  print('User declined or has not accepted permission for notifications');
            }
      }


      Future<String?> getDeviceToken() async {
            try {
                  String? token = await _fcm.getToken();
                  print("For android device token: $token");
                  return token;
            } catch (e) {
                  print("failed to get device token");
                  return null;
            }
      }


      Future<void> onDidReceiveBackgroundNotification(RemoteMessage message) async {
            await displayNotification(message);
      }

      Future<void> onSelectNotification(String? payload) async {
            print('Notification tapped with payload: $payload');
      }


      Future<void> displayNotification(RemoteMessage message) async {
            var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
                  'your channel id',
                  'your channel name',
                  importance: Importance.max,
                  priority: Priority.high,
            );
            var platformChannelSpecifics =
            NotificationDetails(android: androidPlatformChannelSpecifics);
            await _flutterLocalNotificationsPlugin.show(
                  0,
                  message.notification?.title,
                  message.notification?.body,
                  platformChannelSpecifics,
                  payload: 'item x',
            );
      }
}
