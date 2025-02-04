import 'package:flutter/material.dart';
import 'package:nightview/helpers/users/misc/user_data_helper.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/providers/login_registration_provider.dart';
import 'package:provider/provider.dart';

class ValidationHelper {
  static void updateValidationStateFormOne(
    // TODO Check for errors. Rework so each validation is independant. Really dumb way so far.
    GlobalKey<FormState> formKey,
    LoginRegistrationProvider provider,
    List<bool> inputIsFilled,
    int index,
    String value, {
    bool isDateValid = true,
  }) {
    inputIsFilled[index] = value.isNotEmpty && isDateValid;

    // Check if all fields are valid and filled
    bool allFieldsValid = inputIsFilled.every((filled) => filled);

    provider.setCanContinue(allFieldsValid);

    // Validate the form only if all fields are filled
    if (allFieldsValid) {
      formKey.currentState?.validate();
    }
  }

  static void checkAllFieldsValid(
      LoginRegistrationProvider provider,
      List<bool> inputIsFilled,
      ){
    bool allFieldsValid = inputIsFilled.every((filled) => filled);
    provider.setCanContinue(allFieldsValid);

  }

  static Future<void> updateValidationStateFormTwo(
    GlobalKey<FormState> formKey,
    LoginRegistrationProvider provider,
    List<bool> inputIsFilled,
    int index,
    String value, {
    bool isPhoneValid = true,
    bool isMailValid = true,
  }) async {
    if (!isPhoneValid) {
      isPhoneValid = validatePhone(value);
      value = cleanPhoneNumber(value);
    }
    if (!isMailValid) {
      isMailValid = checkEmail(value);
    }

    // if (index == 1) {
    //   bool mailExistsAlready = Provider.of<GlobalProvider>(
    //   context,listen: false,
    // ).userDataHelper.doesMailExist(mail: value);
    // }

    inputIsFilled[index] = value.isNotEmpty && isPhoneValid && isMailValid;
    bool allFieldsValid = inputIsFilled.every((filled) => filled);
    provider.setCanContinue(allFieldsValid);
    if (allFieldsValid) {
      formKey.currentState?.validate();
    }
  }

  static void updateValidationStateFormThree(
      GlobalKey<FormState> formKey,
      LoginRegistrationProvider provider,
      List<bool> inputIsFilled,
      int index,
      String value,
      TextEditingController passwordController,
      TextEditingController confirmPasswordController,
      {bool isPassValid = true}) {

    provider.setPassword(passwordController.text);

    // Check if the password meets all validation requirements
    bool isPasswordValid = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*?[0-9]).{8,}$').hasMatch(passwordController.text);

    // Ensure passwords match
    bool passwordsMatch = passwordController.text == confirmPasswordController.text;

    // Only update validation state if the password is valid
    inputIsFilled[index] = value.isNotEmpty && isPassValid && isPasswordValid;

    // canContinue should only be true if all validation conditions are met
    bool allFieldsValid = inputIsFilled.every((filled) => filled) && passwordsMatch && isPasswordValid;
    provider.setCanContinue(allFieldsValid);

    if (allFieldsValid) {
      formKey.currentState?.validate();
    }
  }

  static void updateValidationStateFormFour(
      GlobalKey<FormState> formKey,
      LoginRegistrationProvider provider,
      List<bool> inputIsFilled,
      int index,
      String value,
      TextEditingController passwordController,
      TextEditingController confirmPasswordController,
      {bool isPassValid = true,
        bool isPhoneValid = true,
        bool isMailValid = true}) {

    // Store password in provider
    provider.setPassword(passwordController.text);

    // ✅ Validate Password
    bool isPasswordValid = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*?[0-9]).{8,}$')
        .hasMatch(passwordController.text);

    // ✅ Ensure Passwords Match
    bool passwordsMatch = passwordController.text == confirmPasswordController.text;

    // ✅ Validate Phone Number (if required)
    bool phoneValid = isPhoneValid;

    // ✅ Validate Email (if required)
    bool emailValid = isMailValid;

    // ✅ Update validation state for the given field index
    inputIsFilled[index] = value.isNotEmpty && isPassValid;

    // ✅ Check if all fields are valid and filled
    bool allFieldsValid = inputIsFilled.every((filled) => filled) &&
        passwordsMatch &&
        isPasswordValid &&
        phoneValid &&
        emailValid;

    // ✅ Update Provider's canContinue State
    provider.setCanContinue(allFieldsValid);

    // ✅ Validate the entire form if all fields are valid
    if (allFieldsValid) {
      formKey.currentState?.validate();
    }
  }



  static bool checkEmail(String? value) {
    if (value == null || value.isEmpty) return false;
    if (!RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
    ).hasMatch(value)) return false;
    return true;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return '';
    if (!RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
    ).hasMatch(value)) return 'Ugyldig mail';
    return null;
  }

  static bool validatePhone(String? value) {
    if (value == null || value.isEmpty)
      return false; // todo Keep red outline without message
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) return false;
    //     if(value > provider.CountryCodeMinimumLength) TODO
    return true;
  }

  /// **Remove Country Code from Phone Number**
  static String cleanPhoneNumber(String phoneNumber) {
    return phoneNumber.replaceFirst(RegExp(r'^\+\d{1,3}'), '').trim();
  }

  static Future<DateTime?> selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(Duration(days: 18 * 365)), // Default: 18 years old
      firstDate: DateTime(DateTime.now().year - 100), // Oldest selectable date
      lastDate: DateTime(DateTime.now().year - 18), // Must be at least 18
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark(), // Adjust UI style
          child: child!,
        );
      },
    );

    return selectedDate;
  }




}
