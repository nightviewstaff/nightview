import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/icons.dart';

class BackButtonTopLeft extends StatelessWidget {
  final VoidCallback onPressed;
  final double top;
  final double left;
  final Color color;

  const BackButtonTopLeft({
    Key? key,
    required this.onPressed,
    this.top = 10.0,
    this.left = 10.0,
    this.color = white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
    Positioned(
      top: top,
      left: left,

      child: IconButton(

        icon: Icon(defaultGoBackIcon, color: color,),
        onPressed: onPressed,
      ),
    );
  }
}
