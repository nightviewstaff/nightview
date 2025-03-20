import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:nightview/constants/enums.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/generated/l10n.dart';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:nightview/screens/night_map/night_map_main_offer_screen.dart';
import 'package:nightview/utilities/club_data/club_name_formatter.dart';
import 'package:nightview/widgets/stateless/club_header.dart';

class ClubBottomSheet {
  static void showClubSheet(
      {required BuildContext context, required ClubData club}) {
    // TODO Move to seperate class
    showStickyFlexibleBottomSheet(
      context: context,
      initHeight: 0.40,
      // maybe more?
      minHeight: 0.41,
      maxHeight: 0.82,
      // club.offerType == OfferType.none ? 0.3 : 1,
      headerHeight: 350,
      isSafeArea: false,
      bottomSheetColor: Colors.transparent,
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      headerBuilder: (context, offset) => ClubHeader(
        club: club,
        // userLocation: LocationService.getUserLocation(),
      ),
      bodyBuilder: (context, offset) => SliverChildListDelegate(
        club.offerType == OfferType.none
            ? [
                centerContainer(context),
                Center(
                  child: Text(
                    '${ClubNameFormatter.displayClubName(club)} ${S.of(context).no_current_offer}',
                    // AppLocalizations.of(context)!.noOfferRightNow
                    style: kTextStyleP3, // Add your desired text style
                  ),
                )
              ]
            : [
                centerContainer(context),
                SizedBox(
                  height: kNormalSpacerValue,
                ),
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
  }

  static Container centerContainer(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Text(
        // AppLocalizations.of(context)!.mainOffer,
        S.of(context).main_offer,
        style: kTextStyleH1,
      ),
    );
  }
}
