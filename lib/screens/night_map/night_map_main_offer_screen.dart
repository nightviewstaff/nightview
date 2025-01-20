import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/constants/icons.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:provider/provider.dart';
import 'package:slider_button/slider_button.dart';

class NightMapMainOfferScreen extends StatefulWidget {
  static const id = 'night_map_main_offer_screen';

  const NightMapMainOfferScreen({super.key});

  @override
  State<NightMapMainOfferScreen> createState() =>
      _NightMapMainOfferScreenState();
}

class _NightMapMainOfferScreenState extends State<NightMapMainOfferScreen> {
  MainOfferRedemptionPermisson canRedeem = MainOfferRedemptionPermisson.pending;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      String? currentUserId;
      do {
        currentUserId = Provider.of<GlobalProvider>(context, listen: false).userDataHelper.currentUserId;
        await Future.delayed(Duration(milliseconds: 100));
      } while (currentUserId == null);
      String clubId =
          Provider.of<GlobalProvider>(context, listen: false).chosenClub.id;
      Provider.of<GlobalProvider>(context, listen: false)
          .mainOfferRedemptionsHelper
          .getLastRedemption(userId: currentUserId, clubId: clubId)
          .then((timestamp) {
        DateTime threshold = DateTime.now().subtract(Duration(hours: 12));
        setState(() {
          canRedeem = (timestamp.isBefore(threshold))
              ? MainOfferRedemptionPermisson.granted
              : MainOfferRedemptionPermisson.denied;
        });
      });
    });
  }

  Widget getBottomContent() {
    switch (canRedeem) {
      case MainOfferRedemptionPermisson.pending:
        return Container(
          height: kBottomSpacerValue + kSliderHeight,
          child: SpinKitPouringHourGlass(
            color: primaryColor,
            size: 150,
            strokeWidth: 2.0,
          ),
        );

      case MainOfferRedemptionPermisson.granted:
        return Container(
          height: kBottomSpacerValue + kSliderHeight,
          child: Column(
            children: [
              SliderButton(
                width: MediaQuery.of(context).size.width * 0.8,
                height: kSliderHeight,
                backgroundColor: Colors.white.withAlpha(0x44),
                baseColor: primaryColor,
                buttonColor: primaryColor,
                vibrationFlag: true,
                action: () async {
                  String? currentUserId =
                      Provider.of<GlobalProvider>(context, listen: false)
                          .userDataHelper
                          .currentUserId;
                  String clubId =
                      Provider.of<GlobalProvider>(context, listen: false)
                          .chosenClub
                          .id;
                  if (currentUserId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Der skete en fejl',
                          style: TextStyle(color: white),
                        ),
                        backgroundColor: black,
                      ),
                    );
                    return;
                  }
                  bool succes = await Provider.of<GlobalProvider>(context,
                          listen: false)
                      .mainOfferRedemptionsHelper
                      .uploadRedemption(userId: currentUserId, clubId: clubId);

                  succes ? await showSuccesDialog() : await showErrorDialog();

                  Navigator.of(context).pop();
                },
                label: Text(
                  '            Indløs',
                  style: kTextStyleH1,
                ),
                alignLabel: Alignment.centerLeft,
                icon: FaIcon(
                  defaultDownArrow,
                  //color: Colors.black,
                  size: kSliderHeight * 0.5,
                ),
              ),
              SizedBox(
                height: kNormalSpacerValue,
              ),
              Text(
                'VIGTIGT:\nVis til personalet at du indløser tilbuddet.\nEllers er indløsningen ugyldig!',
                textAlign: TextAlign.center,
                style: kTextStyleP1,
              ),
            ],
          ),
        );

      case MainOfferRedemptionPermisson.denied:
        return Container(
          height: kSliderHeight + kBottomSpacerValue,
          child: Text(
            'Du har allerede indløst dette tilbud i dag.\nKom igen i morgen!',
            textAlign: TextAlign.center,
            style: kTextStyleP1,
          ),
        );
    }
  }

  Future<void> showSuccesDialog() async {
    ClubData chosenClub =
        Provider.of<GlobalProvider>(context, listen: false).chosenClub;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'Indløsning succesfuld!',
          style: TextStyle(color: primaryColor),
        ),
        content: SingleChildScrollView(
          child: Text(
              'Indløsning af hovedtilbud ved ${chosenClub.name} blev fuldført.'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'OK',
              style: TextStyle(color: primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showErrorDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'Indløsning mislykkedes',
          style: TextStyle(color: redAccent),
        ),
        content: SingleChildScrollView(
          child: Text(
              'Der skete en fejl ved indløsning af hovedtilbuddet.\nPrøv igen senere.'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'OK',
              style: TextStyle(color: redAccent),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(kCardPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(Provider.of<GlobalProvider>(context)
                        .chosenClub
                        .mainOfferImg!),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(kMainBorderRadius),
                  ),
                  border: Border.all(
                    color: canRedeem == MainOfferRedemptionPermisson.granted
                        ? primaryColor
                        : redAccent,
                    width: kFocussedStrokeWidth,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: kNormalSpacerValue,
            ),
            getBottomContent(),
          ],
        ),
      ),
    );
  }
}
