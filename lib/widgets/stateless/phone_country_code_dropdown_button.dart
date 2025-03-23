import 'package:flutter/material.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/constants/input_decorations.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/constants/phone_country_code.dart';

class PhoneCountryCodeDropdownButton extends StatelessWidget {
  final Callback<CountryCode>? onChanged;
  final CountryCode value;

  const PhoneCountryCodeDropdownButton({
    super.key,
    required this.value,
    this.onChanged,
  });

  List<DropdownMenuItem<CountryCode>> getMenuItems() {
    return PhoneCountryCode.availableCountries
        .map((code) => DropdownMenuItem<CountryCode>(
              value: code,
              child: SizedBox(
                width: 100.0,
                height: 25,
                child: Row(
                  children: [
                    PhoneCountryCode(code).flagImage ?? SizedBox.shrink(),
                    SizedBox(width: kSmallSpacerValue),
                    Text(PhoneCountryCode(code).phoneCode!),
                  ],
                ),
              ),
            ))
        .toList()
      ..sort((a, b) =>
          int.parse(PhoneCountryCode(a.value!).phoneCode!.replaceAll('+', ''))
              .compareTo(int.parse(
                  PhoneCountryCode(b.value!).phoneCode!.replaceAll('+', ''))));
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<CountryCode>(
      decoration: kMainInputDecoration,
      value: value,
      items: getMenuItems(),
      onChanged: onChanged,
      isExpanded: true, // ✅ Ensures the dropdown width is usable

      menuMaxHeight:
          350.0, // ✅ Limits dropdown height to avoid excessive height
    );
  }
}
