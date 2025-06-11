import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/icons.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/generated/l10n.dart';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:nightview/providers/language_provider.dart';
import 'package:provider/provider.dart';

class CustomPopupMenuButtonOpeningHours extends StatelessWidget {
  final ClubData club;

  CustomPopupMenuButtonOpeningHours(this.club, {super.key});

  final List<String> _weekdaysOrdered = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];

  String _mapDayToDanish(String englishDay) {
    const dayMapping = {
      'monday': 'mandag',
      'tuesday': 'tirsdag',
      'wednesday': 'onsdag',
      'thursday': 'torsdag',
      'friday': 'fredag',
      'saturday': 'lørdag',
      'sunday': 'søndag',
    };
    return dayMapping[englishDay.toLowerCase()] ??
        englishDay; // Fallback to English
  }

  // Helper function to capitalize the first letter of a string
  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LanguageProvider>(context);
    final currentLocale = provider.locale;

    final openingHours = club.openingHours;

    // Filter and sort opening hours
    final filteredOpeningHours = openingHours?.entries.where((entry) {
      final hours = entry.value;
      return hours != null && hours['open'] != null && hours['close'] != null;
    }).toList()
      ?..sort((a, b) {
        final indexA = _weekdaysOrdered.indexOf(a.key.toLowerCase());
        final indexB = _weekdaysOrdered.indexOf(b.key.toLowerCase());
        return indexA.compareTo(indexB);
      });

    // Handle cases where `filteredOpeningHours` is null or empty
    if (filteredOpeningHours == null || filteredOpeningHours.isEmpty) {
      return PopupMenuButton(
        icon: Icon(
          defaultDownArrow,
          size: 15,
          color: white,
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: null,
            child: Text(
              S.of(context).unknown_opening_hours,
              style: kTextStyleP1,
            ),
          ),
        ],
      );
    }

    // Build PopupMenuButton
    return Theme(
      data: Theme.of(context).copyWith(
        popupMenuTheme: PopupMenuThemeData(
          color: grey, // Set your desired background color here
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20.0), // Adjust for rounded corners
          ),
        ),
      ),
      child: PopupMenuButton<MapEntry<String, dynamic>>(
        icon: Icon(
          defaultDownArrow,
          size: 15,
          color: white,
        ),
        constraints: BoxConstraints(
          minWidth: 250.0, // Adjust this value to make the popup wide enough
        ),
        itemBuilder: (context) {
          return filteredOpeningHours.map((entry) {
            final englishDay = entry.key; // e.g., "monday"
            final danishDay = currentLocale == Locale('en')
                ? englishDay
                : _mapDayToDanish(englishDay); // e.g., "mandag" or "monday"
            final capitalizedDay =
                _capitalizeFirstLetter(danishDay); // e.g., "Mandag" or "Monday"
            final hours = entry.value;
            final openTime = hours?['open'];
            final closeTime = hours?['close'];
            // Check for day-specific age restriction, fall back to club.ageRestriction
            final rawAgeRestriction =
                hours?['ageRestriction'] ?? club.ageRestriction;
            // Only display if 18 or above, otherwise empty string
            final ageRestriction = (rawAgeRestriction != null &&
                    int.tryParse(rawAgeRestriction.toString()) != null &&
                    int.parse(rawAgeRestriction.toString()) >= 18)
                ? rawAgeRestriction.toString()
                : '';

            return PopupMenuItem(
              value: entry,
              child: Row(
                children: [
                  SizedBox(
                    width:
                        100.0, // Fixed width for day to align hours consistently
                    child: Text(
                      capitalizedDay,
                      style: kTextStyleP1,
                    ),
                  ),
                  Text(
                    '$openTime - $closeTime',
                    style: kTextStyleP1,
                  ),
                  Expanded(
                    child:
                        SizedBox(), // Fills space to push age restriction right
                  ),
                  SizedBox(width: 16.0), // Fixed gap for consistent spacing
                  Text(
                    ageRestriction.isNotEmpty ? '$ageRestriction+' : '',
                    style: kTextStyleP1,
                  ),
                ],
              ),
            );
          }).toList();
        },
      ),
    );
  }
}
