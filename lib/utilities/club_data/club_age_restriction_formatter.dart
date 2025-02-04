import 'package:intl/intl.dart' show DateFormat;
import '../../models/clubs/club_data.dart';

class ClubAgeRestrictionFormatter {
  static String displayClubAgeRestrictionFormatted(ClubData club) {
    return _formatAgeRestriction(club);
  }

  static String displayClubAgeRestrictionFormattedShort(ClubData club) {
    final ageRestriction = _formatAgeRestriction(club);
    return ageRestriction == 'Aldersgrænse ikke oplyst.' ? 'N/A' : ageRestriction;
  }

  static String displayClubAgeRestrictionFormattedOnlyAge(ClubData club) {
    final ageRestriction = _formatAgeRestriction(club);
    return ageRestriction == 'Aldersgrænse ikke oplyst.' ? '' : ageRestriction;
  }

  static String _formatAgeRestriction(ClubData club) {
    final String currentWeekday = DateFormat('EEEE').format(DateTime.now()).toLowerCase();
    final Map<String, dynamic>? openingHoursToday = club.openingHours[currentWeekday];


    final int currentAgeRestriction = (openingHoursToday?['ageRestriction'] as int?) ?? club.ageRestriction;

    return currentAgeRestriction <= 17
        ? 'Aldersgrænse ikke oplyst.'
        : '$currentAgeRestriction+';
  }
}
