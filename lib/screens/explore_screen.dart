import 'dart:math';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:marquee/marquee.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/constants/icons.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/helpers/clubs/club_data_helper.dart';
import 'package:nightview/locations/location_service.dart';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/providers/night_map_provider.dart';
import 'package:nightview/screens/clubs/club_bottom_sheet.dart';
import 'package:nightview/screens/location_permission/location_permission_always_screen.dart';
import 'package:nightview/screens/utility/club_search_widget.dart';
import 'package:nightview/screens/utility/club_search_widget_explore.dart';
import 'package:nightview/screens/utility/emoji_priority_helper.dart';
import 'package:nightview/utilities/advanced_search_filter.dart';
import 'package:nightview/utilities/club_data/club_name_formatter.dart';
import 'package:nightview/utilities/club_data/club_opening_hours_formatter.dart';
import 'package:nightview/utilities/club_data/club_type_formatter.dart';
import 'package:nightview/utility/utility.dart';
import 'package:nightview/widgets/stateless/offer_image_grid.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:nightview/utility/utility.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late final ClubDataHelper clubDataHelper;
  final Distance distance = const Distance(); // For calculating distances

  late AdvancedSearchFilter _filter;
  late AdvancedSearchFilter _tempFilter;

  double expBase = 4;
  double maxDistanceKm = AdvancedSearchFilter.maxDistanceKm;

  double sliderToKm(double value) {
    return (value * value) * maxDistanceKm;
  }

