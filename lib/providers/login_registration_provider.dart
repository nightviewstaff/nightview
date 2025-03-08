import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nightview/constants/enums.dart';

class LoginRegistrationProvider extends ChangeNotifier {
  bool _stayLoggedIn = true;
  CountryCode _countryCode = CountryCode.dk;
  bool _canContinue = false;
  String _verificationCode = '0000';

  String? _firstName;
  String? _lastName;
  DateTime _birthDate = DateTime(2000);
  String? _mail;
  String? _phone;
  String? _password;

  bool get stayLoggedIn => _stayLoggedIn;

  CountryCode get countryCode => _countryCode;

  bool get canContinue => _canContinue;

  String get verificationCode => _verificationCode;

  String get firstName => _firstName!;

  String get lastName => _lastName!;

  DateTime get birthDate => _birthDate;

  String get mail => _mail!;

  String get phone => _phone!;

  String get password => _password!;

  void toggleStayLogin() {
    _stayLoggedIn = !_stayLoggedIn;
    notifyListeners();
  }

  void setCountryCode(CountryCode newValue) {
    _countryCode = newValue;
    notifyListeners();
  }

  void setCanContinue(bool newValue) {
    _canContinue = newValue;
    notifyListeners();
  }

  void generateRandomVerificationCode() {
    _verificationCode = Random().nextInt(10000).toString().padLeft(4, '0');
    print('CODE : $_verificationCode'); // TEST
    notifyListeners();
  }

  void setFirstName(String newValue) {
    _firstName = newValue;
    notifyListeners();
  }

  void setLastName(String newValue) {
    _lastName = newValue;
    notifyListeners();
  }

  void setBirthDate(DateTime newDate) {
    _birthDate = newDate;
    notifyListeners();
  }

  void setMail(String newValue) {
    _mail = newValue;
    notifyListeners();
  }

  void setPhone(String newValue) {
    _phone = newValue;
    notifyListeners();
  }

  void setPassword(String newValue) {
    _password = newValue;
    notifyListeners();
  }
}
