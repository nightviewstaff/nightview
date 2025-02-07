import '../../models/clubs/club_data.dart';
import 'package:intl/intl.dart';

class ClubOpeningHoursFormatter {
  /// Formats the opening hours for the current day.
  static String displayClubOpeningHoursFormatted(ClubData? club) {
    if (club == null || club.openingHours == null || club.openingHours.isEmpty) {
      return "Ingen åbningstider"; // No opening hours available
    }

    String weekday = _getCurrentWeekday();
    var todayHours = club.openingHours[weekday];

    if (todayHours == null || todayHours.isEmpty) {
      return "Lukket i dag"; // Closed if no hours for today
    }

    String? openTime = todayHours['open'];
    String? closeTime = todayHours['close'];

    if (openTime == null || closeTime == null) {
      return "Åbningstider ukendte"; // Unknown opening hours
    }

    return "$openTime - $closeTime";
  }

  /// Checks if a club is open at the current time.
  static bool isClubOpen(ClubData? club) {
    if (club == null || club.openingHours == null || club.openingHours.isEmpty) {
      return false; // Assume closed if no club or opening hours available
    }

    String weekday = _getCurrentWeekday();
    var todayHours = club.openingHours[weekday];

    if (todayHours == null || todayHours.isEmpty) {
      return false; // Closed if no hours for today
    }

    String? openTimeStr = todayHours['open'];
    String? closeTimeStr = todayHours['close'];

    if (openTimeStr == null || closeTimeStr == null) {
      return false; // Closed if open/close times are missing
    }

    DateTime now = DateTime.now();
    DateTime? openTime = _parseTime(openTimeStr);
    DateTime? closeTime = _parseTime(closeTimeStr);

    if (openTime == null || closeTime == null) {
      return false; // Closed if parsing fails
    }

    return now.isAfter(openTime) && now.isBefore(closeTime);
  }

  /// Parses a time string into a `DateTime` object. Returns `null` on invalid input.
  static DateTime? _parseTime(String? timeStr) {
    if (timeStr == null || !timeStr.contains(":")) {
      return null; // Invalid time format
    }

    try {
      List<String> parts = timeStr.split(":");
      int hour = int.parse(parts[0]);
      int minute = parts.length > 1 ? int.parse(parts[1]) : 0;
      return DateTime.now().copyWith(hour: hour, minute: minute);
    } catch (e) {
      return null; // Return null if parsing fails
    }
  }

  /// Gets the current weekday in lowercase (e.g., "mon", "tue").
  static String _getCurrentWeekday() {
    return ["mon", "tue", "wed", "thu", "fri", "sat", "sun"][DateTime.now().weekday - 1];
  }

  static String formatOpeningHours(ClubData club) { // Should be removed
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
