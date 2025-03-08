import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nightview/constants/button_styles.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/input_decorations.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/helpers/misc/referral_points_helper.dart';
import 'package:nightview/helpers/misc/share_code_helper.dart';
import 'package:nightview/helpers/users/misc/sms_helper.dart';
import 'package:nightview/providers/balladefabrikken_provider.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:qr_flutter/qr_flutter.dart';

class BalladefabrikkenMainScreen extends StatefulWidget {
  static String id = 'balladefabrikken_main_screen';

  const BalladefabrikkenMainScreen({super.key});

  @override
  State<BalladefabrikkenMainScreen> createState() =>
      _BalladefabrikkenMainScreenState();
}

class _BalladefabrikkenMainScreenState
    extends State<BalladefabrikkenMainScreen> {
  final _phoneInputController = TextEditingController();
  final _codeInputController = TextEditingController();
  final _phoneFormKey = GlobalKey<FormState>();
  final _shotFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      int? newRedemtions = await ShareCodeHelper.redeemAcceptedCodes();

      if (newRedemtions == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Der skete en fejl under indlæsning af nye referencer',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
          ),
        );
      } else if (newRedemtions > 0) {
        bool succes =
            await ReferralPointsHelper.incrementReferralPoints(newRedemtions);
        String msg = 'Der skete en fejl under opdatering af point';
        if (succes) {
          msg = 'Du har tjent $newRedemtions point siden sidst. Godt gået!';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              msg,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
          ),
        );
      }

      int? points = await ReferralPointsHelper.getPointsOfCurrentUser();
      Provider.of<BalladefabrikkenProvider>(context, listen: false).points =
          points ?? 0;
      Provider.of<BalladefabrikkenProvider>(context, listen: false)
              .redemtionCount =
          min(
              10,
              Provider.of<BalladefabrikkenProvider>(context, listen: false)
                  .points);
      if (points == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Kunne ikke indlæse optjente point',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
          ),
        );
      }
    });
    super.initState();
  }

  // Widget shareNightViewWidget(){
  //
  // }

  // Widget getSendShotWidget(BuildContext context) => Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  // Padding(
  //   padding: EdgeInsets.all(kMainPadding),
  //   child: Text(
  //     'Giv et shot',
  //     style: kTextStyleH2,
  //   ),
  // ),
  // Padding(
  //   padding: EdgeInsets.all(kMainPadding),
  //   child: Form(
  //     key: _shotFormKey,
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  // Expanded(
  //   child: TextFormField(
  //     controller: _codeInputController,
  //     decoration: kMainInputDecoration.copyWith(
  //       hintText: 'Indtast kode',
  //     ),
  //     keyboardType: TextInputType.visiblePassword,
  //     validator: (value) {
  //       if (value == null || value.isEmpty) {
  //         return 'Skriv venligst en kode';
  //       }
  //       if (!RegExp(r'^[A-Za-z0-9]+$').hasMatch(value)) {
  //         return 'Ugyldig kode';
  //       }
  //       return null;
  //     },
  //   ),
  // ),
  // SizedBox(
  //   width: kSmallSpacerValue,
  // ),
  // FilledButton(
  //   onPressed: () async {
  //     bool? valid = _shotFormKey.currentState?.validate();
  //     if (valid == null) {
  //       return;
  //     }
  //     if (valid) {
  //       bool continueAction = false;
  //       await showDialog(
  //         context: context,
  //         barrierDismissible: false,
  //         builder: (context) => AlertDialog(
  //           title: Text('Er du sikker?'),
  //           content: SingleChildScrollView(
  //             child: Text(
  //                 'Du kan kun give én ven et shot. Når du har givet et shot, kan du ikke give flere shots. Vil du fortsætte?'),
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: Text(
  //                 'Nej',
  //                 style: TextStyle(color: Colors.redAccent),
  //               ),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //                 continueAction = true;
  //               },
  //               child: Text(
  //                 'Ja',
  //                 style: TextStyle(color: primaryColor),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //       if (!continueAction) {
  //         return;
  //       }
  //       String code = _codeInputController.text;
  //       String? status =
  //           await ShareCodeHelper.getStatusOfCode(code);
  //       if (status == 'pending') {
  //         bool succes = await ShareCodeHelper.sendShot(code);
  //         String msg = 'Der skete en fejl under indløsning';
  //         if (succes) {
  //           msg = 'Du sendte et shot!';
  //           await ReferralPointsHelper.setSentStatus(true);
  //         }
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text(
  //               msg,
  //               style: TextStyle(color: Colors.white),
  //             ),
  //             backgroundColor: Colors.black,
  //           ),
  //         );
  //       } else {
  //         String errorMsg =
  //             'Der skete en fejl under indløsning';
  //         if (status == null) {
  //           errorMsg = 'Denne kode findes ikke';
  //         } else if (status == 'accepted' ||
  //             status == 'redeemed') {
  //           errorMsg =
  //               'Denne kode er allerede indløst af en anden bruger';
  //         }
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text(
  //               errorMsg,
  //               style: TextStyle(color: Colors.white),
  //             ),
  //             backgroundColor: Colors.black,
  //           ),
  //         );
  //       }
  //     }
  //   },
  //   style: kFilledButtonStyle.copyWith(
  //     fixedSize: MaterialStatePropertyAll(
  //       Size(60.0, 60.0),
  //     ),
  //   ),
  //   child: Icon(
  //     Icons.keyboard_arrow_right,
  //     size: 32,
  //   ),
  // )
  // ],
  // ),
  // ),
  // ),
  // ],
  // );

  @override
  Widget build(BuildContext context) {
    final String androidLink =
        'https://play.google.com/store/apps/details?id=com.nightview.nightview';
    final String iosLink =
        'https://apps.apple.com/dk/app/nightview/id6458585988';
    final String qrCodeLink = Platform.isAndroid ? androidLink : iosLink;

    return Scaffold(
      appBar: AppBar(
          // title: Text('NightView'),
          // 'x Balladefabrikken'),
          ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(kMainPadding),
                    child: Text.rich(
                      TextSpan(
                        text: 'Del ', // Normal text
                        style: kTextStyleH2, // Base style
                        children: [
                          TextSpan(
                            text: 'NightView', // Styled text
                            style: kTextStyleH2.copyWith(
                              color:
                                  primaryColor, // Change to your desired color
                            ),
                          ),
                          TextSpan(
                            text: '!',
                            style: kTextStyleH2,
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(kMainPadding),
                    color: black,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(kMainPadding),
                          child: Text.rich(
                            TextSpan(
                              text: 'Du har optjent ', // Static text
                              style: kTextStyleH3, // Base style
                              children: [
                                TextSpan(
                                  text:
                                      '${Provider.of<BalladefabrikkenProvider>(context).points}', // Points amount
                                  style: kTextStyleH3.copyWith(
                                    color: primaryColor,
                                    // Desired color for the points
                                    fontWeight: FontWeight
                                        .bold, // Optional: Make it bold
                                  ),
                                ),
                                TextSpan(
                                  text: ' point',
                                  // Static text after the points
                                  style: kTextStyleH3, // Use base style
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Padding(
                        //   padding: const EdgeInsets.all(kMainPadding),
                        //   child: FilledButton(
                        //     onPressed: () {
                        //       Navigator.of(context)
                        //           .pushNamed(ShotAccumulationScreen.id);
                        //     },
                        //     style: kFilledButtonStyle.copyWith(
                        //       fixedSize: MaterialStatePropertyAll(
                        //         Size(double.maxFinite, 60.0),
                        //       ),
                        //     ),
                        //     child: Padding(
                        //       padding: const EdgeInsets.all(kMainPadding),
                        //       child: Text(
                        //         'Indløs shots!',
                        //         style: kTextStyleH2,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: MediaQuery.of(context).viewInsets.bottom > 0
                        //       ? kNormalSpacerValue
                        //       : kBottomSpacerValue,
                        // ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(kMainPadding),
                    child: Text(
                      'Send et link til dine venner for at optjene point!',
                      // bed dem om at indtaste din kode for at få endnu flere shots!',
                      style: kTextStyleP1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(kMainPadding),
                    child: Form(
                      key: _phoneFormKey,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _phoneInputController,
                              decoration: kMainInputDecoration.copyWith(
                                  hintText: 'Indtast telefonnummer',
                                  hintStyle: kTextStyleP1),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Skriv venligst et telefonnummer';
                                }
                                if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                  return 'Ugyldigt tlf-nummer';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            width: kSmallSpacerValue,
                          ),
                          FilledButton(
                            onPressed: () async {
                              bool? valid =
                                  _phoneFormKey.currentState?.validate();
                              if (valid == null) {
                                return;
                              }

                              if (valid) {
                                String shareCode = await ShareCodeHelper
                                    .generateNewShareCode();
                                bool succes = await SMSHelper.launchSMS(
                                    message: ShareCodeHelper.getMessageFromCode(
                                        shareCode),
                                    phoneNumber: _phoneInputController.text);
                                if (succes) {
                                  String? userId = Provider.of<GlobalProvider>(
                                          context,
                                          listen: false)
                                      .userDataHelper
                                      .currentUserId;
                                  if (userId == null ||
                                      !(await ShareCodeHelper.uploadShareCode(
                                          code: shareCode, userId: userId))) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Delekode blev ikke uploadet til skyen. Prøv igen.',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.black,
                                      ),
                                    );
                                    return;
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Der skete en fejl under åbning af SMS-applikation',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.black,
                                    ),
                                  );
                                }
                              }
                            },
                            style: kFilledButtonStyle.copyWith(
                              fixedSize: WidgetStatePropertyAll(
                                Size(60.0, 60.0),
                              ),
                            ),
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              size: 32,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: kNormalSpacerValue,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          // Copy and open the App Store link
                          await Clipboard.setData(ClipboardData(text: iosLink));
                          await launchUrl(Uri.parse(iosLink));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('App Store link copied to clipboard!'),
                            ),
                          );
                        },
                        child: Text(
                          'App Store',
                          style: linkTextStyle,
                        ),
                      ),
                      if (Platform.isAndroid) // Only show Google Play option on Android
                        GestureDetector(
                          onTap: () async {
                            // Copy and open the Google Play link
                            await Clipboard.setData(ClipboardData(text: androidLink));
                            await launchUrl(Uri.parse(androidLink));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Google Play link copied to clipboard!'),
                              ),
                            );
                          },
                          child: Text(
                            'Google Play',
                            style: linkTextStyle,
                          ),
                        ),
                    ],
                  ),
                  FutureBuilder(
                    future: ReferralPointsHelper.getSentStatus(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data == false) {
                          return SizedBox(
                            // Quickfix
                            height: 0,
                            width: 0,
                          );
                          // return getSendShotWidget(context);
                        } else {
                          return SizedBox(
                            height: 0,
                            width: 0,
                          );
                        }
                      } else {
                        return SpinKitPouringHourGlass(color: primaryColor);
                      }
                    },
                  ),
                  // SizedBox(height: 10),Future release
                  // QrImage(
                  //   data: qrCodeLink, // The link dynamically determined by the platform
                  //   version: QrVersions.auto,
                  //   size: 200.0, // Adjust size as needed
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
