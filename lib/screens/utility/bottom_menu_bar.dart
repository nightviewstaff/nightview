import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/screens/login_registration/choice/login_or_create_account_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomMenuBar extends StatelessWidget {
  const BottomMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: kMainPadding,
      right: kMainPadding,
      child: Row(
        children: [
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.lock,
              color: primaryColor,
              size: 15.0,
            ),
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: Center(
                    child: Text(
                      'Privatlivspolitik',
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                  content:
                      Text('Vil du åbne privatlivspolitikken i din browser?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      },
                      child: Text('Nej', style: TextStyle(color: grey)),
                    ),
                    TextButton(
                      onPressed: () {
                        launchUrl(
                            Uri.parse('https://night-view.dk/privacy-policy/'));
                        Navigator.of(dialogContext).pop();
                      },
                      child: Text('Ja', style: TextStyle(color: grey)),
                    ),
                  ],
                ),
              );
            },
            tooltip: 'Privatlivspolitik',
          ),
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.userSlash,
              color: redAccent,
              size: 15.0,
            ),
            onPressed: () async {
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (deleteUserContext) => AlertDialog(
                  title: Center(
                    child: Text(
                      'Slet bruger',
                      style: TextStyle(color: redAccent),
                    ),
                  ),
                  content: Text(
                    'Er du sikker på, at du vil slette din bruger? Alt data associeret med din bruger vil blive fjernet.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(deleteUserContext).pop();
                      },
                      child: Text('Nej', style: TextStyle(color: primaryColor)),
                    ),
                    TextButton(
                      onPressed: () async {
                        bool success = await Provider.of<GlobalProvider>(
                                deleteUserContext,
                                listen: false)
                            .deleteAllUserData();
                        if (success) {
                          await Navigator.of(deleteUserContext)
                              .pushNamedAndRemoveUntil(
                                  LoginOrCreateAccountScreen.id,
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
                                'Der skete en fejl under sletning af din bruger. Prøv igen senere. Hvis du oplever problemer med din bruger fremadrettet kan du sende en mail til business@night-view.dk.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(errorContext).pop();
                                  },
                                  child: Text('OK',
                                      style: TextStyle(color: primaryColor)),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: Text('Ja', style: TextStyle(color: redAccent)),
                    ),
                  ],
                ),
              );
            },
            tooltip: 'Slet bruger',
          ),
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.rightFromBracket,
              color: grey,
              size: 15.0,
            ),
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: Center(
                    child: Text(
                      'Log af',
                      style: TextStyle(color: redAccent),
                    ),
                  ),
                  content: Text('Er du sikker på, at du vil logge af?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      },
                      child: Text('Nej', style: TextStyle(color: primaryColor)),
                    ),
                    TextButton(
                      onPressed: () async {
                        await Provider.of<GlobalProvider>(context,
                                listen: false)
                            .userDataHelper
                            .signOutCurrentUser();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            LoginOrCreateAccountScreen.id, (route) => false);
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.remove('mail');
                        prefs.remove('password');
                      },
                      child: Text('Ja', style: TextStyle(color: redAccent)),
                    ),
                  ],
                ),
              );
            },
            tooltip: 'Log af',
          ),
        ],
      ),
    );
  }
}
