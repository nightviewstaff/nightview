import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';

class LoginRegistrationIconButton extends StatelessWidget {
  final String? text;
  final IconData icon;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;

  const LoginRegistrationIconButton({
    super.key,
    this.text, // Marked as optional
    required this.icon,
    this.onPressed,
    this.backgroundColor = Colors.transparent,
    this.iconColor = primaryColor,
    this.textColor = white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon Box
          Container(
            padding: const EdgeInsets.all(kMainPadding),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(
              icon,
              size: 50.0,
              color: iconColor,
            ),
          ),
          if (text != null) ...[
            const SizedBox(height: 8.0),
            // Text
            Text(
              text!,
              style: kTextStyleH2.copyWith(
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
