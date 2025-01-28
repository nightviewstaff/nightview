import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/input_decorations.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/helpers/misc/prelude_helper.dart';
import 'package:nightview/constants/phone_country_code.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/providers/login_registration_provider.dart';
import 'package:nightview/widgets/stateless/login_registration_confirm_button.dart';
import 'package:nightview/widgets/stateless/login_registration_layout.dart';
import 'package:nightview/widgets/stateless/phone_country_code_dropdown_button.dart';
import 'package:provider/provider.dart';
import 'package:nightview/screens/login_registration/registration_password_screen.dart';


class RegistrationAuthenticationScreen extends StatefulWidget {
  static const id = 'registration_authentication_screen';

  const RegistrationAuthenticationScreen({super.key});

  @override
  State<RegistrationAuthenticationScreen> createState() => _RegistrationAuthenticationScreenState();
}

class _RegistrationAuthenticationScreenState extends State<RegistrationAuthenticationScreen> {
  final _formKey = GlobalKey<FormState>();
  final otpHelper = PreludeHelper();
  final phoneInputController = TextEditingController();
  final mailInputController = TextEditingController();

  List<bool> inputIsFilled = [false, false];

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginRegistrationProvider>(
      builder: (context, provider, child) => Form(
        key: _formKey,
        child: LoginRegistrationLayout(
          title: Text(
            'Opret profil med telefon og mail',
            textAlign: TextAlign.center,
            style: kTextStyleH1,
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 128.0,
                    child: PhoneCountryCodeDropdownButton(
                      value: provider.countryCode,
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        provider.setCountryCode(value);
                      },
                    ),
                  ),
                  SizedBox(
                    width: kSmallSpacerValue,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: phoneInputController,
                      decoration: kMainInputDecoration.copyWith(
                        hintText: 'Telefon',
                      ),
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        inputIsFilled[0] = !(value.isEmpty);
                        provider.setCanContinue(!inputIsFilled.contains(false));
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Skriv venligst dit telefonnummer';
                        }

                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'Ugyldigt tlf-nummer';
                        }

                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: kNormalSpacerValue,
              ),
              TextFormField(
                controller: mailInputController,
                decoration: kMainInputDecoration.copyWith(
                  hintText: 'Mail',
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  inputIsFilled[1] = !(value.isEmpty);
                  provider.setCanContinue(!inputIsFilled.contains(false));
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Skriv venligst din mail';
                  }

                  if (!RegExp(
                    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
                  ).hasMatch(value)) {
                    return 'Ugyldig mail';
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
                    bool mailExistsAlready =
                        Provider.of<GlobalProvider>(context, listen: false).userDataHelper.doesMailExist(mail: mailInputController.text);
                    if (mailExistsAlready) {
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Ugyldig mail'),
                          content: SingleChildScrollView(
                            child: Text('Denne mail bliver brugt af en anden bruger.'),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'OK',
                                style: TextStyle(color: primaryColor),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      String fullPhoneNumber = PhoneCountryCode(provider.countryCode).phoneCode! + phoneInputController.text;
                      provider.setPhone(fullPhoneNumber.trim());
                      provider.setMail(mailInputController.text.trim());
                      // provider.generateRandomVerificationCode();
                      // otpHelper.sendOTP(verificationCode: provider.verificationCode, userMail: mailInputController.text.trim(), userPhoneNumber: fullPhoneNumber);
                      Navigator.of(context).pushReplacementNamed(RegistrationPasswordScreen.id);
                    }
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
