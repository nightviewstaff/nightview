import 'package:flutter/material.dart';
import 'package:nightview/constants/button_styles.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/enums.dart';

import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';

class LoginRegistrationButton extends StatelessWidget {
  final String text;
  final LoginRegistrationButtonType type;
  final VoidCallback? onPressed;

  const LoginRegistrationButton({
    super.key,
    required this.text,
    required this.type,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: kLoginRegistrationButtonStyle.copyWith(
        backgroundColor: WidgetStatePropertyAll(
            type == LoginRegistrationButtonType.filled
                ? primaryColor
                : Colors.transparent),
        side: WidgetStatePropertyAll(
          BorderSide(
            color: type == LoginRegistrationButtonType.filled ? Colors.transparent : Colors.white,
            width: type == LoginRegistrationButtonType.filled ? 0.0 : kMainStrokeWidth,
          ),
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Text(
          text,
          style: kTextStyleH2,
        ),
      ),
    );
  }
}
