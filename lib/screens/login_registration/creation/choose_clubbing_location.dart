import 'package:flutter/material.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/widgets/stateless/login_registration_button.dart';
import 'package:nightview/widgets/stateless/misc/progress_bar.dart';
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
  final List<String> _locationKeys = [
    'location_copenhagen',
    'location_aarhus',
    'location_odense',
    'location_aalborg',
    'location_vejle',
  ];
  final Map<String, String> _originalKeys = {
    'location_copenhagen': 'København',
    'location_aarhus': 'Aarhus',
    'location_odense': 'Odense',
    'location_aalborg': 'Aalborg',
    'location_vejle': 'Vejle',
  };
  late Map<String, bool> _selectedLocations;

  @override
  void initState() {
    super.initState();
    _selectedLocations = {
      for (var key in _locationKeys) key: false,
    };
    _loadSelections(); // ✅ Load stored selections when screen opens
  }

  /// **🔹 Load stored selections**
  Future<void> _loadSelections() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (var key in _locationKeys) {
        _selectedLocations[key] = prefs.getBool(_originalKeys[key]!) ?? false;
      }
    });
  }

  /// **🔹 Toggle selection & store in `SharedPreferences`**
  Future<void> _toggleLocation(String key) async {
    setState(() {
      _selectedLocations[key] = !_selectedLocations[key]!;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_originalKeys[key]!, _selectedLocations[key]!);
  }

  String _getLocalizedLocation(String key) {
    switch (key) {
      case 'location_copenhagen':
        return S.of(context).location_copenhagen;
      case 'location_aarhus':
        return S.of(context).location_aarhus;
      case 'location_odense':
        return S.of(context).location_odense;
      case 'location_aalborg':
        return S.of(context).location_aalborg;
      case 'location_vejle':
        return S.of(context).location_vejle;
      default:
        return key;
    }
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
                    S.of(context).where_do_you_usually_go_out_title,
                    style: kTextStyleH2,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),

                  /// **🔹 Location Buttons**
                  Expanded(
                    child: ListView(
                      children: _locationKeys.map((key) {
                        return _buildLocationButton(context, key);
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
                            text: S.of(context).skip_button,
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
                            text: S.of(context).save_and_continue_button,
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
        child: Text(
          _getLocalizedLocation(location),
          style: kTextStyleH3,
        ),
      ),
    );
  }
}
