import 'package:flutter/material.dart';

class CustomModalMessage {
  static void showCustomBottomSheetOneSecond({
    required BuildContext context,
    required String message,
    required TextStyle textStyle,
    EdgeInsets padding = const EdgeInsets.all(15.0),
    int autoDismissDurationSeconds = 1,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: padding,
        child: Text(
          message,
          style: textStyle,
        ),
      ),
    );

    Future.delayed(Duration(seconds: autoDismissDurationSeconds), () {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }
}
