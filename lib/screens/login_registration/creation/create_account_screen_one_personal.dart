import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nightview/app_localization.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/generated/l10n.dart';
import 'package:nightview/providers/login_registration_provider.dart';
import 'package:nightview/screens/login_registration/choice/login_or_create_account_screen.dart';
import 'package:nightview/screens/login_registration/creation/create_account_screen_two_contact.dart';
import 'package:nightview/screens/login_registration/utility/custom_text_field.dart';
import 'package:nightview/screens/login_registration/utility/init_state_manager.dart';
import 'package:nightview/screens/login_registration/utility/validation_helper.dart';
import 'package:nightview/utilities/messages/custom_modal_message.dart';
import 'package:nightview/widgets/stateless/login_pages_basic.dart';
import 'package:nightview/widgets/stateless/login_registration_confirm_button.dart';
import 'package:provider/provider.dart';

class CreateAccountScreenOnePersonal extends StatefulWidget {
  //TODO Clean(extact to independant methods) in near future
  static const id = 'create_account_screen_one_personal';

  const CreateAccountScreenOnePersonal({super.key});

  @override
  State<CreateAccountScreenOnePersonal> createState() =>
      _CreateAccountScreenOnePersonalState();
}

class _CreateAccountScreenOnePersonalState
    extends State<CreateAccountScreenOnePersonal> {
  @override
  void initState() {
    // TODO Check all good
    super.initState();
    final provider =
        Provider.of<LoginRegistrationProvider>(context, listen: false);

    InitStateManager.initPersonalInfo(
      // remember info
      context: context,
      formKey: _formKey,
      provider: provider,
      firstNameController: firstNameInputController,
      lastNameController: lastNameInputController,
      inputIsFilled: inputIsFilled,
      setSelectedDate: (date) => setState(() => selectedDate = date),
      setShowHintDatePicker: (value) =>
          setState(() => showHintDatePicker = value),
    );
  }

  final _formKey = GlobalKey<FormState>();
  final firstNameInputController = TextEditingController();
  final lastNameInputController = TextEditingController();

  List<bool> inputIsFilled = [false, false, false]; // Tracks filled state

  bool showHintDatePicker = true;
  DateTime? selectedDate;
  DateTime actualBirthDate = DateTime(DateTime.now().year - 18); // init

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginRegistrationProvider>(
      // Maybe provider is being reset resulting in going back?
      builder: (context, provider, child) => SignUpPageBasic(
        onBack: () => Navigator.of(context)
            .pushReplacementNamed(LoginOrCreateAccountScreen.id),
        title: Text(
          S.of(context).personal_information,
          textAlign: TextAlign.center,
          style: kTextStyleH2, // Put default
        ),
        formFields: [
          SizedBox(height: kBiggerSpacerValue),
          Form(
            key: _formKey, // Associate the form with the key

            child: Column(
              children: [
                CustomTextField.buildTextField(
                  controller: firstNameInputController,
                  hintText: S.of(context).first_name,
                  onChanged: (value) {
                    provider.setFirstName(value);
                    ValidationHelper.updateValidationStateFormOne(
                        _formKey, provider, inputIsFilled, 0, value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return ''; // This prevents extra space by not showing any error message
                    }
                    return null;
                  },
                ),
                SizedBox(height: kNormalSpacerValue),
                CustomTextField.buildTextField(
                  controller: lastNameInputController,
                  hintText: S.of(context).last_name,
                  onChanged: (value) {
                    provider.setLastName(value);
                    ValidationHelper.updateValidationStateFormOne(
                        _formKey, provider, inputIsFilled, 1, value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return ''; // This prevents extra space by not showing any error message
                    }
                    return null;
                  },
                ),
                SizedBox(height: kNormalSpacerValue),
                _buildDatePickerBox(),
              ],
            ),
          ),
        ],
        bottomContent: LoginRegistrationConfirmButton(
          enabled: provider.canContinue, // Button still disables visually
          onPressed: () {
            bool isValid = _formKey.currentState?.validate() ?? false;

            if (isValid && provider.canContinue) {
              provider.setFirstName(firstNameInputController.text.trim());
              provider.setLastName(lastNameInputController.text.trim());
              provider.setBirthDate(selectedDate!);
              provider.setCanContinue(false);

              Navigator.of(context)
                  .pushReplacementNamed(CreateAccountScreenTwoContact.id);
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

              if (newDate.isBefore(legalAgeAgo)) {
                provider.setBirthDate(newDate);
                ValidationHelper.updateValidationStateFormOne(
                    _formKey, provider, inputIsFilled, 2, newDate.toString());
              } else {
                ValidationHelper.updateValidationStateFormOne(
                    _formKey, provider, inputIsFilled, 2, '',
                    isDateValid: false);
              }
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
                ? S.of(context).birthdate
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
