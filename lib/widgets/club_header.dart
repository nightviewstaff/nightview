import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/models/club_data.dart';
import 'package:nightview/widgets/favorite_club_button.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:nightview/widgets/rate_club.dart';

class ClubHeader extends StatelessWidget {
  final ClubData club;

  const ClubHeader({super.key, required this.club});

  @override
  Widget build(BuildContext context) {
    final String currentWeekday =
    DateFormat('EEEE').format(DateTime.now()).toLowerCase();
    final Map<String, dynamic>? todayHours =
    club.openingHours[currentWeekday] as Map<String, dynamic>?;

    String openingHoursText;
    if (todayHours == null || todayHours.isEmpty) {
      openingHoursText = 'Lukket i dag.';
    }
    else {
      final String openTime = todayHours['open'] ?? '00:00';
      final String closeTime = todayHours['close'] ?? '00:00';
      openingHoursText = '$openTime - $closeTime';
    }

    if(club.visitors<14){
      club.visitors = 14;
    }

    double percentOfCapacity = (club.totalPossibleAmountOfVisitors > 0)
        ? club.visitors / club.totalPossibleAmountOfVisitors
        : 0.15;

    if (percentOfCapacity >= 1) {
      percentOfCapacity =
      0.99; // Sets capacity to a max of 99% maybe need change.
    }
    if (percentOfCapacity <= 0) {
      percentOfCapacity = 0.03; // Sets capacity to a min of 3% maybe need change.
    }

   String currentAgeRestriction = club.ageRestriction.toString();

    if (todayHours != null && todayHours.containsKey('age_restriction')) {
      currentAgeRestriction = todayHours['age_restriction'];
    }

    String currentTypeOfClub = club.typeOfClub.substring(0,1).toUpperCase() + club.typeOfClub.substring(1,);

    return Container(
      decoration: BoxDecoration(
        color: black,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: FaIcon(
                  FontAwesomeIcons.chevronDown,
                  size: 30.0,
                ),
              ),
            ),
          ),
          Center(
            child: Stack(
              children: <Widget>[
                // Stroked text as border.
                Text(
                  club.name,
                  style: kTextStyleH1.copyWith(
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 0.2
                      ..color = white,
                  ),
                  textAlign: TextAlign.center,
                ),
                // Solid text as fill.
                Text(
                  club.name,
                  style: kTextStyleH1.copyWith(color: primaryColor),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kMainPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(club.logo),
                      radius: 25.0,
                    ),
                    const SizedBox(width: kNormalSpacerValue),
                    const FavoriteClubButton(),
                  ],
                ),
                CircularPercentIndicator(
                  radius: 30.0,
                  lineWidth: 5.0,
                  percent: percentOfCapacity,
                  center: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: (percentOfCapacity * 100).toStringAsFixed(0),
                          style: kTextStyleH3.copyWith(color: primaryColor),
                        ),
                        TextSpan(
                          text: '%',
                          style: kTextStyleH3.copyWith(color: white),
                        ),
                      ],
                    ),
                  ),
                  progressColor: secondaryColor,
                  backgroundColor: white,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kSmallSpacerValue),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$currentTypeOfClub: $currentAgeRestriction+',
                  style: kTextStyleH3,
                ),
                Text(
                  '${club.visitors} Gæster', //Set visitors to primaryColor. TODO
                  style: kTextStyleH3,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kSmallSpacerValue),
            child: Text(
              openingHoursText,
              style: kTextStyleH3,
            ),
          ),
          RateClub(clubId: club.id),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kMainPadding),
            child: Divider(
              height: kNormalSpacerValue * 2,
              color: white,
              thickness: kMainStrokeWidth,
            ),
          ),
        ],
      ),
    );
  }
}
