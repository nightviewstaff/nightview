import 'package:flutter/material.dart';
import 'package:nightview/constants/input_decorations.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/helpers/misc/referral_points_helper.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/providers/login_registration_provider.dart';
import 'package:nightview/screens/login_registration/registration_welcome_screen.dart';
import 'package:nightview/widgets/stateless/login_registration_confirm_button.dart';
import 'package:nightview/widgets/stateless/login_registration_layout.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationPasswordScreen extends StatefulWidget { //TODO FIX
  static const id = 'registration_password_screen';

  const RegistrationPasswordScreen({super.key});

  @override
  State<RegistrationPasswordScreen> createState() =>
      _RegistrationPasswordScreenState();
}

class _RegistrationPasswordScreenState
    extends State<RegistrationPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();

  List<bool> inputIsFilled = [false, false];

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginRegistrationProvider>(
      builder: (context, provider, child) => Form(
        key: _formKey,
        child: LoginRegistrationLayout(
          title: Text(
            'Vælg et kodeord',
            textAlign: TextAlign.center,
            style: kTextStyleH1,
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                controller: passwordController,
                decoration: kMainInputDecoration.copyWith(hintText: 'Kodeord'),
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                onChanged: (value) {
                  inputIsFilled[0] = !(value.isEmpty);
                  provider.setCanContinue(!inputIsFilled.contains(false));
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Skriv venligst et kodeord';
                  }
                  if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])').hasMatch(value)) {
                    return 'Skal indeholde store og små bogstaver';
                  }
                  if (!RegExp(r'^(?=.*?[0-9])').hasMatch(value)) {
                    return 'Skal indeholde tal';
                  }
                  if (!RegExp(r'^.{8,}').hasMatch(value)) {
                    return 'Skal være mindst 8 cifre';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: kNormalSpacerValue,
              ),
              TextFormField(
                decoration:
                    kMainInputDecoration.copyWith(hintText: 'Bekræft kodeord'),
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                onChanged: (value) {
                  inputIsFilled[1] = !(value.isEmpty);
                  provider.setCanContinue(!inputIsFilled.contains(false));
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Skriv venligst et kodeord';
                  }
                  if (!(passwordController.text == value)) {
                    return 'Kodeord stemmer ikke overens';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: kNormalSpacerValue,
              ),
              LoginRegistrationConfirmButton(
                enabled: provider.canContinue,
                onPressed: () async {
                  provider.setCanContinue(false);
                  bool? valid = _formKey.currentState?.validate();
                  if (valid == null) {
                    return;
                  }
                  if (valid) {
                    provider.setPassword(passwordController.text);
                    await Provider.of<GlobalProvider>(context, listen: false)
                        .userDataHelper
                        .createUserWithEmail(
                          email: provider.mail,
                          password: provider.password,
                        );
                    await Provider.of<GlobalProvider>(context, listen: false)
                        .userDataHelper
                        .uploadUserData(
                          firstName: provider.firstName,
                          lastName: provider.lastName,
                          mail: provider.mail,
                          phone: provider.phone,
                          birthdateDay: provider.birthDate.day,
                          birthdateMonth: provider.birthDate.month,
                          birthdateYear: provider.birthDate.year,
                        );
                    ReferralPointsHelper.incrementReferralPoints(1);
                    Navigator.of(context)
                        .pushReplacementNamed(RegistrationWelcomeScreen.id);
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString('mail', provider.mail);
                    prefs.setString('password', provider.password);
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
