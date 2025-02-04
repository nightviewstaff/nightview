import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/input_decorations.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/helpers/misc/prelude_helper.dart';
import 'package:nightview/constants/phone_country_code.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/providers/login_registration_provider.dart';
import 'package:nightview/screens/login_registration/creation/create_account_screen_one_personal.dart';
import 'package:nightview/screens/login_registration/utility/custom_text_field.dart';
import 'package:nightview/screens/login_registration/utility/init_state_manager.dart';
import 'package:nightview/screens/login_registration/utility/validation_helper.dart';
import 'package:nightview/widgets/stateless/login_pages_basic.dart';
import 'package:nightview/widgets/stateless/login_registration_confirm_button.dart';
import 'package:nightview/widgets/stateless/phone_country_code_dropdown_button.dart';
import 'package:provider/provider.dart';
import 'package:nightview/screens/login_registration/creation/create_account_screen_three_password.dart';

class CreateAccountScreenTwoContact extends StatefulWidget {
  static const id = 'create_account_screen_two_contact';

  const CreateAccountScreenTwoContact({super.key});

  @override
  State<CreateAccountScreenTwoContact> createState() =>
      _CreateAccountScreenTwoContactState();
}

class _CreateAccountScreenTwoContactState
    extends State<CreateAccountScreenTwoContact> {
  @override
  void initState() {
    super.initState();
    final provider =
        Provider.of<LoginRegistrationProvider>(context, listen: false);

    InitStateManager.initContactInfo(
        context: context,
        formKey: _formKey,
        provider: provider,
        phoneController: phoneInputController,
        emailController: mailInputController,
        inputIsFilled: inputIsFilled);
  }

  final _formKey = GlobalKey<FormState>();

  // final otpHelper = PreludeHelper(); // Not used atm
  final phoneInputController = TextEditingController();
  final mailInputController = TextEditingController();

  List<bool> inputIsFilled = [false, false];

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginRegistrationProvider>(
      builder: (context, provider, child) => SignUpPageBasic(
        onBack: () => Navigator.of(context)
            .pushReplacementNamed(CreateAccountScreenOnePersonal.id),
        currentStep: 2,

        title: Text(
          'Kontaktoplysninger',
          textAlign: TextAlign.center,
          style: kTextStyleH2,
        ),
        formFields: [
          SizedBox(height: kBiggerSpacerValue),
          Form(
            key: _formKey, // Associate the form with the key

            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 128.0,
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          textTheme: TextTheme(
                            titleMedium: TextStyle(color: primaryColor),
                          ),
                        ),
                        child: PhoneCountryCodeDropdownButton(
                          value: provider.countryCode,
                          onChanged: (value) {
                            if (value == null) return;
                            provider.setCountryCode(value);
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: kSmallSpacerValue),
                    Expanded(
                      child: CustomTextField.buildTextField(
                        controller: phoneInputController,
                        hintText: 'Telefonnummer',
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          ValidationHelper.updateValidationStateFormTwo(
                              _formKey, provider, inputIsFilled, 0, value,
                              isPhoneValid: false);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return ''; // This prevents extra space by not showing any error message
                          }
                          return null;
                        }, // Trigger red outline without text TODO
                      ),
                    ),
                  ],
                ),

                SizedBox(height: kNormalSpacerValue),

                CustomTextField.buildTextField(
                  controller: mailInputController,
                  hintText: 'Mail',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    ValidationHelper.updateValidationStateFormTwo(
                        _formKey, provider, inputIsFilled, 1, value,
                        isMailValid: false);
                  },
                  validator: ValidationHelper.validateEmail,
                ),
                // SizedBox(height: kNormalSpacerValue),
              ],
            ),
          ),
        ],
        bottomContent: LoginRegistrationConfirmButton(
          //TODO red if input and not accepted.
          enabled: provider.canContinue,
          onPressed: () async {
            bool? valid = _formKey.currentState?.validate();
            if (valid == null) return;

            if (valid) {
              _formKey.currentState!
                  .save(); // Todo look into saving and restoring instead of init?
              bool mailExistsAlready = Provider.of<GlobalProvider>(
                context,listen: false,
              ).userDataHelper.doesMailExist(mail: mailInputController.text);
              if (mailExistsAlready) {
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      'Ugyldig mail',
                      style: TextStyle(color: redAccent),
                    ),
                    content: SingleChildScrollView(
                      child:
                          Text('Denne mail bliver brugt af en anden bruger.'),
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
              } else {
                String fullPhoneNumber =
                    PhoneCountryCode(provider.countryCode).phoneCode! +
                        phoneInputController.text;
                provider.setPhone(fullPhoneNumber.trim());
                provider.setMail(mailInputController.text.trim());
                Navigator.of(context)
                    .pushReplacementNamed(CreateAccountScreenThreePassword.id);
              }
              provider.setCanContinue(false);
            }
          },
        ),
      ),
    );
  }
}
