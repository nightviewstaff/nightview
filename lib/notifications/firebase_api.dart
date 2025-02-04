import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';

// import 'package:nightview/constants/colors.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> backgroundHandler(RemoteMessage msg) async {
    print('title: ${msg.notification?.title}');
    print('body: ${msg.notification?.body}');
    print('payload: ${msg.data}');
  }

  void handleMessage(RemoteMessage? msg) {
    if (msg == null) return;

    // navigatorKey.currentState?.value(9){
    // }

    return;
  }

  Future<void> initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);

    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;

      // AwesomeNotifications().createNotification(
      //   content: NotificationContent(
      //     id: message.hashCode,
      //     channelKey: 'nightview_channel',
      //     title: notification.title,
      //     body: notification.body,
      //     payload: {"data": jsonEncode(message.data)},
      //     notificationLayout: NotificationLayout.Default,
      //   ),
      // );
    });
  }

  // Future<void> initLocalNotifications() async { // TODO SOON
  //   AwesomeNotifications().initialize(
  //     'images/logo_icon.png',
  //     [
  //       NotificationChannel(
  //         channelKey: 'nightview_channel',
  //         channelName: 'Nightview Notifications',
  //         channelDescription: 'Used for Nightview notifications.',
  //         defaultColor: primaryColor,
  //         ledColor: secondaryColor,
  //         importance: NotificationImportance.High,
  //         channelShowBadge: true
  //       )
  //     ],
  //   );
  //
  //   Future<void> showInstantNotification({
  //     required int id,
  //     required String title,
  //   }}

  //   AwesomeNotifications().actionStream.listen((notification) {
  //     if (notification.payload != null) {
  //       final message = RemoteMessage.fromMap(
  //         jsonDecode(notification.payload!['data']!),
  //       );
  //       handleMessage(message);
  //     }
  //   });
  // }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');
    await initPushNotification();
    // await initLocalNotifications();
  }

  final rng = Random();
// for (int i = 0; i < 3; i++) {
// Thursday, Friday, Saturday
// for (int j = 0; j < 10; j++) {
//   final int weekday = i + 4; // 4=Thursday, 5=Friday, 6=Saturday
//   final DateTime now = DateTime.now();
//   final DateTime scheduledDate = DateTime(
//     now.year,
//     now.month,
//     now.day,
//     15,
//   ).add(Duration(days: (weekday - now.weekday) % 7));

// scheduleNotification( TODO
//   id: i * 10 + j,
//   title: '',
//   body: messages[rng.nextInt(messages.length)],
//   scheduledDate: scheduledDate,
// );
}
