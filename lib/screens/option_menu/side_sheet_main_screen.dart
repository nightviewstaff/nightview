import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/app_localization.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/constants/icons.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/screens/login_registration/choice/login_or_create_account_screen.dart';
import 'package:nightview/screens/profile/my_profile_main_screen.dart';
import 'package:nightview/screens/option_menu/bottom_sheet_status_screen.dart';
import 'package:nightview/widgets/stateless/language_switcher.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SideSheetMainScreen extends StatefulWidget {
  const SideSheetMainScreen({super.key});

  @override
  State<SideSheetMainScreen> createState() => _SideSheetMainScreenState();
}

class _SideSheetMainScreenState extends State<SideSheetMainScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      String? currentUserId =
          Provider.of<GlobalProvider>(context, listen: false)
              .userDataHelper
              .currentUserId;
      PartyStatus status = Provider.of<GlobalProvider>(context, listen: false)
              .userDataHelper
              .userData[currentUserId]
              ?.partyStatus ??
          PartyStatus.unsure;
      Provider.of<GlobalProvider>(context, listen: false)
          .setPartyStatusLocal(status);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: black,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.arrowRight, // MAKE Variable
                  ),
                  onTap: () {
                    Navigator.of(context).pop(); // Action for ListTile tap
                  },
                  trailing: GestureDetector(
                    onTap: () {
                      //TODO
                    },
                    child: Icon(
                      1 > 0 //TODO Location
                          ? defaultLocationDot
                          : defaultLocationDotLocked,
                      color: 1 > 2 // Same
                          ? primaryColor
                          : grey,
                      grade: 15.0,
                    ),
                  ),
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.profile),
                  leading: CircleAvatar(
                    backgroundImage:
                        Provider.of<GlobalProvider>(context).profilePicture,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //    FaIcon(
                      //     FontAwesomeIcons.solidCircleDot,
                      //    color: Provider.of<GlobalProvider>(context)
                      //         .partyStatusColor,
                      //    size: 20.0,
                      //   ),
                      //  SizedBox(
                      //     width: 30.0), // Add some spacing between dot and flag

                      LanguageSwitcher(
                        radius: 15.0,
                        borderRadius: 25.0,
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(MyProfileMainScreen.id);
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: kMainPadding),
                  child: Divider(
                    color: white,
                    thickness: kMainStrokeWidth,
                  ),
                ),
                ListTile(
                  //      title: Text('Skift status'),
                  leading: FaIcon(
                    FontAwesomeIcons.solidCircleDot,
                    color:
                        Provider.of<GlobalProvider>(context).partyStatusColor,
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => BottomSheetStatusScreen(),
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
