import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';

class ClubMarker extends StatelessWidget {
  final Widget logo; // Changed from ImageProvider<Object> to Widget
  final int visitors;
  final VoidCallback? onTap;
  final Color borderColor;

  const ClubMarker({
    super.key,
    required this.borderColor,
    required this.logo,
    required this.visitors,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: backgroundLocationEnabled,
            child: Container(
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(kSubtleBorderRadius),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(kSmallPadding),
                child: Text(
                  visitors.toString(),
                  style: kTextStyleP2.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: backgroundLocationEnabled,
            child: SizedBox(
              height: kSmallSpacerValue,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle, // Changed to BoxShape.circle
              border: Border.all(
                color: borderColor,
                width: 3.0,
              ),
            ),
            child: CircleAvatar(
              child: ClipOval(child: logo), // Use the Widget directly
              radius: 15,
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
