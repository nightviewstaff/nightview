import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/values.dart';

class IconWithText extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;
  final Color textColor;
  final VoidCallback? onTap;
  final bool showCircle; // Toggle for circle or outline

  IconWithText({
    super.key,
    required this.icon,
    required this.text,
    this.iconColor = primaryColor,
    this.textColor = white,
    this.onTap,
    this.showCircle = true, // Defaults to showing a black circle
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          if (showCircle)
            Container(
              width: 64.0, // Fixed size for the circle
              height: 64.0,
              decoration: BoxDecoration(
                color: Colors.black, // Black circle background
                shape: BoxShape.circle,
              ),
              child: Center(
                child: FaIcon(
                  icon,
                  color: iconColor,
                  size: 60.0, // Icon size inside the circle
                ),
              ),
            )
          else
            Stack(
              alignment: Alignment.center,
              children: [
                FaIcon(
                  icon,
                  color: Colors.black,
                  size: 64.0, // Slightly larger for the outline
                ),
                FaIcon(
                  icon,
                  color: iconColor,
                  size: 60.0, // Actual icon size
                ),
              ],
            ),
          SizedBox(height: kSmallSpacerValue), // Space between icon and text
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  offset: Offset(-1, -1), // Top-left
                  blurRadius: 0,
                  color: Colors.black,
                ),
                Shadow(
                  offset: Offset(1, -1), // Top-right
                  blurRadius: 0,
                  color: Colors.black,
                ),
                Shadow(
                  offset: Offset(1, 1), // Bottom-right
                  blurRadius: 0,
                  color: Colors.black,
                ),
                Shadow(
                  offset: Offset(-1, 1), // Bottom-left
                  blurRadius: 0,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
