import '../../models/clubs/club_data.dart';
import 'package:intl/intl.dart' show DateFormat;

class ClubOpeningHoursFormatter {
  static String displayClubOpeningHoursFormatted(ClubData club) {
    return formatOpeningHours(club);
  }

  static String formatOpeningHours(ClubData club) {
    final String currentWeekday =
        DateFormat('EEEE').format(DateTime.now()).toLowerCase();
    final Map<String, dynamic>? todayHours = club.openingHours[currentWeekday];

    if (todayHours == null || todayHours.isEmpty) {
      return 'Lukket i dag.';
    }

    final String openTime = todayHours['open'] ?? 'Ukendt'; // Default 'Ukendt'
    final String closeTime = todayHours['close'] ?? 'Ukendt';

    return '$openTime - $closeTime i dag.';
  }
}
