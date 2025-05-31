import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/icons.dart';

class BackButtonTopLeft extends StatelessWidget {
  final VoidCallback onPressed;
  final double top;
  final double left;
  final Color color;
  final bool arrowIcon;

  const BackButtonTopLeft({
    super.key,
    required this.onPressed,
    this.top = 10.0,
    this.left = 10.0,
    this.color = white,
    this.arrowIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    Icon iconWidget;

    if (arrowIcon) {
      iconWidget = Icon(defaultGoBackIcon, color: color);
    } else {
      iconWidget = Icon(ChevronGoBackIcon, color: color);
    }

    return Positioned(
      top: top,
      left: left,
      child: IconButton(
        icon: iconWidget,
        onPressed: onPressed,
      ),
    );
  }
}
