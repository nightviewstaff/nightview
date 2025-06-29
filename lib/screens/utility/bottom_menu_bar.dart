import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/generated/l10n.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/screens/login_registration/choice/login_or_create_account_screen.dart';
import 'package:nightview/screens/profile/setting_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileMenuDropdown extends StatelessWidget {
  const ProfileMenuDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: Icon(
        Icons.tune_sharp,
        color: primaryColor,
        size: 18,
      ),
      color: black.withOpacity(0.95),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: grey, width: 0.7),
      ),
      itemBuilder: (context) => [
        // PopupMenuItem(
        //   value: 0,
        //   child: Row(
        //     children: [
        //       Icon(Icons.settings, color: primaryColor, size: 18),
        //       SizedBox(width: 10),
        //       Text("Settings", style: kTextStyleP2),
        //     ],
        //   ),
        // ),
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(Icons.privacy_tip, color: primaryColor, size: 18),
              SizedBox(width: 10),
              Text(S.of(context).privacy_policy, style: kTextStyleP2),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              Icon(Icons.logout, color: grey, size: 18),
              SizedBox(width: 10),
              Text(S.of(context).logout, style: kTextStyleP2),
            ],
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Row(
            children: [
              Icon(Icons.delete, color: redAccent, size: 18),
              SizedBox(width: 10),
              Text(S.of(context).delete_user, style: kTextStyleP2),
            ],
          ),
        ),
      ],
      onSelected: (value) async {
        if (value == 0) {
          Navigator.of(context).pushNamed(SettingsScreen.id);
        } else if (value == 1) {
          await showDialog(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: Center(
                child: Text(S.of(context).privacy_policy,
                    style: TextStyle(color: primaryColor)),
              ),
              content: Text(S.of(context).privacy_policy_open),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(S.of(context).no, style: TextStyle(color: grey)),
                ),
                TextButton(
                  onPressed: () {
                    launchUrl(
                        Uri.parse('https://night-view.dk/privacy-policy/'));
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(S.of(context).yes, style: TextStyle(color: grey)),
                ),
              ],
            ),
          );
        } else if (value == 2) {
          await showDialog(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: Center(
                child: Text(S.of(context).logout,
                    style: TextStyle(color: redAccent)),
              ),
              content: Text(S.of(context).logout_confirmation),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(S.of(context).no,
                      style: TextStyle(color: primaryColor)),
                ),
                TextButton(
                  onPressed: () async {
                    await Provider.of<GlobalProvider>(context, listen: false)
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
        } else if (value == 3) {
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (deleteUserContext) => AlertDialog(
              title: Center(
                child: Text(S.of(context).delete_user,
                    style: TextStyle(color: redAccent)),
              ),
              content: Text(S.of(context).delete_confirmation),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(deleteUserContext).pop(),
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
                              LoginOrCreateAccountScreen.id, (route) => false);
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.remove('mail');
                      prefs.remove('password');
                    } else {
                      await showDialog(
                        context: deleteUserContext,
                        builder: (errorContext) => AlertDialog(
                          title: Text(S.of(context).delete_user_error),
                          content:
                              Text(S.of(context).delete_user_error_description),
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
        }
      },
    );
  }
}
