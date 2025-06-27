import 'dart:ffi';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/providers/night_map_provider.dart';
import 'package:nightview/screens/clubs/club_bar_card_screen.dart';
import 'package:nightview/screens/clubs/club_cover_image.dart';
import 'package:nightview/screens/clubs/club_more_info_screen.dart';
import 'package:nightview/screens/main_screen.dart';
import 'package:nightview/screens/night_map/night_map.dart';
import 'package:nightview/screens/night_map/night_map_main_offer_screen.dart';
import 'package:nightview/screens/night_map/night_map_main_screen.dart';
import 'package:nightview/screens/utility/emoji_priority_helper.dart';
import 'package:nightview/utilities/club_data/club_name_formatter.dart';
import 'package:nightview/utilities/club_data/club_opening_hours_formatter.dart';
import 'package:nightview/utility/utility.dart';
import 'package:nightview/widgets/stateful/favorite_club_button.dart';
import 'package:nightview/widgets/stateful/like_club_button.dart';
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
    Provider.of<GlobalProvider>(context, listen: false).setChosenClub(club);

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
    Widget topPart = SizedBox(
      height: 250, // 200 for image, 50 for the logo overlap, 50 for room
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClubCoverImage(
            clubId: club.id,
          ),
          Positioned(
            top: 150,
            left: 16,
            right: 16,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Column with name and buttons now split vertically
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Club name full width
                      SizedBox(
                        width: screenWidth * 0.6,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
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

                      Row(
                        children: [
                          const FavoriteClubButton(),
                          const LikeClubButton(),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                // Logo
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
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    SizedBox(
      height: 30,
    );
    // Bottom part: Bookings, opening hours, rating, tags, and buttons
    Widget bottomPart = Container(
      color: black,
      padding:
          const EdgeInsets.only(top: 30.0, left: 10, right: 10, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // BOOKINGS (aligned with top of right column)
              // if (POSSIBLE TO BOOK)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.mail_outline_outlined,
                          color: primaryColor),
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
                          style: TextStyle(
                              color: white, fontWeight: FontWeight.w600),
                        ),
                      ),
                      //TODO FIX FUNCTIONALLITY
                    ],
                  ),
                ],
              ),

              // RIGHT: OPENING HOURS + RATING
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IntrinsicWidth(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9.0, vertical: 3.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: white,
                            ),
                          ),
                          child: Text(
                            ClubOpeningHoursFormatter
                                .displayClubOpeningHoursTodaySimple(club),
                            style: const TextStyle(fontSize: 13, color: white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9.0, vertical: 0),
                          decoration: BoxDecoration(
                            color: grey,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 0),
                                decoration: BoxDecoration(
                                  color: white,
                                  border:
                                      Border.all(color: primaryColor, width: 3),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  (club.rating).toStringAsFixed(1),
                                  style: const TextStyle(
                                    color: black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Row(
                                textDirection: TextDirection.rtl,
                                children: List.generate(5, (index) {
                                  final rating = club.rating ?? 0.0;
                                  if (rating >= index + 1) {
                                    return const Icon(Icons.star,
                                        color: primaryColor, size: 14);
                                  } else if (rating > index) {
                                    return const Icon(Icons.star_half,
                                        color: primaryColor, size: 14);
                                  } else {
                                    return const Icon(Icons.star_border,
                                        color: primaryColor, size: 14);
                                  }
                                }),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FutureBuilder<String>(
                            future: fetchRatingCount(club.id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox.shrink();
                              }

                              final ratingText = snapshot.data ?? '';
                              return Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  ratingText,
                                  style: const TextStyle(
                                    color: white,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40.0),
          if (club.tags != null && club.tags!.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: white, width: 1.5),
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
                          border: Border.all(color: primaryColor, width: 1.5),
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
          const SizedBox(height: 32.0),
          FutureBuilder<bool>(
            future: doesBarcardExist(club.id),
            builder: (context, snapshot) {
              final clubHasBarCard =
                  snapshot.connectionState == ConnectionState.done &&
                      snapshot.data == true;

              return Row(
                mainAxisAlignment: clubHasBarCard
                    ? MainAxisAlignment.spaceEvenly
                    : MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ClubMoreInfoScreen(club: club),
                        ),
                      );
                    },
                    child: Container(
                      width: screenWidth * 0.28,
                      height: screenHeight * 0.04,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: black,
                        border: Border.all(color: white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "More Info",
                        style: TextStyle(
                          color: white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  if (clubHasBarCard)
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ClubBarCardScreen(club: club),
                          ),
                        );
                      },
                      child: Container(
                        width: screenWidth * 0.28,
                        height: screenHeight * 0.04,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: black,
                          border: Border.all(color: white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "Bar Card",
                          style: TextStyle(
                              color: white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
    SizedBox(
      height: goodHeightSeperater,
    );

    // --- Bottom Sheet Content (original content) ---

    final List<Widget> bottomSheetContent = [
      if (club.offerType != OfferType.none) ...[
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
                  // image: DecorationImage(
                  // image: AssetImage(
                  // "images/swipe/12.png"), // Replace with dynamic offer image if needed
                  // fit: BoxFit.cover,
                  // ),
                  ),
            ),
          ),
        ),
      ],
      SizedBox(
        height: goodHeightSeperater,
      ),
      if (club.visitors >= 30) ...[
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
      ],
      SizedBox(
        height: goodHeightSeperater,
      ),
      MoodImageScroller(club: club),
      // Maybe show somehting helse here if nonthing above
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
      bottomSheetColor: transparent, // Ensures no overlay
      headerBuilder: (context, offset) => const SizedBox.shrink(),
      bodyBuilder: (context, offset) => SliverChildListDelegate([
        Container(
          decoration: BoxDecoration(
            color: black, // Background color
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(kHugeSizeRadius)), // Rounded top corners
            border: Border.all(color: grey, width: 0.6), // Border color
          ),
          clipBehavior: Clip.hardEdge, // Clips content to container shape
          child: ClipRRect(
            // Additional clipping for Stack content
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(kHugeSizeRadius)),
            child: Column(
              children: allContent, // Existing content
            ),
          ),
        ),
      ]),
    );

    sheet.then((_) {
      _isBottomSheetOpen = false; // Reset flag when sheet closes
    });
  }

  static Future<bool> doesBarcardExist(String clubId) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('club_images/$clubId/barcard.pdf');
      await ref.getDownloadURL();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<String> fetchRatingCount(String clubId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('club_data')
          .doc(clubId)
          .collection('ratings')
          .get();

      final count = snapshot.docs.length;
      return '($count)';
      // count >= 10 ? '($count)' : '';
    } catch (e) {
      return '';
    }
  }
}
