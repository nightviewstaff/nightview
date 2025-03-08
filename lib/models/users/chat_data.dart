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
        return 'Man ';
      case 2:
        return 'Tir ';
      case 3:
        return 'Ons ';
      case 4:
        return 'Tor ';
      case 5:
        return 'Fre ';
      case 6:
        return 'Lør ';
      case 7:
        return 'Søn ';
    }
    return '';
  }
}
