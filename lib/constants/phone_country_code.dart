import 'package:flutter/material.dart';
import 'package:nightview/constants/enums.dart';

class PhoneCountryCode {
  String? phoneCode;
  int? minimumPhoneNumberLength;
  Image? flagImage;
  CountryCode? countryCode;

  final _phoneCodes = {
    CountryCode.dk: '+45',
    CountryCode.se: '+46',
    CountryCode.no: '+47',
  };

  final _minimumPhoneNumberLength = {
    CountryCode.dk: 8,
    CountryCode.se: 7,
    CountryCode.no: 5,
  };

  final _flagImages = {
    CountryCode.dk: Image.asset('images/flags/dk.png'),
    CountryCode.se: Image.asset('images/flags/se.png'),
    CountryCode.no: Image.asset('images/flags/no.png'),
  };

  PhoneCountryCode(this.countryCode) {
    phoneCode = _phoneCodes[countryCode];
    flagImage = _flagImages[countryCode];
    minimumPhoneNumberLength = _minimumPhoneNumberLength[countryCode];
  }
}
