import 'package:nightview/generated/l10n.dart';
import 'package:nightview/main.dart';

class ChatData {
  final String id;
  final String lastMessage;
  final String lastSender;
  final DateTime lastUpdated;
  final List<String> participants;

  String? title;
  String? lastSenderName;
  String? imageUrl;

  ChatData(
      {required this.id,
      required this.lastMessage,
      required this.lastSender,
      required this.lastUpdated,
      required this.participants});

  String getReadableTimestamp() {
    String hour = lastUpdated.hour.toString().padLeft(2, '0');
    String minute = lastUpdated.minute.toString().padLeft(2, '0');

    return '${getShortWeekday()}$hour:$minute';
  }

  String getShortWeekday() {
    int dayToday = DateTime.now().weekday;

    if (dayToday == lastUpdated.weekday) {
      return '';
    }

    switch (lastUpdated.weekday) {
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
