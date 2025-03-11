import 'package:flutter/material.dart';
import 'package:nightview/app_localization.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSignInManager extends StatelessWidget {
  //TODO
  const AppleSignInManager({super.key});

  static Future<void> handleAppleSignIn(BuildContext context) async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      // Handle successful login here
      print(
          '${AppLocalizations.of(context)!.appleSignInSuccessful} ${credential.email}');
    } catch (error) {
      print('${AppLocalizations.of(context)!.appleSignInFailed} $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
