import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {

  final VoidCallback? onPressed;
  final Widget? child;
  final Color color;

  const RoundButton({super.key, this.child, required this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 5.0,
      fillColor: color,
      shape: CircleBorder(),
      padding: EdgeInsets.all(8.0),
      onPressed: onPressed,
      child: child,
    );
  }
}
