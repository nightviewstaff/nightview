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
import 'package:nightview/screens/login_registration/creation/choose_clubbing_location.dart';
import 'package:nightview/screens/login_registration/creation/create_account_screen_two_contact.dart';
import 'package:nightview/screens/login_registration/utility/custom_text_field.dart';
import 'package:nightview/screens/login_registration/utility/init_state_manager.dart';
import 'package:nightview/screens/login_registration/utility/validation_helper.dart';
import 'package:nightview/widgets/stateless/sign_up_page_basic.dart';
import 'package:nightview/widgets/stateless/login_registration_confirm_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateAccountScreenThreePassword extends StatefulWidget {
  static const id = 'create_account_screen_three_password';

  const CreateAccountScreenThreePassword({super.key});

  @override
  State<CreateAccountScreenThreePassword> createState() =>
      _CreateAccountScreenThreePasswordState();
}

class _CreateAccountScreenThreePasswordState
    extends State<CreateAccountScreenThreePassword> {
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  List<bool> inputIsFilled = [false, false];

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

  Future<void> registerUser(BuildContext context) async {
    try {
      final provider =
          Provider.of<LoginRegistrationProvider>(context, listen: false);
      final globalProvider =
          Provider.of<GlobalProvider>(context, listen: false);

      // Create the user with email and password directly using FirebaseAuth
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: provider.mail,
        password: provider.password,
      );

      // Get the authenticated user
      User? user = userCredential.user;

      if (user != null) {
        print('Current User ID: ${user.uid}'); // Debugging log

        // Upload user data to Firestore
        bool uploadSuccess = await globalProvider.userDataHelper.uploadUserData(
          firstName: provider.firstName,
          lastName: provider.lastName,
          mail: provider.mail,
          phone: provider.phone,
          birthdateDay: provider.birthDate.day,
          birthdateMonth: provider.birthDate.month,
          birthdateYear: provider.birthDate.year,
        );

        if (uploadSuccess) {
          print('User data uploaded successfully');

          // Increment referral points
          ReferralPointsHelper.incrementReferralPoints(1);

          // Save credentials to SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('mail', provider.mail);
          await prefs.setString('password', provider.password);
          print('Credentials saved - Mail: ${provider.mail}');
          provider.setCanContinue(false);

          // Navigate to the next screen
          Navigator.of(context)
              .pushReplacementNamed(ChooseClubbingLocationScreen.id);
        } else {
          print('User data upload failed');
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text(S.of(context).user_data_upload_failed)),
          // );
        }
      } else {
        print('User is null after creation');
        // ScaffoldMessenger.of(context).showSnackBar(
        //   // SnackBar(content: Text(S.of(context).authentication_failed)),
        // );
      }
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
            errorMessage = '${S.of(context).error_occurred}: ${e.message}';
        }
      }

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(S.of(context).error, style: TextStyle(color: redAccent)),
          content: SingleChildScrollView(child: Text(errorMessage)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(S.of(context).ok, style: TextStyle(color: redAccent)),
            ),
          ],
        ),
      );
    }
  }

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
                SizedBox(height: kNormalSpacerValue),
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
            bool? valid = _formKey.currentState?.validate();
            if (valid == null || !valid) {
              return;
            }
            provider.setPassword(passwordController.text);
            await registerUser(context);
          },
        ),
      ),
    );
  }
}
