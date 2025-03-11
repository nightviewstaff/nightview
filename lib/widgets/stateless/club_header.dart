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
import 'package:nightview/widgets/stateless/misc/custom_popup_menu_button.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:nightview/widgets/stateful/rate_club.dart';
import 'package:provider/provider.dart';

import '../../providers/global_provider.dart';
import '../../utilities/club_data/club_name_formatter.dart';
import '../../utilities/messages/custom_modal_message.dart';

class ClubHeader extends StatelessWidget {
  final ClubData club;

  const ClubHeader({
    super.key,
    required this.club,
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
    final double percentOfCapacity =
        ClubCapacityCalculator.displayCalculatedPercentageOfCapacity(club);

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
                        CustomModalMessage.showCustomBottomSheetOneSecond(
                          context: context,
                          message: formattedClubType,
                          textStyle: kTextStyleP1,
                        );
                      },
                      child: CircleAvatar(
                        backgroundImage:
                            CachedNetworkImageProvider(club.typeOfClubImg),
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
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
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
                      Container(
                        width: kBiggerSizeRadius * 2,
                        height: kBiggerSizeRadius * 2,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: ClubOpeningHoursFormatter.isClubOpen(club)
                                ? primaryColor
                                : redAccent,
                            width: 3.0,
                          ),
                        ),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: club.logo,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                CachedNetworkImage(
                              imageUrl: club.typeOfClubImg,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: kSmallSpacerValue),
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
                      radius: kBiggerSizeRadius,
                      lineWidth: 5.0,
                      percent: percentOfCapacity,
                      center: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  (percentOfCapacity * 100).toStringAsFixed(0),
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
                    currentAgeRestriction,
                    style: kTextStyleP1.copyWith(color: primaryColor),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Text(
                      "Kapacitet",
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
                    style: openingHoursToday.toLowerCase() == "lukket i dag."
                        ? kTextStyleP1.copyWith(color: redAccent)
                        : kTextStyleP1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: kMainPadding),
                    child: CustomPopupMenuButtonOpeningHours(club),
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
