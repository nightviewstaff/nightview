import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/screens/location_permission/location_permission_checker_screen.dart';
import 'package:nightview/widgets/stateless/login_registration_confirm_button.dart';
import 'package:nightview/widgets/stateless/login_registration_layout.dart';

class RegistrationWelcomeScreen extends StatelessWidget {
  static const id = 'registration_welcome_screen';

  const RegistrationWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginRegistrationLayout(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GlowText(
            'VELKOMMEN TIL',
            style: kTextStyleH1,
            blurRadius: 20.0,
          ),
          Image.asset('images/logo_text_subtitle.png'),
        ],
      ),
      content: Column(
        children: [
          GlowText(
            'Ha\' den bedste bytur med alle dine nære venner',
            textAlign: TextAlign.center,
            style: kTextStyleH3,
            blurRadius: kNormalSizeRadius,
          ),
          SizedBox(
            height: kNormalSpacerValue,
          ),
          LoginRegistrationConfirmButton(
            text: 'Start festen',
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(LocationPermissionCheckerScreen.id, (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
