import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:nightview/utilities/club_data/club_age_restriction_formatter.dart';
import 'package:nightview/utilities/club_data/club_capacity_calculator.dart';
import 'package:nightview/utilities/club_data/club_opening_hours_formatter.dart';
import 'package:nightview/utilities/club_data/club_type_formatter.dart';
import 'package:nightview/widgets/favorite_club_button.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:nightview/widgets/rate_club.dart';

import '../utilities/club_data/club_name_formatter.dart';
import '../utilities/messages/custom_modal_message.dart';

class ClubHeader extends StatelessWidget {
  // TODO rework so the header fits without problems on all screens.

  final ClubData club;

  // final GlobalKey _circleAvatarKey = GlobalKey(); For popup

  const ClubHeader({super.key, required this.club});

  @override
  Widget build(BuildContext context) {
    String formattedClubName = ClubNameFormatter.displayClubName(club);
    String formattedClubType = ClubTypeFormatter.displayClubTypeFormatted(club);
    String openingHoursToday =
        ClubOpeningHoursFormatter.displayClubOpeningHoursFormatted(club);
    String currentAgeRestriction =
        ClubAgeRestrictionFormatter.displayClubAgeRestrictionFormatted(club);
    double percentOfCapacity =
        ClubCapacityCalculator.displayCalculatedPercentageOfCapacity(club);

    return Container(
      decoration: BoxDecoration(
        color: black,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(kSmallPadding),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {
                      // _showPopup(context); TODO future release for cleaner message.
                      CustomModalMessage.showCustomBottomSheetOneSecond(
                        context: context,
                        message: formattedClubType,
                        textStyle: kTextStyleP1,
                      );
                    },
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(club.typeOfClubImg),
                      // Todo white outline on pic
                      radius: 20.0,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: kSmallSpacerValue),
                          child: FaIcon(
                            FontAwesomeIcons.chevronDown,
                            size: 30.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //ALTERNATIVE

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end, // Align content to the right
                //   children: [
                //     Column(
                //       crossAxisAlignment: CrossAxisAlignment.end, // Align text to the right
                //       children: [
                //         Text(
                //           ClubNameFormatter.displayLocation(club),
                //           style: kTextStyleP3, // Add styling if needed
                //         ),
                //         const SizedBox(height: 4.0), // Add spacing between texts
                //         Text(
                //           ClubNameFormatter.displayDistance(
                //             club: club,
                //             userLon: 551,
                //             userLat: 123,
                //           ),
                //           style: kTextStyleP3, // Add styling if needed
                //         ),
                //       ],
                //     ),
                //     const SizedBox(width: kSmallPadding), // Spacing between this and other widgets
                //   ],
                // ),


                // PIC OF BIKE/ Feet or BUS whatever?
                // rutevejlednign her.
            Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    ClubNameFormatter.displayDistanceToClub(
                      club: club,
                      userLon: 551,
                      userLat: 123,
                    ),
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 16.0,
                    ),
                  ),
                ),


                const SizedBox(width: kSmallPadding,)
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0),
            // EdgeInsets.symmetric(vertical: kSmallSpacerValue),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  // Stroked text as border.
                  Text(
                    formattedClubName,
                    // TODO Move text just a bit further up
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
                    formattedClubName,
                    style: kTextStyleH1.copyWith(color: primaryColor),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
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
                      radius: 30.0,
                    ),
                    // const SizedBox(width: kSmallSpacerValue), // space between logo and X

                    const SizedBox(width: kSmallSpacerValue),
                    // Space between
                    const FavoriteClubButton(),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    CustomModalMessage.showCustomBottomSheetOneSecond(
                      context: context,
                      message:
                          "${(percentOfCapacity * 100).toStringAsFixed(0)}% fyldt op",
                      textStyle: kTextStyleP1,
                    );
                  },
                  child: CircularPercentIndicator(
                    radius: 30.0,
                    lineWidth: 5.0,
                    // padding-right: 10
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
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kSmallSpacerValue),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  // 'Aldersgrænse: '+
                  currentAgeRestriction,
                  style: kTextStyleP1,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  // Adds a tiny bit of space
                  child: Text(
                    'Kapacitet',
                    style: kTextStyleP1,
                  ),
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
                  openingHoursToday,
                  style: kTextStyleP1,
                ),
                PopupMenuButton<MapEntry<String, dynamic>>(
                  icon: FaIcon(
                    FontAwesomeIcons.chevronDown,
                    color: white,
                    size: 20,
                  ),
                  itemBuilder: (context) {
                    //TODO Refactor
                    return club.openingHours.entries.where((entry) {
                      final hours = entry.value as Map<String, dynamic>?;
                      return hours != null &&
                          hours.isNotEmpty; // Skip if closed
                    }).map((entry) {
                      final hours = entry.value as Map<String, dynamic>;
                      final openTime = hours['open'] ?? '00:00';
                      final closeTime = hours['close'] ?? '00:00';
                      final currentAgeRestriction = ClubAgeRestrictionFormatter
                          .displayClubAgeRestrictionFormattedShort(club);
                      return PopupMenuItem(
                        value: entry,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${entry.key[0].toUpperCase()}${entry.key.substring(1)}: $openTime - $closeTime',
                              style: kTextStyleP1,
                            ),
                            Text(
                              currentAgeRestriction,
                              style: kTextStyleP1.copyWith(color: primaryColor),
                            ),
                          ],
                        ),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            width: kSmallSpacerValue,
          ),
          RateClub(clubId: club.id),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kMainPadding),
            child: Divider(
              height: kNormalSpacerValue,
              color: white,
              thickness: kMainStrokeWidth,
            ),
          ),
        ],
      ),
    );
  }
}
