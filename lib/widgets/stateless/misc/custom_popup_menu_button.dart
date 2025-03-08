import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/icons.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/models/clubs/club_data.dart';

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
        englishDay; // Fallback to English if not found
  }

  @override
  Widget build(BuildContext context) {
    final openingHours = club.openingHours;

    // Filter and sort opening hours
    final filteredOpeningHours = openingHours?.entries.where((entry) {
      final hours = entry.value;

      // Keep only days with valid open and close times
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
              'Ukendte åbningstider', // "No opening hours" in Danish
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
          final englishDay = entry.key; // The English key (e.g., "monday")
          final danishDay = _mapDayToDanish(englishDay); // Convert to Danish
          final hours = entry.value;
          final openTime = hours?['open'];
          final closeTime = hours?['close'];

          return PopupMenuItem(
            value: entry,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$danishDay: $openTime - $closeTime',
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
