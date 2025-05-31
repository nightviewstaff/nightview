import 'dart:ffi';

import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/generated/l10n.dart';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:nightview/providers/night_map_provider.dart';
import 'package:nightview/screens/main_screen.dart';
import 'package:nightview/screens/night_map/night_map.dart';
import 'package:nightview/screens/night_map/night_map_main_offer_screen.dart';
import 'package:nightview/screens/night_map/night_map_main_screen.dart';
import 'package:nightview/utilities/club_data/club_name_formatter.dart';
import 'package:nightview/widgets/stateful/mood_images_scroller.dart';
import 'package:nightview/widgets/stateless/club_header.dart';
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

    if (moveMap) {
      if (map != null) {
        // If the map is already initialized, fly to the club location
        map.flyTo(
          CameraOptions(
            center: Point(coordinates: Position(club.lon, club.lat)),
            zoom: 17.3,
            pitch: 55,
            bearing: 0,
          ),
          MapAnimationOptions(duration: 4000),
        );
      } else {
        //TODO
        // If the map is not initialized, navigate to NightMapMainScreen
        // Navigator.of(context).pushReplacementNamed(NightMapMainScreen.id);
        // showClubSheet(context: context, club: club);
      }
    }

    _isBottomSheetOpen = true; // Set flag

    // Show the bottom sheet
    final List<Widget> bottomSheetContent = [];

    if (club.offerType != OfferType.none) {
      bottomSheetContent.addAll([
        GestureDetector(
          onTap: () {
            // if (club.offerType == OfferType.redeemable) {
            //   Navigator.of(context).pushNamed(NightMapMainOfferScreen.id);
            // }
          },
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(club.mainOfferImg!),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.bottomRight,
            ),
          ),
        ),
        const Divider(
          thickness: kThinStrokeWidth,
          color: white,
        ),
      ]);
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    bottomSheetContent.add(
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
                          fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: " Lige nu",
                      style: const TextStyle(
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
                          "${((club.visitors / club.totalPossibleAmountOfVisitors) * 100).round()}%",
                      style: const TextStyle(
                          color: primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: " Fyldt",
                      style: const TextStyle(
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
    );

    bottomSheetContent.add(MoodImageScroller(club: club));

    final sheet = showStickyFlexibleBottomSheet(
      context: context,
      initHeight: 0.61,
      minHeight: 0.40,
      maxHeight: 0.82,
      headerHeight: 200,
      bottomSheetColor: black,
      headerBuilder: (context, offset) => ClubHeader(club: club),
      bodyBuilder: (context, offset) => SliverChildListDelegate([
        // Wrap the content in a SizedBox with a constrained height
        SizedBox(
          height: screenHeight * 0.4, // Limit the body height to 40% of screen
          child: SingleChildScrollView(
            child: Column(
              children: bottomSheetContent,
            ),
          ),
        ),
      ]),
    );

    sheet.then((_) {
      _isBottomSheetOpen = false; // Reset flag when sheet closes
    });
  }
}
