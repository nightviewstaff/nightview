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
import 'package:nightview/screens/night_map/night_map_main_offer_screen.dart';
import 'package:nightview/utilities/club_data/club_name_formatter.dart';
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

    // Get MapboxMap from provider
    final map =
        Provider.of<NightMapProvider>(context, listen: false).mapController;
    if (moveMap && map != null) {
      map.cancelCameraAnimation();
      // if distance small ease to quick
      // map.easeTo(
      //   CameraOptions(
      //       center: Point(coordinates: Position(club.lon, club.lat)),
      //       zoom: 18.0,
      //       // pitch: 60,
      //       bearing: 0),
      //   MapAnimationOptions(duration: 1000),
      // ); else

      map.flyTo(
        CameraOptions(
          center: Point(coordinates: Position(club.lon, club.lat)),
          zoom: 17.3,
          pitch: 55,
          bearing: 0,
        ),
        MapAnimationOptions(duration: 5000),
      );
    }

    _isBottomSheetOpen = true; // Set flag

    // Show the bottom sheet
    final sheet = showStickyFlexibleBottomSheet(
      context: context,
      initHeight: 0.61,
      minHeight: 0.40,
      maxHeight: 0.82,
      headerHeight: 350,
      isSafeArea: false,
      bottomSheetColor: transparent,
      decoration: BoxDecoration(color: black),
      headerBuilder: (context, offset) => ClubHeader(club: club),
      bodyBuilder: (context, offset) => SliverChildListDelegate(
        club.offerType == OfferType.none
            ? [
                centerContainer(context),
                Center(
                  child: Text(
                    '${ClubNameFormatter.displayClubName(club)} ${S.of(context).no_current_offer}',
                    style: kTextStyleP3,
                  ),
                ),
              ]
            : [
                centerContainer(context),
                SizedBox(height: kNormalSpacerValue),
                GestureDetector(
                  onTap: () {
                    if (club.offerType == OfferType.redeemable) {
                      Navigator.of(context)
                          .pushNamed(NightMapMainOfferScreen.id);
                    }
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
                      padding: EdgeInsets.all(kMainPadding),
                    ),
                  ),
                ),
              ],
      ),
    );

    // Workaround for onDismiss: Wait for the sheet to close
    sheet.then((_) {
      _isBottomSheetOpen = false; // Reset flag when sheet closes
    });
  }

  static Container centerContainer(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Text(S.of(context).main_offer, style: kTextStyleH1),
    );
  }
}
