import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nightview/app_localization.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/helpers/misc/referral_points_helper.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/providers/login_registration_provider.dart';
import 'package:nightview/screens/location_permission/location_permission_checker_screen.dart';
import 'package:nightview/screens/login_registration/creation/choose_clubbing_location.dart';
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
              AppLocalizations.of(context)!.choosePassword,
              textAlign: TextAlign.center,
              style: kTextStyleH2,
            ),
            SizedBox(height: kNormalSpacerValue), // Adjust spacing as needed
            Text(
              AppLocalizations.of(context)!.passwordRequirements,
              textAlign: TextAlign.center,
              style: kTextStyleP3, // Use a smaller text style
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
                  hintText: AppLocalizations.of(context)!.password,
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
                      return AppLocalizations.of(context)!.passwordEmptyError;
                    }
                    if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])').hasMatch(value)) {
                      return AppLocalizations.of(context)!
                          .passwordUpperLowerError;
                    }
                    if (!RegExp(r'^(?=.*?[0-9])').hasMatch(value)) {
                      return AppLocalizations.of(context)!.passwordDigitError;
                    }
                    if (!RegExp(r'^.{8,}').hasMatch(value)) {
                      return AppLocalizations.of(context)!
                          .passwordMinLengthError;
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: kNormalSpacerValue,
                ),
                CustomTextField.buildTextField(
                  controller: confirmPasswordController,
                  hintText: AppLocalizations.of(context)!.confirmPasswordHint,
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
                      return AppLocalizations.of(context)!
                          .confirmPasswordEmptyError;
                    }
                    if (passwordController.text != value) {
                      return AppLocalizations.of(context)!
                          .passwordMismatchError;
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
                if (provider.password.isNotEmpty) {
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

                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('mail', provider.mail);
                  prefs.setString('password', provider.password);
                  Navigator.of(context).pushReplacementNamed(
                      // ChooseClubbingLocationScreen
                      LocationPermissionCheckerScreen.id);
                }
              } catch (e) {
                String errorMessage =
                    AppLocalizations.of(context)!.somethingWentWrong;

                if (e is FirebaseAuthException) {
                  switch (e.code) {
                    case 'email-already-in-use':
                      errorMessage =
                          AppLocalizations.of(context)!.emailAlreadyInUseError;

                      break;
                    case 'invalid-email':
                      errorMessage =
                          AppLocalizations.of(context)!.invalidEmailError;

                      break;
                    case 'weak-password':
                      errorMessage =
                          AppLocalizations.of(context)!.weakPasswordError;

                      break;
                    case 'network-request-failed':
                      errorMessage =
                          AppLocalizations.of(context)!.noInternetError;

                      break;
                    default:
                      errorMessage =
                          AppLocalizations.of(context)!.genericErrorOccurred;
                  }
                }

                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      AppLocalizations.of(context)!.errorTitle,
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
                          'OK',
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
