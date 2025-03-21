import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:nightview/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/screens/login_registration/creation/choose_clubbing_location.dart';
import 'package:nightview/screens/login_registration/creation/choose_favorite_clubs.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/widgets/stateless/misc/progress_bar.dart';
import 'package:nightview/widgets/icons/back_button_top_left.dart';
import 'package:nightview/widgets/icons/logo_top_right.dart';
import 'package:nightview/widgets/stateless/login_registration_button.dart';

class ChooseClubbingTypesScreen extends StatefulWidget {
  static const id = 'choose_clubbing_types';

  const ChooseClubbingTypesScreen({super.key});

  @override
  State<ChooseClubbingTypesScreen> createState() =>
      _ChooseClubbingTypesScreenState();
}

class _ChooseClubbingTypesScreenState extends State<ChooseClubbingTypesScreen> {
  List<String> _imagePaths = [];
  Map<String, bool> _selectedCategories = {};

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  /// **🔹 Fetch images dynamically & remove duplicates**
  Future<void> _loadImages() async {
    try {
      final manifestJson = await rootBundle.loadString('AssetManifest.json');
      final paths = manifestJson
          .split('"')
          .where((element) => element.contains('images/club_types/'))
          .toSet()
          .toList();

      setState(() {
        _imagePaths = paths;
        _selectedCategories = {for (var path in paths) path: false};
      });

      await _loadSelections(); // ✅ Load saved selections after images load
    } catch (e) {
      print("Error loading images: $e");
    }
  }

  /// **🔹 Load stored selections**
  Future<void> _loadSelections() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (var path in _imagePaths) {
        _selectedCategories[path] = prefs.getBool(path) ?? false;
      }
    });
  }

  /// **🔹 Toggle Selection & Save**
  Future<void> _toggleSelection(String path) async {
    setState(() {
      _selectedCategories[path] =
          !(_selectedCategories[path] ?? false); // Fix null check
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(path, _selectedCategories[path]!); // Safe after setting
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: SafeArea(
        child: Stack(
          children: [
            /// **🔹 Header**
            Positioned.fill(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProgressBar(currentStep: 2, totalSteps: 3),
                  SizedBox(height: 20),
                ],
              ),
            ),

            /// **🔹 Back Button**
            Positioned(
              top: 10,
              left: 10,
              child: BackButtonTopLeft(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, ChooseClubbingLocationScreen.id);
                },
              ),
            ),

            /// **🔹 Logo**
            Positioned(top: 10, right: 10, child: ImageInsertDefaultTopRight()),

            /// **🔹 Main Content**
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 50),
                  Text(
                    S.of(context).where_do_you_usually_go_out_title,
                    style: kTextStyleH2,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),

                  /// **🔹 Club Type Icons (Dynamic Grid) with Scrollbar**
                  Expanded(
                    child: Scrollbar(
                      child: _imagePaths.isEmpty
                          ? Center(
                              child: CircularProgressIndicator(
                                  color: primaryColor))
                          : GridView.builder(
                              padding: EdgeInsets.only(bottom: 20),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                              ),
                              itemCount: _imagePaths.length,
                              itemBuilder: (context, index) {
                                String imagePath = _imagePaths[index];
                                bool isSelected =
                                    _selectedCategories[imagePath] ?? false;
                                return _buildCategoryButton(
                                    imagePath, isSelected);
                              },
                            ),
                    ),
                  ),

                  /// **🔹 Bottom Buttons**
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 20),
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
                                  context, ChooseFavoriteClubsScreen.id);
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
                                  context, ChooseFavoriteClubsScreen.id);
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

  /// **🟢 Category Button with Label Inside**
  Widget _buildCategoryButton(String imagePath, bool isSelected) {
    String label = imagePath
        .split('/')
        .last
        .replaceAll('_icon.png', '')
        .replaceAll('_', ' ')
        .capitalize();

    if (label.toLowerCase() == "bar club") {
      label = "Bar/Club";
    }

    return GestureDetector(
      onTap: () => _toggleSelection(imagePath),
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// **🟢 Circular Background**
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? primaryColor.withOpacity(0.9) : primaryColor,
              border:
                  isSelected ? Border.all(color: primaryColor, width: 3) : null,
            ),
            child: ClipOval(
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
          ),

          /// **🟢 Text Inside Circle**
          Positioned(
            top: 6,
            child: Text(
              label,
              style: kTextStyleP1.copyWith(
                color: white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// **🔠 Capitalize String Extension**
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}


// TODO SOMETIME COOL JUMP.
  // /// **🟢 Category Button with Label Inside**
  // Widget _buildCategoryButton(String imagePath, bool isSelected) {
  //   String label = _formatLabel(imagePath);

  //   return GestureDetector(
  //     onTap: () => _toggleSelection(imagePath),
  //     child: Stack(
  //       alignment: Alignment.center,
  //       children: [
  //         /// **🟢 Circular Background**
  //         Container(
  //           width: 65,
  //           height: 65,
  //           decoration: BoxDecoration(
  //             shape: BoxShape.circle,
  //             color: isSelected ? primaryColor.withOpacity(0.9) : primaryColor,
  //             border: isSelected
  //                 ? Border.all(
  //                     color: primaryColor, width: 3) // **Add white border**
  //                 : null,
  //           ),
  //           child: ClipOval(
  //             child: Image.asset(imagePath, fit: BoxFit.cover),
  //           ),
  //         ),

  //         /// **🟢 Text Inside Circle (Centered at 80% height)**
  //         Positioned(
  //           top: 8, // Moves text higher inside the circle
  //           child: Text(
  //             label,
  //             style: kTextStyleP1.copyWith(
  //               color: white,
  //               fontSize: 12,
  //               fontWeight: FontWeight.bold, // Makes text stand out
  //             ),
  //             textAlign: TextAlign.center,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // /// **🔠 Format Club Type Labels**
  // String _formatLabel(String path) {
  //   String label = path
  //       .split('/')
  //       .last
  //       .replaceAll('_icon.png', '') // Remove filename suffix
  //       .replaceAll('_', ' ') // Replace underscores with spaces
  //       .capitalize();

  //   // ✅ Special case fix
  //   if (label.toLowerCase() == "bar club") {
  //     label = "Bar/Club";
  //   }

  //   return label;
  // }