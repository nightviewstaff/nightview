import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:nightview/generated/l10n.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/screens/login_registration/login/login_google_screen.dart';
import 'package:nightview/screens/login_registration/utility/custom_dialog_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSignInHelper {
  static Future<void> handleGoogleSignIn(BuildContext context) async {
    GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

    try {
      final GoogleSignInAccount? googleAccount = await googleSignIn.signIn();

      if (googleAccount == null) {
        CustomDialogHelper.showErrorDialog(
            context, S.of(context).error, S.of(context).google_login_cancelled);
        return;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('fullName', googleAccount.displayName ?? '');
      await prefs.setString('email', googleAccount.email);
      await prefs.setString('profilePicture', googleAccount.photoUrl ?? '');

      final provider = Provider.of<GlobalProvider>(context, listen: false);
      provider.setProfilePicture(googleAccount.photoUrl ?? '');

      Navigator.of(context).pushReplacementNamed(LoginGoogleScreen.id);
    } catch (error) {
      CustomDialogHelper.showErrorDialog(
          context, S.of(context).error, S.of(context).google_login_error);
    }
  }
}
