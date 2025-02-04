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
  final double width; // Allows custom button width
  final double height; // Allows custom button height
  final double borderRadius; // Allows custom border radius
  final EdgeInsetsGeometry padding; // Allows custom padding
  final TextStyle textStyle; // Allows custom text styling
  final Color filledColor; // Allows custom filled button color
  final Color outlinedColor; // Allows custom outlined button color
  final double outlinedWidth; // Allows custom outlined border width
  final IconData? icon;

  const LoginRegistrationButton({
    super.key,
    required this.text,
    required this.type,
    this.onPressed,
    this.width = double.infinity, // Default to full width
    this.height = (17*3), // Default height
    this.borderRadius = kMainBorderRadius, // Default border radius
    this.padding = const EdgeInsets.symmetric(vertical: 12.0), // Default padding
    this.textStyle = kTextStyleH3ToP1, // Default text style
    this.filledColor = black, // Default filled button color
    this.outlinedColor = white, // Default outlined button border color
    this.outlinedWidth = kMainStrokeWidth, // Default border width
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            type == LoginRegistrationButtonType.transparent ? filledColor : Colors.transparent,
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              side: BorderSide(
                color: type == LoginRegistrationButtonType.filled ? Colors.transparent : outlinedColor,
                width: type == LoginRegistrationButtonType.filled ? 0.0 : outlinedWidth,
              ),
            ),
          ),
          padding: WidgetStateProperty.all(padding),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20.0, color: textStyle.color),
              // const SizedBox(width: 4), // Add spacing between icon and text
            ],
            Text(
              text,
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
