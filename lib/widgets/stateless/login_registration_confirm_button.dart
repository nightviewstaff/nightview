import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/hero_tags.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/generated/l10n.dart';

class LoginRegistrationConfirmButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text; // Make text nullable to allow default
  final bool enabled;

  const LoginRegistrationConfirmButton({
    super.key,
    this.onPressed,
    this.text, // Remove default value to enforce context usage
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    // Use provided text or default to 'continueButton'
    final buttonText = text ?? S.of(context).continues;

    return Hero(
      tag: kHeroConfirmationButton,
      child: TextButton(
        onPressed: () {
          if (enabled) {
            onPressed?.call();
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              buttonText, // Use the resolved text
              style: kTextStyleH2,
            ),
            SizedBox(
              width: kNormalSpacerValue,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: enabled ? primaryColor : Colors.grey,
                  width: kMainStrokeWidth,
                ),
              ),
              child: Icon(
                Icons.keyboard_arrow_right,
                color: enabled ? primaryColor : Colors.grey,
                weight: kMainStrokeWidth,
                size: 40.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
