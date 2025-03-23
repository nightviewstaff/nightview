import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/generated/l10n.dart';
import 'package:nightview/providers/login_registration_provider.dart';
import 'package:nightview/screens/login_registration/choice/login_or_create_account_screen.dart';
import 'package:nightview/screens/login_registration/creation/create_account_screen_three_password.dart';
import 'package:nightview/screens/login_registration/utility/custom_text_field.dart';
import 'package:nightview/screens/login_registration/utility/validation_helper.dart';
import 'package:nightview/utilities/messages/custom_modal_message.dart';
import 'package:nightview/widgets/stateless/sign_up_page_basic.dart';
import 'package:nightview/widgets/stateless/login_registration_confirm_button.dart';
import 'package:nightview/widgets/stateless/phone_country_code_dropdown_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginGoogleScreen extends StatefulWidget {
  static const id = "login_google_screen";

  const LoginGoogleScreen({super.key});

  @override
  _LoginGoogleScreenState createState() => _LoginGoogleScreenState();
}

class _LoginGoogleScreenState extends State<LoginGoogleScreen> {
  //TODO Not remembering previous entered information
  //TODO SOMETIMES IT GOES BACK TO LOGIN/CREATE?!?! THINK IT IS IN DATEPICKER?!
  // @override
  // void initState() {
  //   super.initState();
  //   final provider =
  //       Provider.of<LoginRegistrationProvider>(context, listen: false);
  //
  //   InitStateManager.initPhoneAndBirthday(
  //     context: context,
  //     formKey: _formKey,
  //     provider: provider,
  //     phoneController: phoneInputController,
  //     inputIsFilled: inputIsFilled,
  //     setSelectedDate: (date) => setState(() => selectedDate = date),
  //     setShowHintDatePicker: (value) =>
  //         setState(() => showHintDatePicker = value),
  //   );
  // }

  final _formKey = GlobalKey<FormState>();
  final phoneInputController = TextEditingController();
  final firstNameInputController = TextEditingController();
  final lastNameInputController = TextEditingController();

  DateTime? selectedDate;
  DateTime actualBirthDate = DateTime(DateTime.now().year - 18); // init

  List<bool> inputIsFilled = [
    false,
    false,
  ];
  bool showHintDatePicker = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginRegistrationProvider>(
      builder: (context, provider, child) => SignUpPageBasic(
        onBack: () => Navigator.of(context)
            .pushReplacementNamed(LoginOrCreateAccountScreen.id),
        currentStep: 2,
        title: Text(
          S.of(context).remaining_information,
          textAlign: TextAlign.center,
          style: kTextStyleH2,
        ),
        formFields: [
          SizedBox(height: kBiggerSpacerValue),
          Form(
            key: _formKey,
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
                        hintText: S.of(context).phone_number,
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          provider.setPhone(value);

                          bool phoneIsValid = value.isNotEmpty;
                          if (phoneIsValid) {
                            inputIsFilled[0] = true;
                          } else {
                            inputIsFilled[0] = false;
                          }
                          ValidationHelper.checkAllFieldsValid(
                              provider, inputIsFilled);
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
              ],
            ),
          ),
          SizedBox(height: kNormalSpacerValue),
          _buildDatePickerBox(),
        ],
        bottomContent: LoginRegistrationConfirmButton(
          enabled: provider.canContinue,
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            if (_formKey.currentState?.validate() ?? false) {
              // Store additional info
              provider.setPhone(phoneInputController.text.trim());
              provider.setBirthDate(selectedDate!);
              provider.setMail(prefs.getString('email') ?? '');

              String fullName = prefs.getString('fullName') ?? '';
              List<String> nameParts =
                  fullName.split(' '); // Split full name into words
              String firstName = nameParts.isNotEmpty ? nameParts.first : '';
              String lastName =
                  nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

              provider.setFirstName(firstName);
              provider.setLastName(lastName);

              provider.setCanContinue(false);
              Navigator.of(context)
                  .pushReplacementNamed(CreateAccountScreenThreePassword.id);
            }
          },
        ),
      ),
    );
  }

  void _openDatePicker(BuildContext context) {
    //TODO extract
    // Extract
    final provider =
        Provider.of<LoginRegistrationProvider>(context, listen: false);
    final int legalAge = 18;
    final int minimumLegalAge = 15;
    int fourteenYearsAgo =
        DateTime.now().year - 14; // Must be older than 15 y/o
    final DateTime today = DateTime.now();
    final DateTime legalAgeAgo =
        DateTime(today.year - legalAge, today.month, today.day);
    // int nowMinusMaxYearMinusOne =

    showModalBottomSheet(
      context: context,
      backgroundColor: lighterBlack,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 55),
        child: SizedBox(
          height: 370.0,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            dateOrder: DatePickerDateOrder.dmy,
            // Proper display
            initialDateTime: DateTime(fourteenYearsAgo, 1, 1),
            minimumYear: fourteenYearsAgo - 100,
            // minus another 100 yrs
            maximumYear: fourteenYearsAgo,
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                selectedDate = newDate;
                showHintDatePicker = false;
              });
              provider.setBirthDate(newDate);
              if (newDate.isBefore(legalAgeAgo)) {
                inputIsFilled[1] = true;
                // ValidationHelper.updateValidationStateFormOneAndTwo(
                //     _formKey, provider, inputIsFilled, 1, newDate.toString());
                // } else {
                //   ValidationHelper.updateValidationStateFormOneAndTwo(
                //       _formKey, provider, inputIsFilled, 1, '',
                //       isDateValid: false);
              } else {
                inputIsFilled[1] = false;
              }
              ValidationHelper.checkAllFieldsValid(provider, inputIsFilled);
            },

            itemExtent: 40,
            // Increase height of each item for better visibility
            selectionOverlayBuilder: (context,
                {selectedIndex = 0, columnCount = 1}) {
              return CupertinoPickerDefaultSelectionOverlay(
                capStartEdge: selectedIndex == 0, // Only left cap for day
                capEndEdge:
                    selectedIndex == columnCount - 1, // Only right cap for year
              );
            },
          ),
        ),
      ),
    ).whenComplete(() async {
      if (selectedDate != null && selectedDate!.isAfter(legalAgeAgo)) {
        CustomModalMessage.showCustomBottomSheetOneSecond(
          context: context,
          message: S.of(context).age_restriction,
          textStyle: kTextStyleP3ErrorText,
          autoDismissDurationSeconds: 3,
        );
      }
    });
  }

  Widget _buildDatePickerBox() {
    final int legalAge = 18;
    final DateTime today = DateTime.now();
    final DateTime legalAgeAgo =
        DateTime(today.year - legalAge, today.month, today.day);

    bool isTooYoung =
        selectedDate != null && selectedDate!.isAfter(legalAgeAgo);

    return GestureDetector(
      onTap: () => _openDatePicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15.0),
        decoration: BoxDecoration(
          color: black,
          border: Border.all(color: Colors.white, width: 3), // White outline
          borderRadius: BorderRadius.circular(22), // Optional rounded corners
        ),
        child: Center(
          child: Text(
            showHintDatePicker
                ? S.of(context).birthdate // Show hint
                : '${selectedDate!.day} / ${selectedDate!.month} / ${selectedDate!.year}', // Show selected date
            style: TextStyle(
                color: showHintDatePicker
                    ? grey
                    : isTooYoung
                        ? redAccent
                        : primaryColor,
                fontSize: defaultFontSize,
                fontWeight: FontWeight
                    .w600 // Make sure that this always is the same box as the others.
                ),
          ),
        ),
      ),
    );
  }
}
