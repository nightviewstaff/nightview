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
import 'package:nightview/generated/l10n.dart';
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
              S.of(context).credential_error,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
          ),
        );
      } else if (newRedemtions > 0) {
        bool succes =
            await ReferralPointsHelper.incrementReferralPoints(newRedemtions);
        String msg = S.of(context).points_update_error;
        if (succes) {
          msg =
              '${S.of(context).points_earned} $newRedemtions ${S.of(context).points_since_last}';
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
              S.of(context).points_load_error,
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
                  // Share NightView header
                  Padding(
                    padding: const EdgeInsets.all(kMainPadding),
                    child: Text.rich(
                      TextSpan(
                        text: S.of(context).share,
                        style: kTextStyleH2,
                        children: [
                          TextSpan(
                            text: ' NightView',
                            style: kTextStyleH2.copyWith(
                              color: primaryColor,
                            ),
                          ),
                          TextSpan(
                            text: '!', // Exclamation mark remains literal.
                            style: kTextStyleH2,
                          )
                        ],
                      ),
                    ),
                  ),
                  // Points container
                  Container(
                    padding: EdgeInsets.all(kMainPadding),
                    color: black,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(kMainPadding),
                          child: Text.rich(
                            TextSpan(
                              text: S.of(context).you_have_earned,
                              style: kTextStyleH3,
                              children: [
                                TextSpan(
                                  text:
                                      '${Provider.of<BalladefabrikkenProvider>(context).points}',
                                  style: kTextStyleH3.copyWith(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: S.of(context).points,
                                  style: kTextStyleH3,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // (The commented-out "Indløs shots!" widget remains unchanged.)
                      ],
                    ),
                  ),
                  // Link invitation text
                  Padding(
                    padding: const EdgeInsets.all(kMainPadding),
                    child: Text(
                      S.of(context).share_link_message,
                      style: kTextStyleP1,
                    ),
                  ),
                  // Phone input form
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
                                  hintText: S.of(context).enter_phone_number,
                                  hintStyle: kTextStyleP1),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return S.of(context).phone_number_required;
                                }
                                if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                  return S.of(context).invalid_phone_number;
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
                                          S.of(context).share_code_upload_error,
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
                                        S.of(context).sms_app_error,
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
                  // Bottom navigation links
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await Clipboard.setData(ClipboardData(text: iosLink));
                          await launchUrl(Uri.parse(iosLink));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(S.of(context).appStoreLinkCopied),
                            ),
                          );
                        },
                        child: Text(
                          S.of(context).appStore,
                          style: linkTextStyle,
                        ),
                      ),
                      if (Platform.isAndroid)
                        GestureDetector(
                          onTap: () async {
                            await Clipboard.setData(
                                ClipboardData(text: androidLink));
                            await launchUrl(Uri.parse(androidLink));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text(S.of(context).googlePlayLinkCopied),
                              ),
                            );
                          },
                          child: Text(
                            S.of(context).googlePlay,
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
                            height: 0,
                            width: 0,
                          );
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
                  // SizedBox(height: 10), Future release: QR code widget
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
