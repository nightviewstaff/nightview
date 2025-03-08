import 'package:flutter/material.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/constants/input_decorations.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/constants/phone_country_code.dart';

class PhoneCountryCodeDropdownButton extends StatelessWidget {
  final Callback<CountryCode>? onChanged;
  final CountryCode value;

  const PhoneCountryCodeDropdownButton(
      {super.key, required this.value, this.onChanged});

  List<DropdownMenuItem<CountryCode>> getMenuItems() {
    List<DropdownMenuItem<CountryCode>> items = [];

    for (CountryCode code in CountryCode.values) {
      items.add(
        DropdownMenuItem<CountryCode>(
          value: code,
          child: SizedBox(
            width: 80.0,
            height: kBigSizeRadius,
            child: Row(
              children: [
                PhoneCountryCode(code).flagImage!,
                SizedBox(
                  width: kSmallSpacerValue,
                ),
                Text(
                  PhoneCountryCode(code).phoneCode!,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<CountryCode>(
      decoration: kMainInputDecoration,
      value: value,
      items: getMenuItems(),
      onChanged: onChanged,
    );
  }
}
