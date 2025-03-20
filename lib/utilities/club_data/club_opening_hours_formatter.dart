import 'package:intl/intl.dart';
import 'package:nightview/generated/l10n.dart';
import 'package:nightview/main.dart';
import '../../models/clubs/club_data.dart';

class ClubOpeningHoursFormatter {
  // TODO SOME CLOSETIME IS "luk" Take care.
  /// For testing you can override this value.
  static DateTime? now;
  static final String closedTodayString =
      S.of(ourNavigatorKey.currentContext!).closed_today;

  // static final String closedUnknownOpening = "Ukendt Lukkettid i dag.";

  /// Use the overridden time if provided; otherwise, use DateTime.now().
  static DateTime get _now => now ?? DateTime.now();

  /// Returns a nicely formatted string based on whether the club is:
  /// 1. Closed today.
  /// 2. Not open yet (display today's schedule).
  /// 3. Open right now (display remaining open time).
  static String displayClubOpeningHoursFormatted(ClubData? club) {
    // If there are no opening hours defined at all, consider the club closed.
    if (club?.openingHours?.isEmpty ?? true) {
      return closedTodayString;
    }
    // The keys in the openingHours map are expected to be the lower-case weekdays.
    final String todayKey = _getWeekday(_now);
    final String yesterdayKey =
        _getWeekday(_now.subtract(const Duration(days: 1)));

    final Map<String, dynamic>? todayHours = club!.openingHours?[todayKey];
    final Map<String, dynamic>? yesterdayHours =
        club.openingHours?[yesterdayKey];

    // For today’s schedule, if both 'open' and 'close' are missing,
    // we treat it as closed.
    if (todayHours == null ||
        todayHours['open'] == null ||
        todayHours['close'] == null) {
      // It may be that the club was open yesterday (overnight).
      if (yesterdayHours == null ||
          yesterdayHours['open'] == null ||
          yesterdayHours['close'] == null) {
        return closedTodayString;
      }
    }

    // Determine if the club is open right now and from which schedule.
    DateTime? currentOpen;
    DateTime? currentClose;

    // First check if today's schedule applies.
    if (todayHours != null &&
        todayHours['open'] != null &&
        todayHours['close'] != null) {
      final DateTime? openToday = _parseTime(todayHours['open'], _now);
      final DateTime? closeToday = _parseTime(todayHours['close'], _now);
      if (openToday != null && closeToday != null) {
        // If the closing time (on the clock) is before or equal to the opening time,
        // assume the club closes the next day.
        final DateTime actualCloseToday = closeToday.isAfter(openToday)
            ? closeToday
            : closeToday.add(const Duration(days: 1));

        if (_now.isAfter(openToday) && _now.isBefore(actualCloseToday)) {
          currentOpen = openToday;
          currentClose = actualCloseToday;
        }
      }
    }

    // If not open using today's schedule, check yesterday's schedule
    // (for clubs that are open past midnight).
    if (currentClose == null &&
        yesterdayHours != null &&
        yesterdayHours['open'] != null &&
        yesterdayHours['close'] != null) {
      // Use yesterday’s date as the base.
      final DateTime yesterday = _now.subtract(const Duration(days: 1));
      final DateTime? openYesterday =
          _parseTime(yesterdayHours['open'], yesterday);
      final DateTime? closeYesterday =
          _parseTime(yesterdayHours['close'], yesterday);
      if (openYesterday != null && closeYesterday != null) {
        final DateTime actualCloseYesterday =
            closeYesterday.isAfter(openYesterday)
                ? closeYesterday
                : closeYesterday.add(const Duration(days: 1));

        // Now the closing time (actualCloseYesterday) might be on today's date.
        // If _now is between yesterday’s opening and closing times, then the club is still open.
        if (_now.isAfter(openYesterday) &&
            _now.isBefore(actualCloseYesterday)) {
          currentOpen = openYesterday;
          currentClose = actualCloseYesterday;
        }
      }
    }

    // Scenario 3: The club is open right now.
    if (currentOpen != null && currentClose != null) {
      final Duration remaining = currentClose.difference(_now);

      // Format the remaining time as hours and minutes.

      final int minutes = remaining.inMinutes % 60;
      final int totalMinutes = remaining.inMinutes;
      double roundedHours = roundToNearestHalfHour(totalMinutes);
      if (remaining.inHours > 5) {
        // Format the closing time (ensure minutes are padded with a leading zero)
        final String closeTimeFormatted =
            "${currentClose.hour.toString().padLeft(2, '0')}:${currentClose.minute.toString().padLeft(2, '0')}";
        return "${S.of(ourNavigatorKey.currentContext!).open_until} $closeTimeFormatted ${S.of(ourNavigatorKey.currentContext!).today}";
      }
      if (totalMinutes > 0) {
        //TODO Should totalMinutes >60 not be here instead??!?
        // Calculate the remaining time in hours as a decimal.
        // For example, 90 minutes becomes 1.5 hours.
        final double remainingHours = totalMinutes / 60.0;
        // Format to one decimal place (so 30 minutes becomes 0.5)
        String formattedHours = roundedHours == roundedHours.toInt()
            ? roundedHours.toInt().toString()
            : roundedHours.toStringAsFixed(1);
        // Choose singular/plural based on the numeric value (you may adjust this as needed)
        String hourText =
            roundedHours == roundedHours.toInt() && roundedHours.toInt() == 1
                ? 'time'
                : 'timer';
        return "${S.of(ourNavigatorKey.currentContext!).open} $formattedHours $hourText ${S.of(ourNavigatorKey.currentContext!).yet}.";
      } else {
        return "${S.of(ourNavigatorKey.currentContext!).open} $minutes ${minutes == 1 ? S.of(ourNavigatorKey.currentContext!).minute : S.of(ourNavigatorKey.currentContext!).minutes} ${S.of(ourNavigatorKey.currentContext!).yet}.";
      }
    }

    // Scenario 2: The club is not open now.
    // If today's schedule is available, show it.
    if (todayHours != null &&
        todayHours['open'] != null &&
        todayHours['close'] != null) {
      return "${todayHours['open']} - ${todayHours['close']} i dag.";
    }

    // Fallback: Consider the club closed.
    return closedTodayString;
  }

