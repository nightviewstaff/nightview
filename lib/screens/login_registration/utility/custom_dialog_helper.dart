import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/generated/l10n.dart';

class CustomDialogHelper {
  static void showErrorDialog(
      BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: TextStyle(color: redAccent)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(S.of(context).ok, style: TextStyle(color: redAccent)),
          ),
        ],
      ),
    );
  }
}
