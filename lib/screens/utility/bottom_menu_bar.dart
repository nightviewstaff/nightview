import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/generated/l10n.dart';
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
              color: primaryColor, // Blue for privacy
              size: 15.0, // Smaller size
            ),
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: Center(
                    child: Text(
                      S.of(context).privacy_policy,
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                  content: Text(S.of(context).privacy_policy_open),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      },
                      child:
                          Text(S.of(context).no, style: TextStyle(color: grey)),
                    ),
                    TextButton(
                      onPressed: () {
                        launchUrl(
                            Uri.parse('https://night-view.dk/privacy-policy/'));
                        Navigator.of(dialogContext).pop();
                      },
                      child: Text(S.of(context).yes,
                          style: TextStyle(color: grey)),
                    ),
                  ],
                ),
              );
            },
            tooltip: S.of(context).privacy_policy,
          ),
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.userSlash,
              color: redAccent, // Red for delete
              size: 15.0,
            ),
            onPressed: () async {
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (deleteUserContext) => AlertDialog(
                  title: Center(
                    child: Text(
                      S.of(context).delete_user,
                      style: TextStyle(color: redAccent),
                    ),
                  ),
                  content: Text(
                    S.of(context).delete_confirmation,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(deleteUserContext).pop();
                      },
                      child: Text(S.of(context).no,
                          style: TextStyle(color: primaryColor)),
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
                              title: Text(S.of(context).delete_user_error),
                              content: Text(
                                S.of(context).delete_user_error_description,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(errorContext).pop();
                                  },
                                  child: Text(S.of(context).ok,
                                      style: TextStyle(color: primaryColor)),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: Text(S.of(context).yes,
                          style: TextStyle(color: redAccent)),
                    ),
                  ],
                ),
              );
            },
            tooltip: S.of(context).delete_user,
          ),
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.rightFromBracket,
              color: grey, // Grey for logout
              size: 15.0,
            ),
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: Center(
                    child: Text(
                      S.of(context).logout,
                      style: TextStyle(color: redAccent),
                    ),
                  ),
                  content: Text(S.of(context).logout_confirmation),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      },
                      child: Text(S.of(context).no,
                          style: TextStyle(color: primaryColor)),
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
                      child: Text(S.of(context).yes,
                          style: TextStyle(color: redAccent)),
                    ),
                  ],
                ),
              );
            },
            tooltip: S.of(context).logout,
          ),
        ],
      ),
    );
  }
}
