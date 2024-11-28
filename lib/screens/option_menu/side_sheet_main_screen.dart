import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/screens/login_registration/login_registration_option_screen.dart';
import 'package:nightview/screens/profile/my_profile_main_screen.dart';
import 'package:nightview/screens/option_menu/bottom_sheet_status_screen.dart';
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
      String? currentUserId = Provider.of<GlobalProvider>(context, listen: false)
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
                    FontAwesomeIcons.arrowRight,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('Se profil'),
                  leading: CircleAvatar(
                    backgroundImage: Provider.of<GlobalProvider>(context).profilePicture,
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
                  title: Text('Skift status'),
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
            Column(
              children: [
                ListTile(
                  title: Text('Privatlivspolitik'),
                  leading: FaIcon(
                    FontAwesomeIcons.lock,
                  ),
                  onTap: () {
                    launchUrl(Uri.parse('https://nightview.dk/privatlivspolitik'));
                  },
                ),
                ListTile(
                  title: Text('Slet bruger'),
                  leading: FaIcon(
                    FontAwesomeIcons.userSlash,
                  ),
                  onTap: () async {
                    await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (deleteUserContext) => AlertDialog(
                        title: Text('Slet bruger'),
                        content: Text(
                            'Er du sikker på, at du vil slette din bruger? Alt data associeret med din bruger vil blive fjernet.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(deleteUserContext).pop();
                            },
                            child: Text(
                              'Nej',
                              style: TextStyle(color: redAccent),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              bool succes = await Provider.of<GlobalProvider>(
                                  deleteUserContext,
                                      listen: false)
                                  .deleteAllUserData();
                              if (succes) {
                                await Navigator.of(deleteUserContext)
                                    .pushNamedAndRemoveUntil(
                                    LoginRegistrationOptionScreen.id,
                                        (route) => false);
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.remove('mail');
                                prefs.remove('password');
                              } else {
                                await showDialog(
                                  context: deleteUserContext,
                                  builder: (errorContext) => AlertDialog(
                                    title: Text('Fejl ved sletning af bruger'),
                                    content: Text(
                                        'Der skete en fejl under sletning af din bruger. Prøv igen senere. Hvis du oplever problemer med din bruger fremadrettet kan du sende en mail til help@nightview.dk.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(errorContext).pop();
                                        },
                                        child: Text(
                                          'OK',
                                          style: TextStyle(color: primaryColor),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }
                            },
                            child: Text(
                              'Ja',
                              style: TextStyle(color: primaryColor),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text('Log af'),
                  leading: FaIcon(
                    FontAwesomeIcons.rightFromBracket,
                  ),
                  onTap: () async {
                    await Provider.of<GlobalProvider>(context, listen: false)
                        .userDataHelper
                        .signOutCurrentUser();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        LoginRegistrationOptionScreen.id, (route) => false);
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove('mail');
                    prefs.remove('password');
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
