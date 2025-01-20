import 'package:flutter/material.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/screens/login_registration/login_main_screen.dart';
import 'package:nightview/screens/login_registration/registration_name_screen.dart';
import 'package:nightview/widgets/stateless/login_registration_button.dart';

class LoginRegistrationOptionScreen extends StatelessWidget {
  static const id = 'login_registration_option_screen';

  const LoginRegistrationOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  'images/logo_text_subtitle.png',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: LoginRegistrationButton(
                      text: 'Log ind',
                      type: LoginRegistrationButtonType.transparent,
                      onPressed: () {
                        Navigator.of(context).pushNamed(LoginMainScreen.id);
                      },
                    ),
                  ),
                  SizedBox(
                    height: kNormalSpacerValue,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: LoginRegistrationButton(
                      text: 'Opret profil',
                      type: LoginRegistrationButtonType.filled,
                      onPressed: () {
                        Navigator.of(context).pushNamed(RegistrationNameScreen.id);
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 160.0,
            ),
          ],
        ),
      ),
    );
  }
}