//TODO Improve all sliders to zoom in/out when vlaues change.
  double kmToSlider(double km) {
    return sqrt((km / maxDistanceKm).clamp(0, 1));
  }

  @override
  void initState() {
    super.initState();
    clubDataHelper =
        Provider.of<NightMapProvider>(context, listen: false).clubDataHelper;
    clubDataHelper.clubDataList.addListener(_onClubDataChanged);
    _filter = AdvancedSearchFilter(
      selectedLocationTypes: ClubTypeFormatter.clubTypes.keys.toList(),
    );
  }

  void _onClubDataChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    clubDataHelper.clubDataList.removeListener(_onClubDataChanged);
    super.dispose();
  }

  double calculateDistance(LatLng point1, LatLng point2) {
    return distance(point1, point2);
  }

  int _getMaxAgeRestriction(List<ClubData> clubs) {
    if (clubs.isEmpty) return 30; // Default max age if no clubs
    return clubs
        .map((club) => club.ageRestriction)
        .reduce((a, b) => a > b ? a : b);
  }

  /// Calculates a completeness score based on valuable information.
  int _calculateCompletenessScore(ClubData club, double distanceInMeters) {
    int score = 0;

    // basic info
    score += club.ageRestriction >= 18 ? 2 : -2;
    score += (club.openingHours?.isNotEmpty ?? false) ? 1 : -1;
    // all has TODO ONLY SHOW OPEN TODAY!
    score += RegExp(r'^https?://').hasMatch(club.logo) ? 3 : -2;
    score += (club.tags?.length ?? 0).clamp(0, 3);

// If TILBUD LOTS

    score += club.hasMoodImages ? 5 : -2;
    //TODO rank higher for good images.
    // ⭐ Rating
    score += (2 * club.rating).round();

    // 🗺️ Personalized score

    // favorite clubs should play a part.
    // age should play a part.
    // if(user.age > 30)
    // clubs.agerestric >= 20 ++
    // if user.age == 18,19, clubs.agerestic == 18 ++ clubs over 20 -- if male. If female doesnt matter.
    // if

    if (PartyStatus == PartyStatus.yes) {
      // if (club.offerType != OfferType.none) score += 2;
      // if (club.rating >= 4) score += 1;
    }

    // Incorporate prefs - tags?

    // Club personalization
    // if visitors almost == totalPossibleAmountOfVisitors --
    // if visitors == totalPossibleAmountOfVisitors/2 ++
    // Timespecific ++
    // Gender amount ++ female if missing ++ male if missing.
    // if closing soon -- for each 30 mins

    // if (distanceInMeters < 5000) { // TODO
    //   score += 1; // 🏃 Close by get small bonus
    // } else if (distanceInMeters < 25000) {
    //   // score -= 1; // 🚍 25 km+ gets small minus
    // } else if (distanceInMeters < 40000) {
    //   // score -= 2; // 🚍 40 km+ gets slightly bigger minus
    // } else if (distanceInMeters < 65000) {
    //   // score -= 3; // 🚍 65 km+ gets slightly bigger minus
    // } else if (distanceInMeters < 99000) {
    //   score -= 6; // 🚀 99 km+ gets big minus
    // } else if (distanceInMeters < 200000) {
    //   score -= 7; // 🚀 200 km+ gets bigger minus
    // } else {
    //   score -= 9;
    //   // print('${club.id} before halve: $score');
    //   // score = (score / 2).round(); // ✈️ Out of region — heavily penalize
    //   // print('${club.id} after halve: $score');
    // }
    score -= distanceInMeters > 200000
        ? 50
        : distanceInMeters > 99000
            ? 10 // TODO
            : distanceInMeters > 65000
                ? 3
                : 0;

// Tests

    // score += (club.tags?.isNotEmpty ?? false) ? 2000 : 0; // TEST
    // score += (club.name.length > 20) ? 100 : 0;

    if (score >= 100) print('⭐ club over 100!: ${club.name} ($score)');

    return score.clamp(0, 100);
  }

  void _showAdvancedSearch() {
    _tempFilter = _filter.clone();

    final List<double> ageRestrictions = clubDataHelper.clubDataList.value
        .map((club) => club.ageRestriction.toDouble())
        .toSet()
        .toList()
      ..sort();
    final double maxAge =
        ageRestrictions.isNotEmpty ? ageRestrictions.last : 30;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Filters",
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return GestureDetector(
          onTap: () =>
              Navigator.of(context).pop(), // Dismiss when tapping outside
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: GestureDetector(
                onTap: () {}, // Prevent tap propagation
                child: Container(
                  margin: const EdgeInsets.only(
                      top: 120, left: 20, right: 20, bottom: 60),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.7,
                    maxWidth: MediaQuery.of(context).size.width,
                  ),
                  child: SingleChildScrollView(
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'All Filters',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Open Now',
                                      style:
                                          TextStyle(color: white, fontSize: 12),
                                    ),
                                    Switch(
                                      value: _tempFilter.showOpenOnly,
                                      activeColor: primaryColor,
                                      onChanged: (value) {
                                        setState(() {
                                          _tempFilter = _tempFilter.copyWith(
                                              showOpenOnly: value);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            _buildFilterSection(
                              title: 'Distance (km)',
                              filterValue: (_tempFilter.distanceMax / 1000) >=
                                      AdvancedSearchFilter.maxDistanceKm
                                  ? '${AdvancedSearchFilter.maxDistanceKm.toStringAsFixed(0)}+ km'
                                  : '0–${(_tempFilter.distanceMax / 1000).toStringAsFixed(0)} km',
                              child: SfSlider(
                                min: 0,
                                max: AdvancedSearchFilter.maxDistanceKm,
                                value: _tempFilter.distanceMax / 1000,
                                showLabels: true,
                                showTicks: true,
                                minorTicksPerInterval: 0,
                                interval: 5,
                                activeColor: primaryColor,
                                inactiveColor: secondaryColor,
                                trackShape: const SfTrackShape(),
                                onChanged: (dynamic value) {
                                  final km = (value as double) < 3
                                      ? 3
                                      : value; // 👈 block actual dragging below 3
                                  setState(() {
                                    _tempFilter = _tempFilter.copyWith(
                                      distanceMin: 0,
                                      distanceMax: km >=
                                              AdvancedSearchFilter.maxDistanceKm
                                          ? double.infinity
                                          : km * 100000,
                                    );
                                  });
                                },
                                labelFormatterCallback: (dynamic actualValue,
                                    String formattedText) {
                                  final value = (actualValue as num).toDouble();
// TODO FIND WAY TO MAKE EMOJIS BIGGER!
                                  if ((value - 0).abs() < 1) return '🚶';
                                  if ((value - 5).abs() < 1) return '5';
                                  if ((value - 10).abs() < 1) return '🚲';
                                  if ((value - 15).abs() < 1) return '15';
                                  if ((value - 20).abs() < 1) return '🚌';
                                  if ((value - 25).abs() < 1) return '25';
                                  if ((value - 30).abs() < 1) return '🚇';
                                  if ((value - 35).abs() < 1) return '35';
                                  if ((value - 40).abs() < 1) return '🚕';
                                  if ((value - 45).abs() < 1) return '45';
                                  if ((value - 50).abs() < 1) return '🚄';
                                  if ((value - 55).abs() < 1) return '55';
                                  if ((value - 60).abs() < 1) return '✈️';

                                  return ''; // Hide label otherwise or return formattedText;
                                },
                              ),
                            ),
                            // _buildFilterSection(
                            //   title: 'Price Range',
                            //   filterValue: _tempFilter.moneyMin ==
                            //           _tempFilter.moneyMax
                            //       ? '€${_tempFilter.moneyMin.toStringAsFixed(0)}'
                            //       : '€${_tempFilter.moneyMax.toStringAsFixed(0)}',
                            //   child: SfRangeSlider(
                            //     min: 0,
                            //     max: 5, // Max price, change as needed
                            //     values: SfRangeValues(
                            //       _tempFilter.moneyMin,
                            //       _tempFilter.moneyMax,
                            //     ),
                            //     showLabels: true,
                            //     showTicks: true,
                            //     minorTicksPerInterval: 0,
                            //     interval: 1, // Interval for price steps
                            //     activeColor: primaryColor,
                            //     inactiveColor: secondaryColor,
                            //     trackShape: const SfTrackShape(),
                            //     onChanged: (SfRangeValues values) {
                            //       setState(() {
                            //         _tempFilter = _tempFilter.copyWith(
                            //           moneyMin: values.start,
                            //           moneyMax: values.end,
                            //         );
                            //       });
                            //     },
                            //     labelFormatterCallback: (dynamic actualValue,
                            //         String formattedText) {
                            //       final value = (actualValue as num).toDouble();

                            //       // Emoji logic for different price ranges
                            //       if (value == 0) {
                            //         return '🆓'; // Free or low-cost
                            //       } else if (value == 1) {
                            //         return '💸'; // Moderate price (money with wings)
                            //       } else if (value == 2) {
                            //         return '💰'; // Price rising (money bag)
                            //       } else if (value == 3) {
                            //         return '3'; // Higher price (stack of money)
                            //       } else if (value == 4) {
                            //         return '💵'; // Higher price (stack of money)
                            //       } else if (value == 5) {
                            //         return '💳'; // Expensive (credit card)
                            //       } else
                            //         return '';
                            //     },
                            //   ),
                            // ),
                            _buildFilterSection(
                              title: 'Age Restriction',
                              filterValue:
                                  '${_tempFilter.ageMin.toStringAsFixed(0)}+',
                              child: SfSlider(
                                min: 18,
                                max: maxAge,
                                value: _tempFilter.ageMin,
                                showLabels: true,
                                showTicks: true,
                                minorTicksPerInterval: 0,
                                interval: 1,
                                activeColor: secondaryColor,
                                inactiveColor: primaryColor,
                                trackShape: SfTrackShape(),
                                onChanged: (dynamic value) {
                                  setState(() {
                                    _tempFilter = _tempFilter.copyWith(
                                      ageMin: value,
                                      ageMax:
                                          maxAge, // Keep maxAge as the maximum
                                    );
                                  });
                                },
                                labelFormatterCallback: (dynamic actualValue,
                                    String formattedText) {
                                  final value = (actualValue as num).toDouble();
                                  if ((value - 18).abs() < 1) return '🧑‍🎓';
                                  if ((value - 19).abs() < 1) return '👩‍🦰';
                                  if ((value - 20).abs() < 1) return '20';
                                  if ((value - 21).abs() < 1) return '🎉';
                                  if ((value - 22).abs() < 1) return '🍻';
                                  if ((value - 23).abs() < 1) return '23';
                                  if ((value - 24).abs() < 1) return '🧑‍🦱';
                                  if ((value - 25).abs() < 1) return '🧑‍🦳';

                                  return '${value.toInt()}+';
                                },
                              ),
                            ),
                            _buildFilterSection(
                                title: 'Rating',
                                filterValue: _tempFilter.ratingMin == 5
                                    ? '5'
                                    : '${_tempFilter.ratingMin}+',
                                child: SfSlider(
                                  min: 1,
                                  max: 5,
                                  stepSize: 1,
                                  value: _tempFilter.ratingMin.toDouble(),
                                  showLabels: true,
                                  showTicks: true,
                                  minorTicksPerInterval: 0,
                                  interval: 1,
                                  activeColor: secondaryColor,
                                  inactiveColor: primaryColor,
                                  trackShape: const SfTrackShape(),
                                  onChanged: (dynamic value) {
                                    setState(() {
                                      _tempFilter = _tempFilter.copyWith(
                                        ratingMin: (value as double).round(),
                                      );
                                    });
                                  },
                                  labelFormatterCallback: (dynamic actualValue,
                                      String formattedText) {
                                    final value = (actualValue as num).toInt();
                                    switch (value) {
                                      case 1:
                                        return '😕';
                                      case 2:
                                        return '2';
                                      case 3:
                                        return '🙂';
                                      case 4:
                                        return '4';
                                      case 5:
                                        return '😍';
                                      default:
                                        return '';
                                    }
                                  },
                                )),
                            _buildFilterSection(
                              title: 'Location Types',
                              filterValue: () {
                                final allTypes =
                                    ClubTypeFormatter.clubTypes.keys.toList();
                                if (_tempFilter.selectedLocationTypes.length ==
                                    allTypes.length) {
                                  return 'All types';
                                } else if (_tempFilter
                                    .selectedLocationTypes.isEmpty) {
                                  return '0 types';
                                } else {
                                  return '${_tempFilter.selectedLocationTypes.length} types';
                                }
                              }(),
                              child: SizedBox(
                                height: 60, // Match slider height
                                child: Builder(
                                  builder: (context) {
                                    final typeCounts = <String, int>{};
                                    for (final club
                                        in clubDataHelper.clubDataList.value) {
                                      final type = club.typeOfClub;
                                      typeCounts[type] =
                                          (typeCounts[type] ?? 0) + 1;
                                    }
                                    final sortedTypes = ClubTypeFormatter
                                        .clubTypes.keys
                                        .toList()
                                      ..sort((a, b) => (typeCounts[b] ?? 0)
                                          .compareTo(typeCounts[a] ?? 0));

                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: ClubTypeFormatter
                                          .clubTypes.keys.length,
                                      itemBuilder: (context, index) {
                                        final type = sortedTypes[index];
                                        final isSelected = _tempFilter
                                            .selectedLocationTypes
                                            .contains(type);
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: GestureDetector(
                                            onDoubleTap: () {
                                              setState(() {
                                                final currentSelected =
                                                    _tempFilter
                                                        .selectedLocationTypes;
                                                final isOnlyThisSelected =
                                                    currentSelected.length ==
                                                            1 &&
                                                        currentSelected
                                                            .contains(type);

                                                final allTypes =
                                                    ClubTypeFormatter
                                                        .clubTypes.keys
                                                        .toList();

                                                if (isOnlyThisSelected) {
                                                  _tempFilter =
                                                      _tempFilter.copyWith(
                                                    selectedLocationTypes:
                                                        List<String>.from(
                                                            allTypes),
                                                  );
                                                } else {
                                                  _tempFilter =
                                                      _tempFilter.copyWith(
                                                    selectedLocationTypes: [
                                                      type
                                                    ],
                                                  );
                                                }
                                              });
                                            },
                                            onTap: () {
                                              setState(() {
                                                final updatedTypes = List<
                                                        String>.from(
                                                    _tempFilter
                                                        .selectedLocationTypes);
                                                if (isSelected) {
                                                  updatedTypes.remove(type);
                                                } else {
                                                  updatedTypes.add(type);
                                                }
                                                _tempFilter =
                                                    _tempFilter.copyWith(
                                                        selectedLocationTypes:
                                                            updatedTypes);
                                              });
                                            },
                                            child: Stack(
                                              children: [
                                                Container(
                                                  width: 45,
                                                  height: 45,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          'images/club_types/${type}_icon.png'),
                                                      fit: BoxFit.cover,
                                                      colorFilter: isSelected
                                                          ? null
                                                          : ColorFilter.mode(
                                                              black.withOpacity(
                                                                  0.85),
                                                              BlendMode.darken,
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                                if (isSelected)
                                                  Positioned(
                                                    top: 1,
                                                    right: 1,
                                                    child: Icon(
                                                      Icons.check_outlined,
                                                      color: white,
                                                      size: 20,
                                                    ),
                                                  ),
                                                Positioned(
                                                  bottom: 18,
                                                  left: 2,
                                                  right: 2,
                                                  child: SizedBox(
                                                    height:
                                                        10, // Adjust to match text height
                                                    child: Marquee(
                                                      text:
                                                          Utility.formatString(
                                                              type),
                                                      style: const TextStyle(
                                                        fontSize: 8,
                                                        color: white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      scrollAxis:
                                                          Axis.horizontal,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      blankSpace: 35.0,
                                                      velocity: 15.0,
                                                      pauseAfterRound: Duration(
                                                          milliseconds:
                                                              100), // very short pause
                                                      fadingEdgeEndFraction:
                                                          0.1,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                            // _buildFilterSection(
                            //   title: 'Crowd Presence',
                            //   filterValue: _tempFilter.minCrowdFillPercent ==
                            //           100
                            //       ? '100%'
                            //       : '${_tempFilter.minCrowdFillPercent.toInt()}%+',
                            //   child: SfSlider(
                            //     min: 0,
                            //     max: 80,
                            //     value: _tempFilter.minCrowdFillPercent,
                            //     showLabels: true,
                            //     showTicks: true,
                            //     minorTicksPerInterval: 0,
                            //     //TODO make some softcoded logic for interval compared to stepsize
                            //     interval: 20,
                            //     stepSize: 5,
                            //     activeColor: primaryColor,
                            //     inactiveColor: secondaryColor,
                            //     trackShape: const SfTrackShape(),
                            //     onChanged: (dynamic value) {
                            //       setState(() {
                            //         _tempFilter = _tempFilter.copyWith(
                            //           minCrowdFillPercent: (value as double),
                            //         );
                            //       });
                            //     },
                            //     labelFormatterCallback: (dynamic actualValue,
                            //         String formattedText) {
                            //       final value = (actualValue as num).toDouble();
                            //       if (value == 0) return '🪦'; // Empty
                            //       if (value == 20) return '25%';
                            //       if (value == 40) return '💃';
                            //       if (value == 60) return '60%';
                            //       if (value == 80) return '🔥';
                            //       return ''; // Full
                            //     },
                            //   ),
                            // ),
                            // _buildFilterSection(
                            //   title: 'Female Presence',
                            //   filterValue:
                            //       '${_tempFilter.minFemalePercent.toInt()}%+',
                            //   child: SfSlider(
                            //     min: 0,
                            //     max: 40,
                            //     value:
                            //         _tempFilter.minFemalePercent.clamp(0, 40),
                            //     showLabels: true,
                            //     showTicks: true,
                            //     minorTicksPerInterval: 0,
                            //     interval: 5,
                            //     stepSize: 5,
                            //     activeColor: primaryColor,
                            //     inactiveColor: secondaryColor,
                            //     trackShape: const SfTrackShape(),
                            //     onChanged: (dynamic value) {
                            //       setState(() {
                            //         _tempFilter = _tempFilter.copyWith(
                            //           minFemalePercent: (value as double),
                            //         );
                            //       });
                            //     },
                            //     labelFormatterCallback: (dynamic actualValue,
                            //         String formattedText) {
                            //       final value = (actualValue as num).toDouble();
                            //       if (value == 0) return '🍆';
                            //       if (value == 5) return '5%';
                            //       if (value == 10) return '🧍‍♂️';
                            //       if (value == 15) return '15%';
                            //       if (value == 20) return '💁‍♀️';
                            //       if (value == 25) return '25%';
                            //       if (value == 30) return '💃';
                            //       if (value == 35) return '35%';
                            //       if (value == 40) return '👯‍♀️';
                            //       return '';
                            //     },
                            //   ),
                            // ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ).then((_) {
      setState(() {
        _filter = _tempFilter;
      });
    });
  }

// Add this helper method to create a consistent filter section layout
  Widget _buildFilterSection({
    required String title,
    required Widget child,
    String? filterValue,
    // required Function(String) onValueChanged, // Callback for manual input
  }) {
    TextEditingController controller = TextEditingController();

    // Set initial value of TextField to filterValue if provided, otherwise default to empty string
    controller.text = filterValue ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white, // Use your actual color here
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // When user taps on the filter value, show TextField to input new value
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Enter $title'),
                        content: TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Enter value',
                            hintStyle: TextStyle(color: white),
                          ),
                          style: const TextStyle(color: white),
                          onSubmitted: (value) {
                            // Call the onValueChanged when user submits the value
                            // onValueChanged(value);
                            Navigator.of(context).pop(); // Close dialog
                          },
                        ),
                      );
                    },
                  );
                },
                child: Text(
                  filterValue ?? 'Tap to enter value',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white, // Use your actual color here
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          if (title == 'Location Types') const SizedBox(height: 8),
          child,
          SizedBox(
            height: 6,
          ),
          Divider(
            thickness: 0.5,
            color: white,
          ),
        ],
      ),
    );
  }

  SliverChildDelegate buildClubListDelegate(LatLng userLocation) {
    List<ClubData> allClubs = clubDataHelper.clubDataList.value;
    if (allClubs.isEmpty) {
      return SliverChildBuilderDelegate(
        (context, index) => const Center(child: CircularProgressIndicator()),
        childCount: 1,
      );
    }

    // Filter clubs based on all criteria
    List<ClubData> filteredClubs = allClubs.where((club) {
      // Distance filter
      double dist = calculateDistance(userLocation, LatLng(club.lat, club.lon));
      bool withinDistance =
          dist >= _filter.distanceMin && dist <= _filter.distanceMax;

      // Age restriction filter
      bool withinAge = club.ageRestriction >= _filter.ageMin &&
          club.ageRestriction <= _filter.ageMax;

      // Price range filter (assuming club.price exists; adjust if not)
      // bool withinMoney = club.price != null
      //     ? (club.price >= _filter.moneyMin && club.price <= _filter.moneyMax)
      //     : true; // Default to true if price is unavailable

      // Rating filter
      bool withinRating = club.rating >= _filter.ratingMin;

      // Location types filter
      bool withinLocationType =
          _filter.selectedLocationTypes.contains(club.typeOfClub);

      // Crowd presence filter (assuming club.currentCrowdPercent exists; adjust if not)
      // bool withinCrowd = club.visitors != null
      //     ? (club.visitors >= club.totalPossibleAmountOfVisitors/Filter.minCrowdFillPercent)
      //     : true; // Default to true if unavailable

      // Female presence filter (assuming club.femalePercent exists; adjust if not)
      // bool withinFemale = club.femalePercent != null
      //     ? (club.femalePercent >= _filter.minFemalePercent)
      //     : true; // Default to true if unavailable

      // Open now filter
      bool isOpen = ClubOpeningHoursFormatter.isClubOpen(club);
      bool openFilter = !_filter.showOpenOnly || isOpen;

      return withinDistance &&
          withinAge &&
          //  withinMoney &&
          withinRating &&
          withinLocationType &&
          // withinCrowd &&
          // withinFemale &&
          openFilter;
    }).toList();

    // If no clubs match, show message and relaxed filter results
    if (filteredClubs.isEmpty) {
      // Relaxed filter: loosen distance, age, and rating slightly
      List<ClubData> relaxedClubs = allClubs.where((club) {
        double dist =
            calculateDistance(userLocation, LatLng(club.lat, club.lon));
        bool withinRelaxedDistance =
            dist <= _filter.distanceMax * 1.5; // 50% more distance
        bool withinRelaxedAge =
            club.ageRestriction >= _filter.ageMin - 2 && // Lower age by 2
                club.ageRestriction <= _filter.ageMax + 2; // Raise age by 2
        bool withinRelaxedRating =
            club.rating >= _filter.ratingMin - 1; // Lower rating by 1
        bool withinLocationType =
            _filter.selectedLocationTypes.contains(club.typeOfClub);
        bool isOpen = ClubOpeningHoursFormatter.isClubOpen(club);
        bool openFilter = !_filter.showOpenOnly || isOpen;

        return withinRelaxedDistance &&
            withinRelaxedAge &&
            withinRelaxedRating &&
            withinLocationType &&
            openFilter;
      }).toList();

      // Sort relaxed clubs
      relaxedClubs.sort((a, b) {
        bool aOpen = ClubOpeningHoursFormatter.isClubOpen(a);
        bool bOpen = ClubOpeningHoursFormatter.isClubOpen(b);
        if (aOpen != bOpen) {
          return aOpen ? -1 : 1;
        }
        double distA = calculateDistance(userLocation, LatLng(a.lat, a.lon));
        double distB = calculateDistance(userLocation, LatLng(b.lat, b.lon));
        int aScore = _calculateCompletenessScore(a, distA);
        int bScore = _calculateCompletenessScore(b, distB);
        if (bScore != aScore) {
          return bScore.compareTo(aScore);
        } else {
          return distA.compareTo(distB);
        }
      });

      return SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'No locations found with your current filters!',
                  style: TextStyle(color: redAccent, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          ClubData club = relaxedClubs[index - 1];
          return buildClubCard(club);
        },
        childCount: relaxedClubs.isEmpty ? 1 : relaxedClubs.length + 1,
      );
    }

    // Sort the filtered clubs
    filteredClubs.sort((a, b) {
      bool aOpen = ClubOpeningHoursFormatter.isClubOpen(a);
      bool bOpen = ClubOpeningHoursFormatter.isClubOpen(b);
      if (aOpen != bOpen) {
        return aOpen ? -1 : 1;
      }
      double distA = calculateDistance(userLocation, LatLng(a.lat, a.lon));
      double distB = calculateDistance(userLocation, LatLng(b.lat, b.lon));
      int aScore = _calculateCompletenessScore(a, distA);
      int bScore = _calculateCompletenessScore(b, distB);
      if (bScore != aScore) {
        return bScore.compareTo(aScore);
      } else {
        return distA.compareTo(distB);
      }
    });

    return SliverChildBuilderDelegate(
      (context, index) {
        ClubData club = filteredClubs[index];
        return buildClubCard(club);
      },
      childCount: filteredClubs.length,
    );
  }

  /// Fetches mood image URLs from Firestore based on club ID
  Future<List<String>> fetchMoodImages(String clubId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('mood_images')
        .where('club_id', isEqualTo: clubId)
        .get();
    return querySnapshot.docs.map((doc) => doc['url'] as String).toList();
  }

  /// Fetches stock mood images from Firebase Storage
  Future<List<String>> fetchStockImages(String clubId) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('club_images/$clubId/mood_images_stock');
    final result = await ref.listAll();
    return await Future.wait(
      result.items.map((item) => item.getDownloadURL()),
    );
  }

  Widget buildClubCard(ClubData club) {
    return GestureDetector(
      onTap: () {
        // DONT GO TO MAP! TODO
        ClubBottomSheet.showClubSheet(context: context, club: club);
      },
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 360),
          margin: const EdgeInsets.only(top: 35),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: black,
                    border: Border.all(color: grey, width: 0.7),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(width: 25),
                            Text(
                              // if(!club.displayname)
                              ClubNameFormatter.formatClubName(club.name),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        if (club.ageRestriction >= 18)
                          Text(
                            "${club.ageRestriction}+",
                            style: const TextStyle(
                              color: white,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    club.tags != null && club.tags!.isNotEmpty
                        ? SizedBox(
                            height: 30,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: club.tags!.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 6),
                              itemBuilder: (context, index) {
                                final sortedTags = List.from(club.tags!)
                                  ..sort((a, b) {
                                    final emojiA =
                                        ClubDataHelper.tagEmojiMap[a] ?? '';
                                    final emojiB =
                                        ClubDataHelper.tagEmojiMap[b] ?? '';
                                    return EmojiPriorityHelper.getEmojiPriority(
                                            emojiB)
                                        .compareTo(EmojiPriorityHelper
                                            .getEmojiPriority(emojiA));
                                  });

                                final tag = sortedTags[index];
                                final emoji = ClubDataHelper.tagEmojiMap[tag] ??
                                    ''; // Added fallback

                                return Chip(
                                  label: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Text(
                                            emoji,
                                            style: const TextStyle(
                                                fontSize: 20, color: white),
                                          ),
                                          alignment:
                                              PlaceholderAlignment.middle,
                                        ),
                                        WidgetSpan(
                                          child: Text(
                                            Utility.formatString(tag),
                                            style: const TextStyle(
                                                fontSize: 10, color: white),
                                          ),
                                          alignment:
                                              PlaceholderAlignment.middle,
                                        ),
                                      ],
                                    ),
                                  ),
                                  backgroundColor: black, // Black background
                                  side: const BorderSide(
                                    color:
                                        primaryColor, // Small border with primary color
                                    width: 1.5,
                                    // style: BorderStyle.dashed, // Dashed style
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), // Slightly less rounded
                                  ),
                                  visualDensity: const VisualDensity(
                                      horizontal: -4, vertical: -4),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  padding: EdgeInsets.zero,
                                );
                              },
                            ),
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(height: 8),
                    FutureBuilder<List<String>>(
                      future: fetchMoodImages(club.id),
                      builder: (context, snapshot) {
                        List<String> moodImages = snapshot.data ?? [];
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError || moodImages.isEmpty) {
                          return FutureBuilder<List<String>>(
                            future: fetchStockImages(club.id),
                            builder: (context, stockSnapshot) {
                              List<String> stockImages =
                                  stockSnapshot.data ?? [];
                              if (stockSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              return SizedBox(
                                height: 80,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: stockImages.isNotEmpty
                                      ? stockImages.length
                                      : 15,
                                  itemBuilder: (context, imageIndex) {
                                    final imageProvider = stockImages.isNotEmpty
                                        ? NetworkImage(stockImages[imageIndex])
                                        : AssetImage(
                                                'images/swipe/${imageIndex + 1}.png')
                                            as ImageProvider;

                                    // Fallback backup
                                    return Container(
                                      margin: const EdgeInsets.only(right: 6),
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        }
                        return SizedBox(
                          height: 60,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: moodImages.length,
                            itemBuilder: (context, imageIndex) {
                              String imageUrl = moodImages[imageIndex];
                              return Container(
                                margin: const EdgeInsets.only(right: 8),
                                width: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -20,
                left: -20,
                child: CircleAvatar(
                  radius: 26,
                  backgroundColor: transparent,
                  backgroundImage: NetworkImage(club.logo),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LatLng?>(
      future: LocationService.getUserLocation(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData) {
          return const LocationPermissionAlwaysScreen();
        }

        final userLocation = snapshot.data!;
        return Scaffold(
          backgroundColor: black,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: _showAdvancedSearch,
                          child: defaultSettingIcon,
                        ),
                        const SizedBox(width: 12),
                        // Expanded(
                        //   child: ValueListenableBuilder<List<ClubData>>(
                        //     valueListenable: clubDataHelper.clubDataList,
                        //     builder: (context, allClubs, _) {
                        //       if (allClubs.isEmpty) {
                        //         return const Center(
                        //           child: CircularProgressIndicator(
                        //             strokeWidth: 1,
                        //             color: secondaryColor,
                        //           ),
                        //         );
                        //       }
                        //       // return ClubSearchWidgetExplore(controller: controller, onChanged: ClubBottomSheet.showClubSheet(context: ));
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                if (2 < 2) //TODO When working OFFER IMAGES!
                  const SliverToBoxAdapter(
                    child: OfferImageGrid(),
                  ),
                SliverList(
                  delegate: buildClubListDelegate(userLocation),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
