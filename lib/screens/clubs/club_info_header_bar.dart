import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:nightview/utilities/club_data/club_age_restriction_formatter.dart';
import 'package:nightview/utilities/club_data/club_opening_hours_formatter.dart';

class ClubInfoHeaderBar extends StatefulWidget {
  final ClubData club;
  final bool initiallyExpanded;

  const ClubInfoHeaderBar({
    super.key,
    required this.club,
    this.initiallyExpanded = false,
  });

  @override
  State<ClubInfoHeaderBar> createState() => _ClubInfoHeaderBarState();
}

class _ClubInfoHeaderBarState extends State<ClubInfoHeaderBar> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  List<Widget> _buildUpcomingOpenDays() {
    final List<Widget> rows = [];
    final DateTime now = DateTime.now();

    for (int i = 1; i <= 6; i++) {
      final date = now.add(Duration(days: i));
      final int weekday = date.weekday;
      final String weekdayStr = DateFormat.EEEE().format(date);

      final openingHours =
          ClubOpeningHoursFormatter.displayClubOpeningHoursForWeekday(
        widget.club,
        weekday,
      );

      if (openingHours.isEmpty || !openingHours.contains(' - ')) continue;

      final parts = openingHours.split(' - ');
      final String open = parts[0];
      final String close = parts.length > 1 ? parts[1] : '';

      // Skip if either is invalid
      if (open.isEmpty || close.isEmpty) continue;

      final uplift = close.startsWith('0');

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
                width: 100,
                child: Text(weekdayStr, style: kTextStyleP3),
              ),
              SizedBox(
                width: 100,
                child: RichText(
                  text: TextSpan(
                    style: kTextStyleP3,
                    children: [
                      TextSpan(text: '$open - $close'),
                      if (uplift)
                        WidgetSpan(
                          alignment: PlaceholderAlignment.top,
                          child: Transform.translate(
                            offset: const Offset(0, -5),
                            child: Text(
                              '+1',
                              style: kTextStyleP3.copyWith(
                                fontSize: 9,
                                color: white.withOpacity(0.8),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(child: Text(age, style: kTextStyleP3)),
              // SizedBox(child: Text(""), // WHAT HERE!? Busy?

              const SizedBox(width: 50), // Placeholder / future "busy"
            ],
          ),
        ),
      );
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime displayDate = now;
    int weekdayIndex = now.weekday;

    // Check if the club is open now
    if (ClubOpeningHoursFormatter.isClubOpen(widget.club)) {
      // Check if it's open under yesterday's schedule
      final yesterday = now.subtract(Duration(days: 1));
      final yesterdayKey =
          DateFormat('EEEE', 'en_US').format(yesterday).toLowerCase();
      final yesterdayHours = widget.club.openingHours?[yesterdayKey];

      if (yesterdayHours != null &&
          yesterdayHours['open'] != null &&
          yesterdayHours['close'] != null) {
        // Parse yesterday's open and close times
        DateTime? parseTime(String time, DateTime baseDate) {
          if (!RegExp(r'^\d{1,2}:\d{2}$').hasMatch(time)) return null;
          final parts = time.split(':');
          final hour = int.parse(parts[0]);
          final minute = int.parse(parts[1]);
          return DateTime(
              baseDate.year, baseDate.month, baseDate.day, hour, minute);
        }

        final openYesterday = parseTime(yesterdayHours['open'], yesterday);
        final closeYesterday = parseTime(yesterdayHours['close'], yesterday);

        if (openYesterday != null && closeYesterday != null) {
          final actualCloseYesterday = closeYesterday.isAfter(openYesterday)
              ? closeYesterday
              : closeYesterday.add(Duration(days: 1));
          // If current time is within yesterday's hours, use yesterday's schedule
          if (now.isAfter(openYesterday) &&
              now.isBefore(actualCloseYesterday)) {
            displayDate = yesterday;
            weekdayIndex = yesterday.weekday;
          }
        }
      }
      // If not open under yesterday's schedule, assume it's today's schedule
    } else {
      // If not open, default to today
    }

    final String weekday = DateFormat.EEEE().format(displayDate);
    final String openHours =
        ClubOpeningHoursFormatter.displayClubOpeningHoursForWeekday(
      widget.club,
      weekdayIndex,
    );
    final String ageRestriction =
        ClubAgeRestrictionFormatter.displayClubAgeRestrictionFormatted(
      widget.club,
    );

    // Rest of your build method remains unchanged
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: grey, width: 1),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    weekday,
                    style: kTextStyleP2.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: openHours.isEmpty
                      ? Text("")
                      : RichText(
                          text: TextSpan(
                            style: kTextStyleP2.copyWith(
                                fontWeight: FontWeight.w600),
                            children: () {
                              final parts = openHours.split(' - ');
                              if (parts.length < 2) {
                                return [TextSpan(text: openHours)];
                              }
                              final open = parts[0];
                              final close = parts[1];
                              final uplift = close.startsWith('0');
                              return [
                                TextSpan(text: '$open - $close'),
                                if (uplift)
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.top,
                                    child: Transform.translate(
                                      offset: const Offset(0, -5),
                                      child: Text(
                                        '+1',
                                        style: kTextStyleP3.copyWith(
                                          fontSize: 9,
                                          color: white.withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                  ),
                              ];
                            }(),
                          ),
                        ),
                ),
                SizedBox(
                  child: openHours.isEmpty
                      ? Text("")
                      : Text(
                          ageRestriction,
                          style: kTextStyleP2.copyWith(
                              fontWeight: FontWeight.w600),
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
