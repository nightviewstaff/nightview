import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';

import 'package:nightview/generated/l10n.dart';

class ClubSearchWidgetExplore extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const ClubSearchWidgetExplore({
    Key? key,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: S.of(context).search_locations,
        hintStyle: kTextStyleP2,
        prefixIcon: const Icon(Icons.search_sharp, color: primaryColor),
        filled: true,
        fillColor: grey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      ),
      style: kTextStyleP3.copyWith(color: white),
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}
