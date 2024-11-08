import 'dart:convert';
import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
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
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
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

  // Future<void> initLocalNotifications() async {
  //   AwesomeNotifications().initialize(
  //     'images/logo_icon.png',
  //     [
  //       NotificationChannel(
  //         channelKey: 'nightview_channel',
  //         channelName: 'Nightview Notifications',
  //         channelDescription: 'Used for NV notifications.',
  //         defaultColor: primaryColor,
  //         ledColor: secondaryColor,
  //         importance: NotificationImportance.Default,
  //       )
  //     ],
  //   );

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

  void scheduleWeeklyNotifications() {
    List<String> messages = [
      "Er du klar til at erobre dansegulvet i nat?",
      "Har du planer om at tage på eventyr i byen i aften?",
      "Skal vi ud og lave ballade i nat?",
      "Bliver det en af de vilde aftener i byen i aften?",
      "Er det en af de aftener, hvor vi slår os løs?",
      "Skal vi ud og vise vores bedste moves i aften?",
      "Er du på vej ud for at gøre byen usikker i nat?",
      "Jeg kender en rigtig god bartender. Skal vi tage ud og få ham til at lave nogle specielle drinks til os?",
      "Vil du være min date i aften og lade mig vise dig hvordan man har det sjovt?",
      "Hvad siger du til at vi spilder ungdommen lidt i aften og ser hvor det bringer os hen?",
      "Er du klar til at lyse dansegulvet op i aften?",
      "Har du planer om at skabe minder i byen i nat?",
      "Er det en af de aftener, hvor vi giver den max gas?",
      "Skal vi ud og gøre natten vild og uforglemmelig?",
      "Er du parat til at indtage byen med stil?",
      "Bliver det en nat med masser af latter og dans?",
      "Er du klar til at erobre byen og have det sjovt?",
      "Skal vi ud og gøre natten til vores egen fest?",
      "Er det en af de aftener, hvor vi slipper alle hæmninger?",
      "Har du tænkt dig at tage på natteeventyr med os i aften?",
      "Er det i aften, vi gør gaderne usikre?",
      "Skal vi ud og skabe feststemning i nat?",
      "Er du klar til at gøre natten til noget særligt?",
      "Bliver det en af de aftener, hvor vi lever livet fuldt ud?",
      "Skal vi ud og feste som aldrig før i nat?",
      "Er du klar til at indtage nattelivet med os?",
      "Har du tænkt dig at gøre natten vild og uforglemmelig?",
      "Er du klar til at gøre dansegulvet til din scene i aften?",
      "Skal vi ud og få byen til at lyse op i nat?",
      "Er det i aften, vi går amok på dansegulvet?",
      "Har du tænkt dig at være festens midtpunkt i nat?",
      "Er du parat til en nat fyldt med grin og gode vibes?",
      "Er du klar til at tage byen med storm i aften?",
      "Er du klar til at skabe vilde minder i nat?",
      "Er du parat til at gøre natten til en fest uden lige?",
      "Skal vi ud og fyre den af på dansegulvet?",
      "Er du klar til at gøre byen usikker med os i nat?",
      "Har du planer om at tage på eventyr i nattelivet?",
      "Skal vi ud og erobre nattelivet i aften?",
      "Skal vi ud og lege rockstjerner i nat?",
      "Er du klar til at danse, som om vi har to venstre fødder?",
      "Er det i aften, vi laver nogle episke Snapchat-historier?",
      "Er du klar til at være byens skøreste festabe i nat?",
      "Skal vi ud og lave nogle legendariske fejltrin på dansegulvet?",
      "Skal vi ud og se, hvor mange nye venner vi kan få i nat?",
      "Er du klar til at tage en tur i festligaen i nat?",
      "Ud i aften?",
      "Skal vi?",
      "Ud og fyre den af?",
      "Druk?",
      "Skal vi ud?",
      "Klubben?",
      "Er du klar til at skabe ravage i byen i aften?",
      "Skal vi ud og skabe lidt festlig uro i byen?",
      "Skal vi ud og ryste byen op?",
      "Er det tid til at lave noget ballade i nat?",
      "Bliver du en del af nattelivet i dag?",
      "Har du planer om at gå ud i aften?",
      "Er du klar til en bytur i dag?",
    ];

    final rng = Random();
    for (int i = 0; i < 3; i++) {
      // Thursday, Friday, Saturday
      for (int j = 0; j < 10; j++) {
        final int weekday = i + 4; // 4=Thursday, 5=Friday, 6=Saturday
        final DateTime now = DateTime.now();
        final DateTime scheduledDate = DateTime(
          now.year,
          now.month,
          now.day,
          15,
        ).add(Duration(days: (weekday - now.weekday) % 7));

        // scheduleNotification( TODO
        //   id: i * 10 + j,
        //   title: '',
        //   body: messages[rng.nextInt(messages.length)],
        //   scheduledDate: scheduledDate,
        // );
      }
    }
  }

}
