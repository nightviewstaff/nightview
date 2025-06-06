import 'dart:ffi';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/constants/icons.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/generated/l10n.dart';
import 'package:nightview/helpers/clubs/club_data_helper.dart';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:nightview/providers/night_map_provider.dart';
import 'package:nightview/screens/main_screen.dart';
import 'package:nightview/screens/night_map/night_map.dart';
import 'package:nightview/screens/night_map/night_map_main_offer_screen.dart';
import 'package:nightview/screens/night_map/night_map_main_screen.dart';
import 'package:nightview/screens/utility/emoji_priority_helper.dart';
import 'package:nightview/utilities/club_data/club_name_formatter.dart';
import 'package:nightview/utilities/club_data/club_opening_hours_formatter.dart';
import 'package:nightview/utility/utility.dart';
import 'package:nightview/widgets/stateful/favorite_club_button.dart';
import 'package:nightview/widgets/stateful/mood_images_scroller.dart';
import 'package:provider/provider.dart';

class ClubBottomSheet {
  static bool _isBottomSheetOpen = false; // Track if a sheet is open

  static void showClubSheet({
    required BuildContext context,
    required ClubData club,
    bool moveMap = true,
  }) {
    if (_isBottomSheetOpen) return; // Prevent multiple sheets

    final mapProvider = Provider.of<NightMapProvider>(context, listen: false);
    final map = mapProvider.mapController;
    final double goodHeightSeperater = 20.0;

    if (moveMap) {
      if (map != null) {
        map.flyTo(
          CameraOptions(
            center: Point(coordinates: Position(club.lon, club.lat)),
            zoom: 17.3,
            pitch: 55,
            bearing: 0,
          ),
          MapAnimationOptions(duration: 4500),
        );
      }
    }

    _isBottomSheetOpen = true; // Set flag

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final String formattedClubName = ClubNameFormatter.displayClubName(club);

    // --- Header Content (previously in ClubHeader) ---

    // Top part: Club name, favorite buttons, and logo
    Widget topPart = Container(
      height: 200, // Fixed height to maintain background image layout
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              'images/swipe/12.png'), // Replace with dynamic image if needed
          fit: BoxFit.cover,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: screenWidth * 0.5,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Stack(
                    children: [
                      Text(
                        formattedClubName,
                        style: kTextStyleH1.copyWith(
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 7.0
                            ..color = primaryColor,
                        ),
                      ),
                      Text(
                        formattedClubName,
                        style: kTextStyleH1.copyWith(color: white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const FavoriteClubButton(),
                  IconButton(
                    icon: const Icon(defaultHeartIcon, color: white),
                    onPressed: () {}, // TODO: Implement functionality
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 100.0,
            height: 100.0,
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
                errorWidget: (context, url, error) => CachedNetworkImage(
                  imageUrl: club.typeOfClubImg,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );

    // Bottom part: Bookings, opening hours, rating, tags, and buttons
    Widget bottomPart = Container(
      color: black,
      padding:
          const EdgeInsets.only(top: 16.0, left: 10, right: 10, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.mail_outline_outlined, color: primaryColor),
                  Container(
                    margin: const EdgeInsets.only(left: 5),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 9.0, vertical: 3.0),
                    decoration: BoxDecoration(
                      color: black,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: white),
                    ),
                    child: const Text(
                      'Bookings',
                      style:
                          TextStyle(color: white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 9.0, vertical: 3.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: white, width: 1),
                    ),
                    child: Text(
                      ClubOpeningHoursFormatter
                          .displayClubOpeningHoursFormatted(club),
                      style: const TextStyle(fontSize: 10, color: white),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 9.0, vertical: 3.0),
                    decoration: BoxDecoration(
                      color: grey,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            club.rating?.toStringAsFixed(1) ?? 'N/A',
                            style: const TextStyle(
                              color: black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Row(
                          children: List.generate(
                            5,
                            (index) => const Icon(Icons.star,
                                color: primaryColor, size: 17),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '(213)', // TODO: Replace with actual rating count
                    style: TextStyle(color: white, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          if (club.tags != null && club.tags!.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: white, width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
              constraints: const BoxConstraints(maxHeight: 105),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const crossAxisCount = 4;
                  final sortedTags = List.from(club.tags!)
                    ..sort((a, b) {
                      final emojiA = ClubDataHelper.tagEmojiMap[a] ?? '';
                      final emojiB = ClubDataHelper.tagEmojiMap[b] ?? '';
                      return EmojiPriorityHelper.getEmojiPriority(emojiB)
                          .compareTo(
                              EmojiPriorityHelper.getEmojiPriority(emojiA));
                    });

                  final widestTag = sortedTags
                      .map((tag) => Utility.formatString(tag))
                      .reduce((a, b) => a.length > b.length ? a : b);

                  final fakeTextWidth = (TextPainter(
                    text: TextSpan(
                      text: ClubDataHelper.tagEmojiMap[widestTag] ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                    maxLines: 1,
                    textDirection: TextDirection.ltr,
                  )..layout())
                      .size
                      .width;

                  final itemWidth =
                      (constraints.maxWidth - (8.0 * (crossAxisCount - 1))) /
                              crossAxisCount +
                          fakeTextWidth;

                  return GridView.builder(
                    itemCount: sortedTags.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 16,
                      childAspectRatio: 3.0,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final tag = sortedTags[index];
                      final emoji = ClubDataHelper.tagEmojiMap[tag] ?? '';

                      return Container(
                        decoration: BoxDecoration(
                          color: black,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: primaryColor, width: 2),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 1),
                        child: Row(
                          children: [
                            Text(
                              emoji,
                              style:
                                  const TextStyle(fontSize: 20, color: white),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  Utility.formatString(tag),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 10, color: white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            )
          else
            const SizedBox.shrink(),
          const SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: screenWidth * 0.28,
                height: screenHeight * 0.04,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: black,
                  border: Border.all(color: white),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "More Info",
                        style: TextStyle(
                          color: white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: screenWidth * 0.28,
                height: screenHeight * 0.04,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: black,
                  border: Border.all(color: white),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "Bar Card",
                        style: TextStyle(
                          color: white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    SizedBox(
      height: goodHeightSeperater,
    );

    // --- Bottom Sheet Content (original content) ---

    final List<Widget> bottomSheetContent = [
      // if (club.offerType != OfferType.none) ...[

      GestureDetector(
        onTap: () {
          // if (club.offerType == OfferType.redeemable) {
          //   Navigator.of(context).pushNamed(NightMapMainOfferScreen.id);
          // }
        },
        child: AspectRatio(
          aspectRatio: 0.9,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "images/swipe/12.png"), // Replace with dynamic offer image if needed
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
      SizedBox(
        height: goodHeightSeperater,
      ),

      // ],
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: screenWidth * 0.28,
              height: screenHeight * 0.04,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: black,
                border: Border.all(color: white),
                borderRadius: BorderRadius.circular(12),
              ),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: club.visitors.toString(),
                      style: const TextStyle(
                        color: primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
                      text: " Lige nu",
                      style: TextStyle(
                        color: white,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: screenWidth * 0.28,
              height: screenHeight * 0.04,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: black,
                border: Border.all(color: white),
                borderRadius: BorderRadius.circular(12),
              ),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          "${((club.visitors / club.totalPossibleAmountOfVisitors) * 100).round()}",
                      style: const TextStyle(
                        color: primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
                      text: "% ",
                      style: TextStyle(
                        color: white,
                        fontSize: 14,
                      ),
                    ),
                    const TextSpan(
                      text: "Fyldt",
                      style: TextStyle(
                        color: white,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        height: goodHeightSeperater,
      ),
      MoodImageScroller(club: club),
    ];

    // Combine all content into a single scrollable list
    final List<Widget> allContent = [
      // Club information section
      topPart,
      bottomPart,
      // Additional content section (offer image, stats, mood scroller)
      ...bottomSheetContent,
    ];

    // Show the bottom sheet
    final sheet = showStickyFlexibleBottomSheet(
      context: context,
      initHeight: 0.8,
      minHeight: 0.40,
      maxHeight: 1,
      headerHeight: 0, // No sticky header
      bottomSheetColor: black,
      headerBuilder: (context, offset) => const SizedBox.shrink(),
      bodyBuilder: (context, offset) => SliverChildListDelegate(allContent),
    );

    sheet.then((_) {
      _isBottomSheetOpen = false; // Reset flag when sheet closes
    });
  }
}
