import 'package:flutter/material.dart';
import 'package:nightview/constants/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/widgets/stateless/login_registration_button.dart';
import 'package:nightview/widgets/stateless/misc/progress_bar.dart';
import 'package:nightview/widgets/icons/back_button_top_left.dart';
import 'package:nightview/widgets/icons/logo_top_right.dart';
import 'package:nightview/screens/login_registration/creation/choose_clubbing_types.dart';

class ChooseClubbingLocationScreen extends StatefulWidget {
  static const id = 'choose_clubbing_location';

  const ChooseClubbingLocationScreen({super.key});

  @override
  State<ChooseClubbingLocationScreen> createState() =>
      _ChooseClubbingLocationScreenState();
}

class _ChooseClubbingLocationScreenState
    extends State<ChooseClubbingLocationScreen> {
  final Map<String, bool> _selectedLocations = {
    'København': false,
    'Aarhus': false,
    'Odense': false,
    'Aalborg': false,
    'Vejle': false,
  };

  @override
  void initState() {
    super.initState();
    _loadSelections(); // ✅ Load stored selections when screen opens
  }

  /// **🔹 Load stored selections**
  Future<void> _loadSelections() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (var location in _selectedLocations.keys) {
        _selectedLocations[location] = prefs.getBool(location) ?? false;
      }
    });
  }

  /// **🔹 Toggle selection & store in `SharedPreferences`**
  Future<void> _toggleLocation(String location) async {
    setState(() {
      _selectedLocations[location] = !_selectedLocations[location]!;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(location, _selectedLocations[location]!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: SafeArea(
        child: Stack(
          children: [
            /// **🔹 Header with Progress Bar**
            Positioned.fill(
              child: Column(
                children: [
                  ProgressBar(currentStep: 1, totalSteps: 3),
                  SizedBox(height: 20),
                ],
              ),
            ),

            /// **🔹 Logo (Top Right)**
            Positioned(top: 10, right: 10, child: ImageInsertDefaultTopRight()),

            /// **🔹 Main Content**
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 50), // ✅ Space below progress bar

                  /// **🔹 Title**
                  Text(
                    'Hvor tager du typisk i byen?',
                    style: kTextStyleH2,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),

                  /// **🔹 Location Buttons**
                  Expanded(
                    child: ListView(
                      children: _selectedLocations.keys.map((location) {
                        return _buildLocationButton(context, location);
                      }).toList(),
                    ),
                  ),

                  /// **🔹 Bottom Buttons**
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: LoginRegistrationButton(
                            height: 45,
                            borderRadius: 15,
                            text: 'Spring over',
                            type: LoginRegistrationButtonType.transparent,
                            textStyle: kTextStyleH3ToP1.copyWith(color: white),
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, ChooseClubbingTypesScreen.id);
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: LoginRegistrationButton(
                            height: 45,
                            borderRadius: 15,
                            text: 'Gem og fortsæt',
                            type: LoginRegistrationButtonType.transparent,
                            filledColor: primaryColor,
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, ChooseClubbingTypesScreen.id);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// **🟢 Location Toggle Button**
  Widget _buildLocationButton(BuildContext context, String location) {
    bool isSelected = _selectedLocations[location]!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? primaryColor : Colors.transparent,
          side: BorderSide(color: white, width: 2),
        ),
        onPressed: () => _toggleLocation(location),
        child: Text(location, style: kTextStyleH3),
      ),
    );
  }
}
