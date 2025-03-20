import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/generated/l10n.dart';
import 'package:nightview/helpers/misc/referral_points_helper.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/providers/login_registration_provider.dart';
import 'package:nightview/screens/location_permission/location_permission_checker_screen.dart';
import 'package:nightview/screens/login_registration/creation/create_account_screen_two_contact.dart';
import 'package:nightview/screens/login_registration/utility/custom_text_field.dart';
import 'package:nightview/screens/login_registration/utility/init_state_manager.dart';
import 'package:nightview/screens/login_registration/utility/validation_helper.dart';
import 'package:nightview/widgets/stateless/login_pages_basic.dart';
import 'package:nightview/widgets/stateless/login_registration_confirm_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateAccountScreenThreePassword extends StatefulWidget {
  //TODO FIX
  static const id = 'create_account_screen_three_password';

  const CreateAccountScreenThreePassword({super.key});

  @override
  State<CreateAccountScreenThreePassword> createState() =>
      _CreateAccountScreenThreePasswordState();
}

class _CreateAccountScreenThreePasswordState
    extends State<CreateAccountScreenThreePassword> {
  @override
  void initState() {
    super.initState();
    final provider =
        Provider.of<LoginRegistrationProvider>(context, listen: false);

    InitStateManager.initPasswordInfo(
        context: context,
        formKey: _formKey,
        provider: provider,
        passwordController: passwordController,
        inputIsFilled: inputIsFilled);
  }

  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  List<bool> inputIsFilled = [false, false];

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginRegistrationProvider>(
      builder: (context, provider, child) => SignUpPageBasic(
        onBack: () => Navigator.of(context)
            .pushReplacementNamed(CreateAccountScreenTwoContact.id),
        currentStep: 3,
        title: Column(
          children: [
            Text(
              S.of(context).choose_password,
              textAlign: TextAlign.center,
              style: kTextStyleH1,
            ),
            SizedBox(height: kNormalSpacerValue),
            Text(
              S.of(context).password_requirements,
              textAlign: TextAlign.center,
              style: kTextStyleP3,
            ),
          ],
        ),
        formFields: [
          SizedBox(height: kBigSpacerValue),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomTextField.buildTextField(
                  controller: passwordController,
                  hintText: S.of(context).password,
                  keyboardType: TextInputType.visiblePassword,
                  onChanged: (value) {
                    ValidationHelper.updateValidationStateFormThree(
                        _formKey,
                        provider,
                        inputIsFilled,
                        0,
                        value,
                        passwordController,
                        confirmPasswordController);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context).password_empty;
                    }
                    if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])').hasMatch(value)) {
                      return S.of(context).require_uppercase_lowercase;
                    }
                    if (!RegExp(r'^(?=.*?[0-9])').hasMatch(value)) {
                      return S.of(context).require_number;
                    }
                    if (!RegExp(r'^.{8,}').hasMatch(value)) {
                      return S.of(context).minimum_length;
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: kNormalSpacerValue,
                ),
                CustomTextField.buildTextField(
                  controller: confirmPasswordController,
                  hintText: S.of(context).confirm_password,
                  isObscure: true,
                  keyboardType: TextInputType.visiblePassword,
                  onChanged: (value) {
                    ValidationHelper.updateValidationStateFormThree(
                        _formKey,
                        provider,
                        inputIsFilled,
                        1,
                        value,
                        passwordController,
                        confirmPasswordController);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context).enter_password;
                    }
                    if (passwordController.text != value) {
                      return S.of(context).password_mismatch;
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ],
        bottomContent: LoginRegistrationConfirmButton(
          enabled: provider.canContinue,
          onPressed: () async {
            provider.setCanContinue(false);
            bool? valid = _formKey.currentState?.validate();
            if (valid == null) {
              return;
            }
            if (valid) {
              provider.setPassword(passwordController.text);
              try {
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
                    .pushReplacementNamed(LocationPermissionCheckerScreen.id);

                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('mail', provider.mail);
                prefs.setString('password', provider.password);
              } catch (e) {
                String errorMessage = S.of(context).generic_error;

                if (e is FirebaseAuthException) {
                  switch (e.code) {
                    case 'email-already-in-use':
                      errorMessage = S.of(context).email_already_registered;
                      break;
                    case 'invalid-email':
                      errorMessage = S.of(context).invalid_email;
                      break;
                    case 'weak-password':
                      errorMessage = S.of(context).weak_password;
                      break;
                    case 'network-request-failed':
                      errorMessage = S.of(context).no_internet;
                      break;
                    default:
                      errorMessage =
                          '${S.of(context).error_occurred}: ${e.message}';
                  }
                }

                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      S.of(context).error,
                      style: TextStyle(color: redAccent),
                    ),
                    content: SingleChildScrollView(
                      child: Text(errorMessage),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          S.of(context).ok,
                          style: TextStyle(color: redAccent),
                        ),
                      ),
                    ],
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
