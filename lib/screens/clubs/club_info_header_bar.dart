import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:nightview/utilities/club_data/club_age_restriction_formatter.dart';
import 'package:nightview/utilities/club_data/club_opening_hours_formatter.dart';

class ClubInfoHeaderBar extends StatefulWidget {
  final ClubData club;

  const ClubInfoHeaderBar({super.key, required this.club});

  @override
  State<ClubInfoHeaderBar> createState() => _ClubInfoHeaderBarState();
}

class _ClubInfoHeaderBarState extends State<ClubInfoHeaderBar> {
  bool _isExpanded = false;

  List<Widget> _buildUpcomingOpenDays() {
    final List<Widget> rows = [];
    final now = DateTime.now();
    final Set<String> seenDays = {};

    for (int i = 1; i < 7; i++) {
      // Start from 1 to skip today
      final date = now.add(Duration(days: i));
      final weekday = DateFormat.EEEE().format(date);

      if (seenDays.contains(weekday)) continue;
      seenDays.add(weekday);

      final openingHours =
          ClubOpeningHoursFormatter.displayClubOpeningHoursForWeekday(
        widget.club,
        date.weekday,
      );

      if (openingHours.isNotEmpty) {
        final parts = openingHours.split(' - ');
        String open = parts[0];
        String close = parts.length > 1 ? parts[1] : '';

        final displayHours = close.isNotEmpty ? '$open - $close' : openingHours;
        final age =
            ClubAgeRestrictionFormatter.displayClubAgeRestrictionFormatted(
                widget.club);

        rows.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 120,
                  child:
                      Text(weekday, style: kTextStyleP3.copyWith(fontSize: 11)),
                ),
                SizedBox(
                  width: 120,
                  child: Text(displayHours,
                      style: kTextStyleP3.copyWith(fontSize: 11)),
                ),
                SizedBox(
                  width: 120,
                  child: Text(age, style: kTextStyleP3.copyWith(fontSize: 11)),
                ),

                // TODO Add how busy it normally is here, Percent or string?
              ],
            ),
          ),
        );
      }
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final String weekday = DateFormat.EEEE().format(DateTime.now());
    final String openHours =
        ClubOpeningHoursFormatter.displayClubOpeningHoursTodaySimple(
            widget.club);
    final String ageRestriction =
        ClubAgeRestrictionFormatter.displayClubAgeRestrictionFormatted(
            widget.club);

    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(color: primaryColor, width: 0.8),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  weekday,
                  style: kTextStyleP1.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  openHours,
                  style: kTextStyleP1.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  ageRestriction,
                  style: kTextStyleP1.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  iconSize: 16,
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  icon: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: white,
                  ),
                ),
              ],
            ),
            if (_isExpanded)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Column(
                  children: _buildUpcomingOpenDays(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
