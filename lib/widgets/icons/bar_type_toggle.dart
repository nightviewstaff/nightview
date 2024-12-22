import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/constants/colors.dart';

class BarTypeToggle extends StatefulWidget {
  final Function(String type, bool isEnabled) onToggle; // Callback to notify toggle state

  const BarTypeToggle({required this.onToggle, super.key});

  @override
  State<BarTypeToggle> createState() => _BarTypeToggleState();
}

class _BarTypeToggleState extends State<BarTypeToggle> {
  // Track the toggle state for each bar type
  Map<String, bool> toggledStates = {
    "Cocktailbar": true,
    "Bar": true,
    "Club": true,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: toggledStates.keys.map((clubType) {
        return GestureDetector(
          onTap: () {
            setState(() {
              toggledStates[clubType] = !toggledStates[clubType]!;
            });

            // Notify parent about the toggle state
            widget.onToggle(clubType, toggledStates[clubType]!);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: toggledStates[clubType]! ? primaryColor : redAccent,
                radius: 20,
                child: Icon(
                  toggledStates[clubType]! ? FontAwesomeIcons.toggleOn : FontAwesomeIcons.toggleOff,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                clubType,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// Example of updating the map
void onToggle(String type, bool isEnabled) {
  if (isEnabled) {
    // enabledClubTypes.add(type); // Add the type to enabled list
  } else {
    // enabledClubTypes.remove(type); // Remove the type from enabled list
  }

  // Refresh the map with filtered clubs
  // final filteredClubs = allClubs.where((club) => enabledClubTypes.contains(club.typeOfClub)).toList();
  // updateMap(filteredClubs);
}
