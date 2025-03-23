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
          color: primaryColor,
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
    return PopupMenuButton<MapEntry<String, dynamic>>(
      icon: Icon(
        defaultDownArrow,
        size: 15,
        color: primaryColor,
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

          return PopupMenuItem(
            value: entry,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$capitalizedDay: $openTime - $closeTime', // Display capitalized day
                  style: kTextStyleP1,
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}
