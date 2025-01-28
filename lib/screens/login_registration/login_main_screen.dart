import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/input_decorations.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/providers/login_registration_provider.dart';
import 'package:nightview/screens/location_permission/location_permission_checker_screen.dart';
import 'package:nightview/widgets/stateless/big_checkbox.dart';
import 'package:nightview/widgets/stateless/login_registration_confirm_button.dart';
import 'package:nightview/widgets/stateless/login_registration_layout.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginMainScreen extends StatefulWidget {
  static const id = 'login_main_screen';

  const LoginMainScreen({super.key});

  @override
  State<LoginMainScreen> createState() => _LoginMainScreenState();
}

class _LoginMainScreenState extends State<LoginMainScreen> {
  final _formKey = GlobalKey<FormState>();
  final mailPhoneInputController = TextEditingController();
  final passwordInputController = TextEditingController();

  List<bool> inputIsFilled = [false, false];

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginRegistrationProvider>(
      builder: (context, provider, child) => Form(
        key: _formKey,
        child: LoginRegistrationLayout(
          title: Text(
            'Log ind',
            style: kTextStyleH1,
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                controller: mailPhoneInputController,
                decoration: kMainInputDecoration.copyWith(
                  hintText: 'Mail',
                ),
                onChanged: (value) {
                  inputIsFilled[0] = !(value.isEmpty);
                  provider.setCanContinue(!inputIsFilled.contains(false));
                },
              ),
              SizedBox(
                height: kNormalSpacerValue,
              ),
              TextFormField(
                controller: passwordInputController,
                decoration: kMainInputDecoration.copyWith(
                  hintText: 'Kodeord',
                ),
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                onChanged: (value) {
                  inputIsFilled[1] = !(value.isEmpty);
                  provider.setCanContinue(!inputIsFilled.contains(false));
                },
              ),
              SizedBox(
                height: kNormalSpacerValue,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BigCheckbox(
                    value: provider.stayLoggedIn,
                    onChanged: (value) {
                      provider.toggleStayLogin();
                    },
                  ),
                  SizedBox(
                    width: kNormalSpacerValue,
                  ),
                  GestureDetector(
                    onTap: () {
                      provider.toggleStayLogin();
                    },
                    child: Text(
                      'Forbliv logget ind',
                      style: kTextStyleH3,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: kNormalSpacerValue,
              ),
              LoginRegistrationConfirmButton(
                enabled: provider.canContinue,
                onPressed: () async {
                  provider.setCanContinue(false);

                  if (await Provider.of<GlobalProvider>(context, listen: false).userDataHelper.loginUser(
                      mail: mailPhoneInputController.text,
                      password: passwordInputController.text)) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      LocationPermissionCheckerScreen.id,
                      (route) => false,
                    );

                    SharedPreferences prefs = await SharedPreferences.getInstance();

                    if (provider.stayLoggedIn) {
                      prefs.setString('mail', mailPhoneInputController.text);
                      prefs.setString('password', passwordInputController.text);
                    } else {
                      prefs.remove('mail');
                      prefs.remove('password');
                    }

                  } else {
                    await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => AlertDialog(
                        title: Text('Ugyldigt login'),
                        content: SingleChildScrollView(
                          child:
                              Text('Mail/telefon eller kodeord er ikke indtastet korrekt. Prøv igen.'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Okay',
                              style: TextStyle(
                                color: primaryColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
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
