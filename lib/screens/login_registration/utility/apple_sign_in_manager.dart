import 'package:flutter/cupertino.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSignInManager extends StatelessWidget{ //TODO
  const AppleSignInManager({super.key});



static Future<void> handleAppleSignIn() async {
  try {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    // Handle successful login here
    print('Apple Sign-In successful: ${credential.email}');
  } catch (error) {
    print('Google Sign-In failed: $error');
  }
}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}