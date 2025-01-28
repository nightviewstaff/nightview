import 'package:flutter/material.dart';
import 'package:nightview/constants/values.dart';

class BigCheckbox extends StatelessWidget {

  final CheckBoxCallback? onChanged;
  final bool value;

  const BigCheckbox({super.key, required this.value, this.onChanged});


  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 2.0,
      child: Checkbox(
        value: value,
        fillColor: WidgetStatePropertyAll(Colors.transparent),
        side: WidgetStateBorderSide.resolveWith(
              (states) => BorderSide(
            color: Colors.white,
            width: kMainStrokeWidth * 0.5,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kSubtleBorderRadius * 0.5),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
