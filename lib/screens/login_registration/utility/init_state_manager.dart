import 'package:flutter/material.dart';
import 'package:nightview/providers/login_registration_provider.dart';
import 'package:nightview/screens/login_registration/utility/validation_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitStateManager {
  /// **Initialize Personal Info Screen**
  static void initPersonalInfo({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required LoginRegistrationProvider provider,
    required TextEditingController firstNameController,
    required TextEditingController lastNameController,
    required List<bool> inputIsFilled,
    required void Function(DateTime?) setSelectedDate, // Callback for date
    required void Function(bool) setShowHintDatePicker, // Callback for hint
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      firstNameController.text = provider.firstName;
      lastNameController.text = provider.lastName;

      ValidationHelper.updateValidationStateFormOne(
          formKey, provider, inputIsFilled, 0, provider.firstName);
      ValidationHelper.updateValidationStateFormOne(
          formKey, provider, inputIsFilled, 1, provider.lastName);

      DateTime? selectedDate = provider.birthDate; // TODO legalAge variabl
      final DateTime legalAgeAgo = DateTime(
          DateTime.now().year - 18, DateTime.now().month, DateTime.now().day);

      setSelectedDate(selectedDate);

      if (selectedDate != null && selectedDate.isBefore(legalAgeAgo)) {
        setShowHintDatePicker(false);
        ValidationHelper.updateValidationStateFormOne(
            formKey, provider, inputIsFilled, 2, selectedDate.toString());
      } else {
        ValidationHelper.updateValidationStateFormOne(
            formKey, provider, inputIsFilled, 2, '',
            isDateValid: false);
      }
    });
  }

  // TODO Combine??!
  /// **Initialize Contact Screen**
  static void initContactInfo({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required LoginRegistrationProvider provider,
    required TextEditingController phoneController,
    required TextEditingController emailController,
    required List<bool> inputIsFilled,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String cleanedPhoneNumber =
          ValidationHelper.cleanPhoneNumber(provider.phone);
      phoneController.text = cleanedPhoneNumber;
      emailController.text = provider.mail;

      ValidationHelper.updateValidationStateFormOne(
          formKey, provider, inputIsFilled, 0, cleanedPhoneNumber);
      ValidationHelper.updateValidationStateFormOne(
          formKey, provider, inputIsFilled, 1, provider.mail);
    });
  }

  static Future<void> initPasswordInfo(
      {required BuildContext context,
      required GlobalKey<FormState> formKey,
      required LoginRegistrationProvider provider,
      required TextEditingController passwordController,
      required List<bool> inputIsFilled}) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (prefs.get("password") != null) {
    //   passwordController.text = prefs.get('password');
    // }else{
    passwordController.text = provider.password;
    // }
  }

  static void initPhoneAndBirthday({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required LoginRegistrationProvider provider,
    required TextEditingController phoneController,
    required List<bool> inputIsFilled,
    required void Function(DateTime?) setSelectedDate, // Callback for date
    required void Function(bool) setShowHintDatePicker, // Callback for hint
  }) {
    // ✅ Set phone number if available
    phoneController.text = provider.phone;

    // ✅ Check if birthdate exists & update UI safely
    if (provider.birthDate != null) {
      setSelectedDate(provider.birthDate);
      setShowHintDatePicker(false);
    } else {
      setSelectedDate(null); // Prevents null errors
    }
  }


}
