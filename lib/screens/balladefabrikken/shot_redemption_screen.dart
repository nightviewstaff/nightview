import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/icons.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/generated/l10n.dart';
import 'package:nightview/helpers/misc/custom_data_helper.dart';
import 'package:nightview/helpers/misc/referral_points_helper.dart';
import 'package:nightview/providers/balladefabrikken_provider.dart';
import 'package:provider/provider.dart';
import 'package:slider_button/slider_button.dart';

class ShotRedemtionScreen extends StatefulWidget {
  static String id = 'shot_redemption_screen';

  const ShotRedemtionScreen({super.key});

  @override
  State<ShotRedemtionScreen> createState() => _ShotRedemtionScreenState();
}

class _ShotRedemtionScreenState extends State<ShotRedemtionScreen> {
  Future<void> showSuccesDialog(int shotsRedeemed) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          S.of(context).redemption_successful,
          style: TextStyle(color: primaryColor),
        ),
        content: SingleChildScrollView(
          child: Text(
            '${S.of(context).you_redeemed} ${shotsRedeemed < 10 ? '$shotsRedeemed ${shotsRedeemed == 1 ? S.of(context).shot : S.of(context).shots}' : '1 ${S.of(context).bottle}'}',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              S.of(context).ok,
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
          S.of(context).redemption_failed,
          style: TextStyle(color: Colors.redAccent),
        ),
        content: SingleChildScrollView(
          child: Text(S.of(context).redemption_error),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              S.of(context).ok,
              style: TextStyle(color: Colors.redAccent),
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(kBiggerPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AspectRatio(
                aspectRatio: 1.0,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                              AssetImage('images/balladefabrikken_shots.jpg'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(kMainBorderRadius),
                        ),
                        border: Border.all(
                          color: Colors.white,
                          width: kFocussedStrokeWidth,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(kMainPadding),
                        child: Text(
                          Provider.of<BalladefabrikkenProvider>(context)
                                      .redemtionCount <
                                  10
                              ? '${Provider.of<BalladefabrikkenProvider>(context).redemtionCount} ${Provider.of<BalladefabrikkenProvider>(context).redemtionCount == 1 ? S.of(context).shot : S.of(context).shots}'
                              : '1 ${S.of(context).bottle}',
                          style: kTextStyleH2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: kNormalSpacerValue,
              ),
              SliderButton(
                width: MediaQuery.of(context).size.width * 0.8,
                height: kSliderHeight,
                backgroundColor: Colors.white.withAlpha(0x44),
                baseColor: primaryColor,
                buttonColor: primaryColor,
                vibrationFlag: true,
                label: Text(
                  S.of(context).redeem_button,
                  style: kTextStyleH1,
                ),
                alignLabel: Alignment.centerLeft,
                icon: FaIcon(
                  defaultDownArrow,
                  size: kSliderHeight * 0.5,
                ),
                action: () async {
                  int redemtionCount = Provider.of<BalladefabrikkenProvider>(
                          context,
                          listen: false)
                      .redemtionCount;
                  bool succes =
                      await ReferralPointsHelper.incrementReferralPoints(
                          -redemtionCount);
                  if (succes) {
                    await showSuccesDialog(redemtionCount);
                    Provider.of<BalladefabrikkenProvider>(context,
                            listen: false)
                        .points -= redemtionCount;
                    Provider.of<BalladefabrikkenProvider>(context,
                                listen: false)
                            .redemtionCount =
                        min(
                            10,
                            Provider.of<BalladefabrikkenProvider>(context,
                                    listen: false)
                                .points);
                    Provider.of<BalladefabrikkenProvider>(context,
                            listen: false)
                        .points -= redemtionCount;
                    Provider.of<BalladefabrikkenProvider>(context,
                                listen: false)
                            .redemtionCount =
                        min(
                            10,
                            Provider.of<BalladefabrikkenProvider>(context,
                                    listen: false)
                                .points);
                  } else {
                    await showErrorDialog();
                  }
                  Navigator.of(context).pop();
                  return null;
                },
              ),
              SizedBox(
                height: kNormalSpacerValue,
              ),
              SizedBox(
                height: kBottomSpacerValue,
                child: Column(
                  children: [
                    FutureBuilder(
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            '${S.of(context).shot_redemption_info}:\n${snapshot.data}',
                            textAlign: TextAlign.center,
                            style: kTextStyleP1,
                          );
                        } else {
                          return SpinKitPouringHourGlass(
                            color: primaryColor,
                          );
                        }
                      },
                      future: CustomDataHelper
                          .getBalladeFabrikkenCertifiedAsString(),
                    ),
                    SizedBox(
                      height: kNormalSpacerValue,
                    ),
                    Text(
                      S.of(context).redemption_warning,
                      textAlign: TextAlign.center,
                      style: kTextStyleP1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
