import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/values.dart';

const kLoginRegistrationButtonStyle = ButtonStyle(
  shape: WidgetStatePropertyAll(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(kMainBorderRadius)),
    ),
  ),
);

const kTextFieldLookalikeButtonStyle = ButtonStyle(
  shape: WidgetStatePropertyAll(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(kMainBorderRadius)),
    ),
  ),
  side: WidgetStatePropertyAll(
    BorderSide(
      color: Colors.white,
      width: kMainStrokeWidth,
    ),
  ),
  backgroundColor: WidgetStatePropertyAll(Colors.black),
  foregroundColor: WidgetStatePropertyAll(Colors.white),
  fixedSize: WidgetStatePropertyAll(
    Size(double.maxFinite, 60.0),
  ),
);

const kTransparentButtonStyle = ButtonStyle(
  shape: WidgetStatePropertyAll(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(kMainBorderRadius),
      ),
    ),
  ),
  side: WidgetStatePropertyAll(
    BorderSide(color: Colors.white, width: kMainStrokeWidth),
  ),
  backgroundColor: WidgetStatePropertyAll(Colors.transparent),
  foregroundColor: WidgetStatePropertyAll(Colors.white),
);

ButtonStyle kFilledButtonStyle = ButtonStyle(
  shape: WidgetStatePropertyAll(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(kMainBorderRadius),
      ),
    ),
  ),
  backgroundColor: WidgetStateProperty.resolveWith((states) {
    if (states.contains(WidgetState.disabled)) {
      return Colors.grey;
    }
    return primaryColor;
  }),
  foregroundColor: WidgetStatePropertyAll(Colors.white),
);
