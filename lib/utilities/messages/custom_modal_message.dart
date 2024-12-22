import 'package:flutter/material.dart';

class CustomModalMessage {
  static void showCustomBottomSheetOneSecond({
    required BuildContext context,
    required String message,
    required TextStyle textStyle,
    EdgeInsets padding = const EdgeInsets.all(15.0),
    Duration autoDismissDuration = const Duration(seconds: 1),
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

    Future.delayed(autoDismissDuration, () {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }

}
