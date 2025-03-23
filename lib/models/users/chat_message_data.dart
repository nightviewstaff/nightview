import 'package:nightview/generated/l10n.dart';
import 'package:nightview/main.dart';

class ChatMessageData {
  final String sender;
  final String message;
  final DateTime timestamp;

  ChatMessageData(
      {required this.sender, required this.message, required this.timestamp});

  String getReadableTimestamp() {
    String hour = timestamp.hour.toString().padLeft(2, '0');
    String minute = timestamp.minute.toString().padLeft(2, '0');

    return '${getShortWeekday().toUpperCase()}$hour:$minute';
  }

  String getShortWeekday() {
    int dayToday = DateTime.now().weekday;

    if (dayToday == timestamp.weekday) {
      return '';
    }

    switch (timestamp.weekday) {
      case 1:
        return '${S.of(ourNavigatorKey.currentContext!).short_monday} ';
      case 2:
        return '${S.of(ourNavigatorKey.currentContext!).short_tuesday} ';
      case 3:
        return '${S.of(ourNavigatorKey.currentContext!).short_wednesday} ';
      case 4:
        return '${S.of(ourNavigatorKey.currentContext!).short_thursday} ';
      case 5:
        return '${S.of(ourNavigatorKey.currentContext!).short_friday} ';
      case 6:
        return '${S.of(ourNavigatorKey.currentContext!).short_saturday} ';
      case 7:
        return '${S.of(ourNavigatorKey.currentContext!).short_sunday} ';
    }

    return '';
  }
}
