import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/icons.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:nightview/utilities/club_data/club_age_restriction_formatter.dart';
import 'package:nightview/utilities/club_data/club_capacity_calculator.dart';
import 'package:nightview/utilities/club_data/club_opening_hours_formatter.dart';
import 'package:nightview/utilities/club_data/club_type_formatter.dart';
import 'package:nightview/widgets/stateful/favorite_club_button.dart';
import 'package:nightview/widgets/stateless/distance_display_widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:nightview/widgets/stateful/rate_club.dart';
import 'package:provider/provider.dart';

import '../../providers/global_provider.dart';
import '../../utilities/club_data/club_name_formatter.dart';
import '../../utilities/messages/custom_modal_message.dart';

class ClubHeader extends StatelessWidget {
  // TODO rework so the header fits without problems on all screens.

  final ClubData club;

  // final LatLng userLocation;

  // final GlobalKey _circleAvatarKey = GlobalKey(); For popup

  const ClubHeader({
    super.key,
    required this.club,
    // required this.userLocation,
  });

  @override
  Widget build(BuildContext context) {
    final String formattedClubName = ClubNameFormatter.displayClubName(club);
    final String formattedClubType =
        ClubTypeFormatter.displayClubTypeFormatted(club);
    final String openingHoursToday =
        ClubOpeningHoursFormatter.displayClubOpeningHoursFormatted(club);
    final String currentAgeRestriction =
        ClubAgeRestrictionFormatter.displayClubAgeRestrictionFormatted(club);
    double percentOfCapacity =
        ClubCapacityCalculator.displayCalculatedPercentageOfCapacity(club);
    if (openingHoursToday == "Lukket i dag") {
      percentOfCapacity = 0;
    }
    // final distance = ClubDistanceCalculator.displayDistanceToClub(
    //   club: club,
    // userLat: userLocation.latitude,
    // userLon: userLocation.longitude,
    // );

    return SafeArea(
      child: Container(
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
                        backgroundImage:
                            CachedNetworkImageProvider(club.typeOfClubImg),
                        // Todo white outline on pic
                        radius: kNormalSizeRadius,
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
                              defaultDownArrow,
                              size: kBiggerSizeRadius,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // TODO rutevejlednign her.
                  //TODO cache distance
                  Align(
                    alignment: Alignment.topRight,
                    child: DistanceDisplayWidget(club: club),
                  ),
                ],
              ),
            ),
            // Club name
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: kSmallPadding,
              ),
              // vertical: kMainPadding),
              child: Center(
                child: FittedBox(
                  fit: BoxFit
                      .scaleDown, // Prevents text overflow by scaling down
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      // Stroked text as border.
                      Text(
                        formattedClubName,
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
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kMainPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(club.logo),
                        radius: kBiggerSizeRadius,
                      ),
                      const SizedBox(width: kSmallSpacerValue), // Space between
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

                    // Capavity
                    child: CircularPercentIndicator(
                      radius: kBiggerSizeRadius,
                      // radius:20.0,
                      lineWidth: 5.0,
                      // lineWidth: 3.0,
                      // padding-right: 10
                      percent: percentOfCapacity,
                      center: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  (percentOfCapacity * 100).toStringAsFixed(0),
                              style: kTextStyleH3.copyWith(color: primaryColor),
                              // style: kTextStyleP1.copyWith(color: primaryColor),
                            ),
                            TextSpan(
                              text: '%',
                              style: kTextStyleH3.copyWith(color: white),
                              // style: kTextStyleP1.copyWith(color: white),
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
                    currentAgeRestriction,
                    style: kTextStyleP1.copyWith(color: primaryColor),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    // Adds a tiny bit of space
                    child: Text(
                      // Provider.of<GlobalProvider>(context, listen: true)
                      //             .partyCount ==
                      //         1
                      //     ? 'Nightview bruger'
                      //     : 'Nightview brugere',
                      // Conditional text based on partyCount
                      "Kapacitet",
                      style: kTextStyleP1, // Apply the desired text style
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
                      defaultDownArrow,
                      color: white,
                      size: 20,
                    ),
                    itemBuilder: (context) {
                      // Print the club's name and opening hours for debugging
                      print('${club.name} ${club.openingHours?.toString() ?? 'No opening hours available'}');

                      // Filter and sort opening hours
                      final filteredOpeningHours = club.openingHours?.entries
                          .where((entry) {
                        final hours = entry.value as Map<String, dynamic>?;

                        // Keep only days with valid open and close times
                        return hours != null && hours['open'] != null && hours['close'] != null;
                      })
                          .toList()
                        ?..sort((a, b) {
                        final indexA = _weekdayOrder.indexOf(a.key.toLowerCase());
                        final indexB = _weekdayOrder.indexOf(b.key.toLowerCase());
                        return indexA.compareTo(indexB);
                      });

                      // Handle cases where `filteredOpeningHours` is null or empty
                      if (filteredOpeningHours == null || filteredOpeningHours.isEmpty) {
                        return [
                          PopupMenuItem(
                            value: null,
                            child: Text(
                              'Ingen åbningstider', // "No opening hours" in Danish
                              style: kTextStyleP1,
                            ),
                          ),
                        ];
                      }

                      // Map filtered and sorted days to PopupMenuItems
                      return filteredOpeningHours.map((entry) {
                        final englishDay = entry.key; // The English key (e.g., "monday")
                        final danishDay = _mapDayToDanish(englishDay); // Convert to Danish
                        final hours = entry.value;
                        final openTime = hours?['open'];
                        final closeTime = hours?['close'];
                        final ageRestriction = ClubAgeRestrictionFormatter.formatAgeRestrictionForSpecificDay(
                          club,
                          englishDay,
                        );

                        return PopupMenuItem(
                          value: entry,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$danishDay: $openTime - $closeTime',
                                style: kTextStyleP1,
                              ),
                              Text(
                                ageRestriction,
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
      ),
    );
  }
}

final List<String> _weekdayOrder = [
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
  return dayMapping[englishDay.toLowerCase()] ?? englishDay; // Fallback to English if not found
}

