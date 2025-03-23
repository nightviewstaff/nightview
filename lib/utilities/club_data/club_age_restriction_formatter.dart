import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:nightview/generated/l10n.dart';
import 'package:nightview/main.dart';
import '../../models/clubs/club_data.dart';

class ClubAgeRestrictionFormatter {
  final BuildContext context = ourNavigatorKey.currentContext!;

  static String displayClubAgeRestrictionFormatted(ClubData club) {
    return formatAgeRestriction(club);
  }

  static String displayClubAgeRestrictionFormattedShort(ClubData club) {
    // Never used
    final ageRestriction = formatAgeRestriction(club);
    return ageRestriction ==
            S.of(ourNavigatorKey.currentContext!).age_limit_not_specified
        ? '??+'
        : ageRestriction;
  }

  static String displayClubAgeRestrictionFormattedOnlyAge(ClubData club) {
    final ageRestriction = formatAgeRestriction(club);
    return ageRestriction ==
            S.of(ourNavigatorKey.currentContext!).age_limit_not_specified
        ? ''
        : ageRestriction;
  }

  static String formatAgeRestriction(ClubData club) {
    final String currentWeekday =
        DateFormat('EEEE').format(DateTime.now()).toLowerCase();
    final Map<String, dynamic>? openingHoursToday =
        club.openingHours?[currentWeekday];

    final int currentAgeRestriction =
        (openingHoursToday?['ageRestriction'] as int?) ?? club.ageRestriction;

    return currentAgeRestriction <= 17
        ? S.of(ourNavigatorKey.currentContext!).age_limit_not_specified
        : '$currentAgeRestriction+';
  }

  static String formatAgeRestrictionForSpecificDay(
      ClubData club, String weekday) {
    final Map<String, dynamic>? openingHoursForSpecificDay =
        club.openingHours?[weekday.toLowerCase()];
    final int ageRestriction =
        (openingHoursForSpecificDay?['ageRestriction'] as int?) ??
            club.ageRestriction;

    return ageRestriction <= 17 ? '??+' : '$ageRestriction+';
  }
}
