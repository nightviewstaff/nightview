import 'package:flutter/material.dart';
import 'package:nightview/constants/input_decorations.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/providers/login_registration_provider.dart';
import 'package:nightview/screens/login_registration/registration_age_screen.dart';
import 'package:nightview/widgets/stateless/login_registration_confirm_button.dart';
import 'package:nightview/widgets/stateless/login_registration_layout.dart';
import 'package:provider/provider.dart';

class RegistrationNameScreen extends StatefulWidget {
  static const id = 'registration_name_screen';

  const RegistrationNameScreen({super.key});

  @override
  State<RegistrationNameScreen> createState() => _RegistrationNameScreenState();
}

class _RegistrationNameScreenState extends State<RegistrationNameScreen> {
  final _formKey = GlobalKey<FormState>();
  final firstNameInputController = TextEditingController();
  final lastNameInputController = TextEditingController();

  List<bool> inputIsFilled = [false, false];


  //TODO Login with AppleID + GoogleAccount

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginRegistrationProvider>(
      builder: (context, provider, child) => LoginRegistrationLayout(
        title: Text(
          'Dine oplysninger',
          textAlign: TextAlign.center,
          style: kTextStyleH2,
        ),
        content: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                controller: firstNameInputController,
                decoration: kMainInputDecoration.copyWith(
                  hintText: 'Fornavn(e)',
                ),
                textCapitalization: TextCapitalization.words,
                onChanged: (value) {
                  inputIsFilled[0] = !(value == null || value.isEmpty);
                  provider.setCanContinue(!inputIsFilled.contains(false));
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Skriv venligst fornavn(e)';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: kNormalSpacerValue,
              ),
              TextFormField(
                controller: lastNameInputController,
                decoration: kMainInputDecoration.copyWith(
                  hintText: 'Efternavn(e)',
                ),
                textCapitalization: TextCapitalization.words,
                onChanged: (value) {
                  inputIsFilled[1] = !(value == null || value.isEmpty);
                  provider.setCanContinue(!inputIsFilled.contains(false));
                  print('on changed $value');
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Skriv venligst efternavn(e)';
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
                    provider.setFirstName(firstNameInputController.text.trim());
                    provider.setLastName(lastNameInputController.text.trim());
                    Navigator.of(context)
                        .pushReplacementNamed(RegistrationAgeScreen.id);
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
