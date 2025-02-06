import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/values.dart';

class BarTypeMapToggle extends StatefulWidget {
  static final Map<String, bool> toggledStates = {};
  final String clubType; // The specific club type this toggle is for
  final Function(bool isEnabled)
      onToggle; // Callback to notify parent of state change
  final VoidCallback updateMarkers;

  const BarTypeMapToggle({
    required this.clubType,
    required this.onToggle,
    required this.updateMarkers,
    super.key,
  });

  @override
  State<BarTypeMapToggle> createState() => _BarTypeMapToggleState();
}

class _BarTypeMapToggleState extends State<BarTypeMapToggle> {
  late bool isToggled;

  void toggleAllTogglesTrue(BuildContext context) {
    setState(() {
      BarTypeMapToggle.toggledStates.updateAll((key, value) => true);
    });
  }

  @override
  void initState() {
    super.initState();
    if (!BarTypeMapToggle.toggledStates.containsKey(widget.clubType)) {
      BarTypeMapToggle.toggledStates[widget.clubType] =
          true; // Default toggled true
    }
    isToggled = BarTypeMapToggle.toggledStates[widget.clubType]!; // Sync state
  }

  @override
  Widget build(BuildContext context) {
    isToggled = BarTypeMapToggle.toggledStates[widget.clubType]!;

    return GestureDetector(
      onTap: () {
        setState(() {
          isToggled = !isToggled;
          BarTypeMapToggle.toggledStates[widget.clubType] = isToggled;
        });
        widget.onToggle(isToggled);
        widget.updateMarkers(); // Call the callback to update markers
      },

      // onLongPress: () {
      // widget.updateMarkers();
      // toggleAllTogglesTrue(context); // Trigger long press functionality


      // child: Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: [
      //     CircleAvatar(
      //       backgroundColor: isToggled ? primaryColor : redAccent,
      //       // secondaryColor,
      //       radius: kBigSizeRadius,
      //       child: Center(
      //         child: Icon(
      //           // size: 25.5, // Perfect value if big radius.
      //           isToggled
      //               ? FontAwesomeIcons.toggleOn
      //               : FontAwesomeIcons.toggleOff,
      //           color: white,
      //         ),
      //       ),
      //     ),
      //     const SizedBox(width: kSmallPadding),
      //   ],

      child: Row(
        mainAxisSize: MainAxisSize.min, // Only take the required space
        children: [
          Icon(
            isToggled
                ? FontAwesomeIcons.toggleOn // Icon for toggled state
                : FontAwesomeIcons.toggleOff, // Icon for untoggled state
            color: isToggled ? primaryColor : redAccent, // Dynamic color
            size: 30, // Icon size
          ),
          const SizedBox(width: kBigPadding), // Spacing after the icon
        ],
      ),
    );
  }
}
