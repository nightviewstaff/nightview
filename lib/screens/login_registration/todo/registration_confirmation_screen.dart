import 'package:flutter/material.dart';
import 'package:nightview/constants/input_decorations.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/providers/login_registration_provider.dart';
import 'package:nightview/screens/login_registration/creation/create_account_screen_three_password.dart';
import 'package:nightview/widgets/stateless/login_registration_confirm_button.dart';
import 'package:nightview/widgets/stateless/login_registration_layout.dart';
import 'package:provider/provider.dart';

class RegistrationConfirmationScreen extends StatefulWidget { // TODO PRelude is working. Maybe use firebase instead?
  static const id = 'registration_confirmation_screen';

  const RegistrationConfirmationScreen({super.key});

  @override
  State<RegistrationConfirmationScreen> createState() =>
      _RegistrationConfirmationScreenState();
}

class _RegistrationConfirmationScreenState
    extends State<RegistrationConfirmationScreen> {
  final _formKey = GlobalKey<FormState>();

  bool inputIsFilled = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginRegistrationProvider>(
      builder: (context, provider, child) => Form(
        key: _formKey,
        child: LoginRegistrationLayout(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Du er blevet tilsendt en bekræftelseskode:',
                textAlign: TextAlign.center,
                style: kTextStyleH2,
              ),
              SizedBox(
                height: kSmallSpacerValue,
              ),
              Text(
                provider.mail,
                textAlign: TextAlign.center,
                style: kTextStyleP2,
              ),
              SizedBox(
                height: kNormalSpacerValue * 2,
              ),
              Text(
                'Skriv koden for at fortsætte',
                textAlign: TextAlign.center,
                style: kTextStyleH2,
              ),
              SizedBox(
                height: kSmallSpacerValue,
              ),
              Text(
                'Tjek din spam mappe, hvis den ikke dukker op',
                textAlign: TextAlign.center,
                style: kTextStyleP2,
              ),
            ],
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                decoration: kMainInputDecoration.copyWith(
                  hintText: '4-cifret kode',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  inputIsFilled = !(value.isEmpty);
                  provider.setCanContinue(inputIsFilled);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Skriv venligst en bekræftelseskode';
                  }
                  if (!RegExp(r'^[0-9]{4}$').hasMatch(value)) {
                    return 'Ugyldig bekræftelseskode';
                  }
                  if (value != provider.verificationCode) {
                    return 'Forkert bekræftelseskode';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: kNormalSpacerValue,
              ),
              LoginRegistrationConfirmButton(
                enabled: provider.canContinue,
                onPressed: () {
                  provider.setCanContinue(false);
                  bool? valid = _formKey.currentState?.validate();
                  if (valid == null) {
                    return;
                  }
                  if (valid) {
                    Navigator.of(context)
                        .pushReplacementNamed(CreateAccountScreenThreePassword.id);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
