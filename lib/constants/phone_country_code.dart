import 'package:flutter/material.dart';
import 'package:nightview/constants/enums.dart';

class PhoneCountryCode {
  final String? phoneCode;
  final int? minimumPhoneNumberLength;
  final Image? flagImage;
  final CountryCode countryCode;

  static const Map<CountryCode, String> _phoneCodes = {
    CountryCode.al: '+355',
    CountryCode.ad: '+376',
    CountryCode.am: '+374',
    CountryCode.at: '+43',
    CountryCode.by: '+375',
    CountryCode.be: '+32',
    CountryCode.ba: '+387',
    CountryCode.bg: '+359',
    CountryCode.hr: '+385',
    CountryCode.cy: '+357',
    CountryCode.cz: '+420',
    CountryCode.dk: '+45',
    CountryCode.ee: '+372',
    CountryCode.fi: '+358',
    CountryCode.fr: '+33',
    CountryCode.ge: '+995',
    CountryCode.de: '+49',
    CountryCode.gr: '+30',
    CountryCode.hu: '+36',
    CountryCode.ic: '+354',
    CountryCode.ie: '+353',
    CountryCode.it: '+39',
    CountryCode.lv: '+371',
    CountryCode.li: '+423',
    CountryCode.lt: '+370',
    CountryCode.lu: '+352',
    CountryCode.mt: '+356',
    CountryCode.md: '+373',
    CountryCode.mc: '+377',
    CountryCode.me: '+382',
    CountryCode.nl: '+31',
    CountryCode.mk: '+389',
    CountryCode.no: '+47',
    CountryCode.pl: '+48',
    CountryCode.pt: '+351',
    CountryCode.ro: '+40',
    CountryCode.ru: '+7',
    CountryCode.sm: '+378',
    CountryCode.rs: '+381',
    CountryCode.sk: '+421',
    CountryCode.si: '+386',
    CountryCode.es: '+34',
    CountryCode.se: '+46',
    CountryCode.ch: '+41',
    CountryCode.ua: '+380',
    CountryCode.gb: '+44',
    CountryCode.us: '+1'
  };

  static const Map<CountryCode, int> _minimumPhoneNumberLength = {
    CountryCode.al: 9,
    CountryCode.ad: 6,
    CountryCode.am: 8,
    CountryCode.at: 10,
    CountryCode.by: 9,
    CountryCode.be: 9,
    CountryCode.ba: 8,
    CountryCode.bg: 9,
    CountryCode.hr: 8,
    CountryCode.cy: 8,
    CountryCode.cz: 9,
    CountryCode.dk: 8,
    CountryCode.ee: 7,
    CountryCode.fi: 9,
    CountryCode.fr: 9,
    CountryCode.ge: 9,
    CountryCode.de: 10,
    CountryCode.gr: 10,
    CountryCode.hu: 9,
    CountryCode.ic: 7,
    CountryCode.ie: 9,
    CountryCode.it: 9,
    CountryCode.lv: 8,
    CountryCode.li: 7,
    CountryCode.lt: 8,
    CountryCode.lu: 9,
    CountryCode.mt: 8,
    CountryCode.md: 8,
    CountryCode.mc: 8,
    CountryCode.me: 8,
    CountryCode.nl: 9,
    CountryCode.mk: 8,
    CountryCode.no: 8,
    CountryCode.pl: 9,
    CountryCode.pt: 9,
    CountryCode.ro: 9,
    CountryCode.ru: 10,
    CountryCode.sm: 8,
    CountryCode.rs: 9,
    CountryCode.sk: 9,
    CountryCode.si: 8,
    CountryCode.es: 9,
    CountryCode.se: 7,
    CountryCode.ch: 9,
    CountryCode.ua: 9,
    CountryCode.gb: 9,
    CountryCode.us: 10
  };

  /// **Only countries with flag images are selectable**
  static final Map<CountryCode, Image> _flagImages = {
    for (var code in _phoneCodes.keys)
      code: Image.asset(
        'images/flags/${code.name.toLowerCase()}.png',
        errorBuilder: (_, __, ___) => SizedBox.shrink(), // ✅ Avoids crashes
      ),
  };

  PhoneCountryCode(this.countryCode)
      : phoneCode = _phoneCodes[countryCode],
        minimumPhoneNumberLength = _minimumPhoneNumberLength[countryCode],
        flagImage = _flagImages[countryCode];

  /// ✅ **Returns only countries with a flag image**
  static List<CountryCode> get availableCountries => _flagImages.entries
      .where((e) => e.value != SizedBox.shrink())
      .map((e) => e.key)
      .toList();
}