  /// Parses a time string (like "04:00") into a DateTime on the provided base date.
  /// Returns null if the time string is invalid.
  static DateTime? _parseTime(String time, DateTime baseDate) {
    if (!_isTimeValid(time)) return null;
    final List<String> parts = time.split(":");
    final int hour = int.parse(parts[0]);
    final int minute = int.parse(parts[1]);
    return DateTime(baseDate.year, baseDate.month, baseDate.day, hour, minute);
  }

  /// Checks that the time string is in the "HH:mm" format.
  static bool _isTimeValid(String time) {
    return RegExp(r'^\d{1,2}:\d{2}$').hasMatch(time);
  }

  /// Returns the lower-case weekday (e.g., "monday", "tuesday") for a given DateTime.
  static String _getWeekday(DateTime date) {
    // The DateFormat 'EEEE' returns the full weekday name.
    return DateFormat(
      'EEEE',
      'en_US',
    ).format(date).toLowerCase();
  }

  /// Returns true if the club is currently open, false otherwise.
  /// This method checks both today's schedule and yesterday’s (to account for overnight hours).
  /// If the schedule’s closing time is "luk" (case insensitive) then the club is considered
  /// open until 24 hours after the opening time.
  static bool isClubOpen(ClubData? club) {
    if (club?.openingHours?.isEmpty ?? true) return false;

    // Get the keys for today and yesterday.
    final String todayKey = _getWeekday(_now);
    final String yesterdayKey =
        _getWeekday(_now.subtract(const Duration(days: 1)));

    final Map<String, dynamic>? todayHours = club!.openingHours?[todayKey];
    final Map<String, dynamic>? yesterdayHours =
        club.openingHours?[yesterdayKey];

    // Check today's schedule.
    if (todayHours != null &&
        todayHours['open'] != null &&
        todayHours['close'] != null) {
      final DateTime? openToday = _parseTime(todayHours['open'], _now);
      if (openToday != null) {
        final String closeTodayStr = todayHours['close'].toString();
        if (closeTodayStr.toLowerCase() == "luk") {
          // "luk" means no defined closing time – consider the club open until 24 hours after opening.
          final DateTime effectiveClose =
              openToday.add(const Duration(days: 1));
          if (_now.isAfter(openToday) && _now.isBefore(effectiveClose)) {
            return true;
          }
        } else {
          final DateTime? closeToday = _parseTime(todayHours['close'], _now);
          if (closeToday != null) {
            final DateTime actualCloseToday = closeToday.isAfter(openToday)
                ? closeToday
                : closeToday.add(const Duration(days: 1));
            if (_now.isAfter(openToday) && _now.isBefore(actualCloseToday)) {
              return true;
            }
          }
        }
      }
    }

    // Check yesterday's schedule (for clubs that remain open past midnight).
    if (yesterdayHours != null &&
        yesterdayHours['open'] != null &&
        yesterdayHours['close'] != null) {
      final DateTime yesterdayDate = _now.subtract(const Duration(days: 1));
      final DateTime? openYesterday =
          _parseTime(yesterdayHours['open'], yesterdayDate);
      if (openYesterday != null) {
        final String closeYesterdayStr = yesterdayHours['close'].toString();
        if (closeYesterdayStr.toLowerCase() == "luk") {
          final DateTime effectiveClose =
              openYesterday.add(const Duration(days: 1));
          if (_now.isAfter(openYesterday) && _now.isBefore(effectiveClose)) {
            return true;
          }
        } else {
          final DateTime? closeYesterday =
              _parseTime(yesterdayHours['close'], yesterdayDate);
          if (closeYesterday != null) {
            final DateTime actualCloseYesterday =
                closeYesterday.isAfter(openYesterday)
                    ? closeYesterday
                    : closeYesterday.add(const Duration(days: 1));
            if (_now.isAfter(openYesterday) &&
                _now.isBefore(actualCloseYesterday)) {
              return true;
            }
          }
        }
      }
    }

    return false;
  }

  static double roundToNearestHalfHour(int totalMinutes) {
    int quotient = (totalMinutes / 30).round();
    int roundedMinutes = quotient * 30;
    return roundedMinutes / 60.0;
  }
}
