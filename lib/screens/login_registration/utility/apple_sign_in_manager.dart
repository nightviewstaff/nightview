import 'package:flutter/material.dart';
import 'package:nightview/generated/l10n.dart';
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
      print('${S.of(context).login} ${credential.email}');
    } catch (error) {
      print('${S.of(context).login_failed} $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
