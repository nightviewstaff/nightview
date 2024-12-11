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
  // TODO rework so the header fits without problems on all screens.

  final ClubData club;

  // final GlobalKey _circleAvatarKey = GlobalKey(); For popup

  ClubHeader({super.key, required this.club});

  @override
  Widget build(BuildContext context) {
    final String currentWeekday = DateFormat('EEEE')
        .format(DateTime.now())
        .toLowerCase(); // Move to seperate class eventually
    final Map<String, dynamic>? todayHours =
        club.openingHours[currentWeekday] as Map<String, dynamic>?;

    String openingHoursText;
    if (todayHours == null || todayHours.isEmpty) {
      openingHoursText = 'Lukket ';
    } else {
      final String openTime = todayHours['open'] ?? '00:00';
      final String closeTime = todayHours['close'] ?? '00:00';
      openingHoursText = '$openTime - $closeTime ';
    }

    if (club.visitors < 5) {
      // && (todayHours != null || todayHours!.isNotEmpty)) {
      // TODO
      club.visitors = 14;
      // Random(5)+10;
    }

    double percentOfCapacity = (club.totalPossibleAmountOfVisitors > 0)
        ? club.visitors / club.totalPossibleAmountOfVisitors
        : 0.15;

    if (percentOfCapacity >= 1) {
      percentOfCapacity =
          0.99; // Sets capacity to a max of 99% maybe need change.
    }
    if (percentOfCapacity <= 0) {
      // percentOfCapacity =
      //     0.03; // Sets capacity to a min of 3% maybe need change.
    }

    int intCurrentAgeRestriction = club.ageRestriction;
    String stringCurrentAgeRestriction;
    if (todayHours != null && todayHours.containsKey('age_restriction')
        // && !todayHours.containsKey('age_restriction')==null
        ) {
      intCurrentAgeRestriction = todayHours['age_restriction'];
    }

    if (intCurrentAgeRestriction <= 17) {
      stringCurrentAgeRestriction = 'ikke oplyst';
    } else {
      stringCurrentAgeRestriction = '$intCurrentAgeRestriction+';
    }

    final Map<String, String> clubTypeTranslations = {
      'bar': 'Bar',
      'bar_club': 'Bar/klub',
      'beer_bar': 'Ølbar',
      'bodega': 'Bodega',
      'club': 'Klub',
      'cocktail_bar': 'Cocktailbar',
      'gay_bar': 'Gaybar',
      'jazz_bar': 'Jazzbar',
      'karaoke_bar': 'Karaokebar',
      'live_music_bar': 'Livemusikbar',
      'pub': 'Pub',
      'sports_bar': 'Sportsbar',
      'wine_bar': 'Vinbar',
    };

    String currentTypeOfClubTranslated(String typeOfClub) {
      final translated = clubTypeTranslations[typeOfClub] ??
          typeOfClub; // Default to original if not found
      return translated.substring(0, 1).toUpperCase() + translated.substring(1);
    }

    // TODO later for better visability of place.
    // void _showPopup(BuildContext context) { For better showing of clubType
    //   final RenderBox renderBox =
    //       _circleAvatarKey.currentContext!.findRenderObject() as RenderBox;
    //   final Offset position = renderBox.localToGlobal(
    //       Offset.zero); // Get the global position of the CircleAvatar
    //
    //   final overlay = Overlay.of(context); // Get the overlay
    //   final overlayEntry = OverlayEntry(
    //     builder: (context) => Positioned(
    //       Position the popup dynamically based on the CircleAvatar location
    // left: position.dx + renderBox.size.width + 10,
    // Adjust this based on where you want the popup
    // top: position.dy,
    // Adjust this based on where you want the popup
    // child: Material(
    //   color: Colors.transparent, // Transparent background
    //   child: Container(
    //     padding: EdgeInsets.all(8.0),
    //     decoration: BoxDecoration(
    //       color: Colors.black.withOpacity(1),
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //     child: Text(
    //       'Bar', // Display the type of club
    //       style: TextStyle(color: white),
    //     ),
    //   ),
    // ),
    // ),
    // );
    // overlay?.insert(overlayEntry);
    // Duration
    // Future.delayed(Duration(seconds: 1), () {
    //   overlayEntry.remove();
    // });
    // }

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
                      // _showPopup(context); TODO future release
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            currentTypeOfClubTranslated(club.typeOfClub),
                            style: kTextStyleP1,
                          ),
                        ),
                      );
                      Future.delayed(Duration(seconds: 2), () {
                        Navigator.of(context).pop();
                      });
                    },
                    child: CircleAvatar(
                      // key: _circleAvatarKey,
                      backgroundImage: NetworkImage(club.typeOfClubImg),
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
                    club.name, // TODO Move text just a bit further up
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
                CircularPercentIndicator(
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

                // )
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
                  stringCurrentAgeRestriction,
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
            child: Text(
              // 'Åbningstider: ' +
              '$openingHoursText i dag.',
              // Dropdown til hele ugens åbningstider TODO
              style: kTextStyleP1,
            ),
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
