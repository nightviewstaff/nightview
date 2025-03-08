import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/hero_tags.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';

class LoginRegistrationConfirmButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool enabled;

  const LoginRegistrationConfirmButton({super.key, this.onPressed, this.text = 'Fortsæt', this.enabled = true});

  @override
  Widget build(BuildContext context) {
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
              text,
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
