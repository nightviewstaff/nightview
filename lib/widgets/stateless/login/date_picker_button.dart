import 'package:flutter/material.dart';
import 'package:nightview/constants/button_styles.dart';

class DatePickerButton extends StatelessWidget {

  final DateTime date;
  final VoidCallback? onPressed;

  const DatePickerButton({super.key, required this.date, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: kTextFieldLookalikeButtonStyle,
      onPressed: onPressed,
      child: Text('${date.day} / ${date.month} / ${date.year}'),
    );
  }
}
