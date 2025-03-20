import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/generated/l10n.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/providers/login_registration_provider.dart';
import 'package:nightview/screens/location_permission/location_permission_checker_screen.dart';
import 'package:nightview/screens/login_registration/choice/login_or_create_account_screen.dart';
import 'package:nightview/screens/login_registration/utility/custom_text_field.dart';
import 'package:nightview/widgets/stateless/big_checkbox.dart';
import 'package:nightview/widgets/stateless/login_pages_basic.dart';
import 'package:nightview/widgets/stateless/login_registration_confirm_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final mailPhoneInputController = TextEditingController();
  final passwordInputController = TextEditingController();

  List<bool> inputIsFilled = [false, false]; //TODO

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginRegistrationProvider>(
      builder: (context, provider, child) => SignUpPageBasic(
        onBack: () => Navigator.of(context)
            .pushReplacementNamed(LoginOrCreateAccountScreen.id),
        showProgressBar: false,
        title: Text(
          S.of(context).login,
          style: kTextStyleH2,
        ),
        formFields: [
          SizedBox(height: kBiggerSpacerValue),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField.buildTextField(
                  controller: mailPhoneInputController,
                  keyboardType: TextInputType.emailAddress,
                  hintText: S.of(context).email,
                  onChanged: (value) {
                    inputIsFilled[0] = !(value.isEmpty);
                    provider.setCanContinue(!inputIsFilled.contains(false));
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return ''; // This prevents extra space by not showing any error message
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: kNormalSpacerValue,
                ),
                CustomTextField.buildTextField(
                  // TODO remember password/mail?
                  controller: passwordInputController,
                  isObscure: true,
                  hintText: S.of(context).password,
                  keyboardType: TextInputType.visiblePassword,
                  onChanged: (value) {
                    inputIsFilled[1] = !(value.isEmpty);
                    provider.setCanContinue(!inputIsFilled.contains(false));
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return ''; // This prevents extra space by not showing any error message
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: kNormalSpacerValue,
                ),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    // Ensures the row takes only the needed width
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      BigCheckbox(
                        value: provider.stayLoggedIn,
                        onChanged: (value) {
                          provider.toggleStayLogin();
                        },
                      ),
                      SizedBox(width: kNormalSpacerValue),
                      GestureDetector(
                        onTap: () {
                          provider.toggleStayLogin();
                        },
                        child: Text(
                          S.of(context).stay_logged_in,
                          style: kTextStyleH3,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: kNormalSpacerValue,
                ),
                LoginRegistrationConfirmButton(
                  enabled: provider.canContinue,
                  onPressed: () async {
                    provider.setCanContinue(false);

                    if (await Provider.of<GlobalProvider>(context,
                        listen: false)
                        .userDataHelper
                        .loginUser(
                        mail: mailPhoneInputController.text,
                        password: passwordInputController.text)) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        LocationPermissionCheckerScreen.id,
                            (route) => false,
                      );

                      SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                      if (provider.stayLoggedIn) {
                        prefs.setString('mail', mailPhoneInputController.text);
                        prefs.setString(
                            'password', passwordInputController.text);
                      }
                      // else {
                      //   prefs.remove('mail');
                      //   prefs.remove('password');
                      // }
                    } else {
                      await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => AlertDialog(
                          title: Text(S.of(context).invalid_login),
                          content: SingleChildScrollView(
                            child: Text(S.of(context).incorrect_information),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                S.of(context).okay,
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
        ],
      ),
    );
  }
}
