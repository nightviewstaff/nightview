import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/input_decorations.dart';
import 'package:nightview/constants/values.dart';

class CustomTextField {
  static Widget buildTextField({
    required TextEditingController? controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    required void Function(String) onChanged,
    required String? Function(String?) validator,
    bool isObscure = false, // Default false
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textAlign: TextAlign.center,
      obscureText: isObscure, // Hide text if true

      decoration: kMainInputDecoration.copyWith(
        hintText: controller!.text.isEmpty ? hintText : null,
        hintStyle: TextStyle(
          color: controller.text.isNotEmpty ? primaryColor : grey,
        ),
      ),
      style: TextStyle(
        color: controller.text.isNotEmpty ? primaryColor : grey,
        fontSize: defaultFontSize,
        fontWeight: FontWeight.w600,
      ),
      textCapitalization: TextCapitalization.words,
      onChanged: onChanged,
      validator: validator,
    );
  }
}
