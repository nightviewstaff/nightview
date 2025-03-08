import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class SMSHelper {
  static Future<bool> launchSMS(
      {required String phoneNumber, required String message}) async {
    late String uriString;

    if (Platform.isAndroid) {
      uriString = 'sms:$phoneNumber?body=$message';
    }

    if (Platform.isIOS) {
      uriString = 'sms:$phoneNumber&body=$message';
    }

    Uri uri = Uri.parse(uriString);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      return true;
    } else {
      return false;
    }
  }
}
