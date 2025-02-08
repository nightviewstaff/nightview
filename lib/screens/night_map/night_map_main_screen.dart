import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/constants/icons.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/helpers/clubs/club_data_helper.dart';
import 'package:nightview/locations/location_service.dart';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/providers/night_map_provider.dart';
import 'package:nightview/screens/clubs/club_bottom_sheet.dart';
import 'package:nightview/screens/location_permission/location_permission_always_screen.dart';
import 'package:nightview/screens/night_map/night_map.dart';
import 'package:nightview/screens/night_map/search_bar_TODO/custom_search_bar.dart';
import 'package:nightview/screens/utility/hour_glass_loading_screen.dart';
import 'package:nightview/utilities/club_data/club_age_restriction_formatter.dart';
import 'package:nightview/utilities/club_data/club_data_location_formatting.dart';
import 'package:nightview/utilities/club_data/club_distance_calculator.dart';
import 'package:nightview/utilities/club_data/club_opening_hours_formatter.dart';
import 'package:nightview/utilities/club_data/club_type_formatter.dart';
import 'package:nightview/widgets/icons/bar_type_toggle.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utilities/club_data/club_name_formatter.dart';

class NightMapMainScreen extends StatefulWidget {
  static const id = 'night_map_main_screen';

  const NightMapMainScreen({super.key});

  @override
  State<NightMapMainScreen> createState() => _NightMapMainScreenState();
}

class _NightMapMainScreenState extends State<NightMapMainScreen> {
  final GlobalKey<NightMapState> nightMapKey =
      GlobalKey<NightMapState>(); // Prop needs refac
  Map<String, bool> toggledClubTypeStates = {};

  late final ClubDataHelper clubDataHelper; // Store instance
  late final SearchController _searchController;

  @override
  void initState() {
    super.initState();
    clubDataHelper =
        Provider.of<NightMapProvider>(context, listen: false).clubDataHelper;
    _searchController = SearchController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<int> getUserCount() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('user_data').get();
      return snapshot.docs.length;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  double getDecimalValue({required int amount, required int fullAmount}) {
    // TODO In utility
    double value = amount / fullAmount;
    if (value < 0.01) return 0.01;
    if (value > 1.0) return 1.0;
    return value;
  }

  int getPercentValue({required int amount, required int fullAmount}) {
    return (amount / fullAmount * 100).round();
  }

  // double getwidth() {
  //   if (Provider.of<GlobalProvider>(context).partyCount < 10) {
  //     return 40.00;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // TODO Needs complete rework. Does too much


    return FutureBuilder<LatLng?>(
        future: LocationService.getUserLocation(),
        // Needed in order to call showalltypesbar + seach. Prop needs refac
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return LocationPermissionAlwaysScreen();
          }

          final userLocation = snapshot.data!;

          return Column(
            children:
                //toggledStates.keys.map((clubTypeKey))
                [
              Padding(
                padding: const EdgeInsets.all(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //TOP part
                    Text(
                      'Brugere i byen nu',
                      style: kTextStyleH3,
                    ),
                    Row(
                      children: [
                        Consumer<GlobalProvider>(
                          builder: (context, provider, child) {
                            return Container(
                              height: 40.00,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                border: Border.all(
                                    color: white, width: kMainStrokeWidth),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: kMainPadding),
                                child: Center(
                                  child: Text(
                                    provider.partyCount.toString(),
                                    style: kTextStyleH3.copyWith(
                                        color: primaryColor),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(width: kNormalSpacerValue),
                        FutureBuilder<int>(
                          future: getUserCount(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('E');
                            } else if (!snapshot.hasData ||
                                snapshot.data == 0) {
                              return Text('ND');
                            }

                            int userCount = snapshot.data!;

                            return Consumer<GlobalProvider>(
                              builder: (context, provider, child) {
                                double percentValue = getDecimalValue(
                                  amount: provider.partyCount,
                                  fullAmount: userCount,
                                );

                                return CircularPercentIndicator(
                                  radius: kNormalSizeRadius,
                                  lineWidth: 3.0,
                                  percent: percentValue,
                                  center: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: (percentValue * 100)
                                              .toStringAsFixed(0),
                                          style: kTextStyleH3.copyWith(
                                            color: primaryColor,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '%',
                                          style: kTextStyleH3.copyWith(
                                              fontSize: 15.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                  progressColor: secondaryColor,
                                  backgroundColor: white,
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ValueListenableBuilder<List<ClubData>>(
                        //TODO if clubdatalist contains too few display loader!
                        valueListenable: clubDataHelper.clubDataList,
                        builder: (context, allClubs, _) {
                          if (allClubs.isEmpty) {
                            return Center(
                              // TODO different in future.
                              child: CircularProgressIndicator(
                                strokeWidth: 1,
                                color: secondaryColor,
                              ),
                            );
                          }
                          return ValueListenableBuilder<Set<String>>(
                            valueListenable: clubDataHelper.allClubTypes,
                            builder: (context, typeOfClub, _) {
                              return SearchAnchor(
                                viewBackgroundColor: black,
                                isFullScreen: false,
                                dividerColor: primaryColor,
                                keyboardType: TextInputType.text,
                                viewElevation: 2,
                                viewConstraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            1, // 90%screen
                                    maxHeight:
                                        MediaQuery.of(context).size.height *
                                            0.40 // 45%screen // MAY BE TODO
                                    ),
                                builder: (context, controller) {
                                  // Error dispose and recalled? Needs to be destoyed if disposed? TODO
                                  return SearchBar(
                                    controller: controller,
                                    leading: Icon(Icons.search_sharp,
                                        color: primaryColor),
                                    hintText:
                                        "Søg efter lokationer, områder eller andet",
                                    hintStyle:
                                        MaterialStateProperty.all(kTextStyleP2),
                                    backgroundColor: MaterialStateProperty.all(
                                        grey.shade800),
                                    shadowColor: MaterialStateProperty.all(
                                        secondaryColor),
                                    elevation: MaterialStateProperty.all(4),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      controller.openView();
                                      // updateRecommendedClub
                                    },
                                    onTap: () {
                                      controller.openView();
                                      // Somehow toggleview
                                      if (allClubs.isEmpty ||
                                          allClubs.length <
                                              clubDataHelper
                                                      .remainingNearbyClubsNotifier
                                                      .value -
                                                  50) {
                                        HourGlassLoadingScreen(
                                          color: secondaryColor,
                                        );
                                      }
                                      // else{
                                      //   Build clubs TODO
                                      // }
                                    },
                                    onTapOutside: (PointerDownEvent event) {
                                      if (controller.isOpen) {
                                        controller.closeView(
                                            ""); // Ensure search view is closed completely
                                      }

                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        if (!mounted)
                                          return; // Only update if the widget is still in the tree.
                                        controller.clear();
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      });
                                    },
                                  );
                                },

                                suggestionsBuilder: (context, controller) {
                                  // Lowercase and trim the search input.
                                  String userInputLowerCase =
                                      controller.text.toLowerCase().trim();

                                  // Filter clubs by comparing name, type, location, or age restriction.
                                  List<ClubData> sortedClubs =
                                      ClubDistanceCalculator
                                          .sortClubsByDistance(
                                    userLat: userLocation.latitude,
                                    userLon: userLocation.longitude,
                                    clubs: allClubs,
                                  ).where((club) {
                                    // Check if the club name matches.
                                    bool matchesName = club.name
                                        .toLowerCase()
                                        .contains(userInputLowerCase);

                                    // Check if the club type matches.
                                    bool matchesType = club.typeOfClub
                                        .toLowerCase()
                                        .contains(userInputLowerCase);
                                    ClubTypeFormatter.clubTypes;
                                    //TODO Danish and enclish Same as location

                                    // Normalize the club's displayed location.
                                    String normalizedClubLocation =
                                        ClubDataLocationFormatting
                                                .normalizeLocation(
                                                    ClubNameFormatter
                                                        .displayClubLocation(
                                                            club))
                                            .toLowerCase();

                                    // Normalize the search term.
                                    String normalizedSearch =
                                        ClubDataLocationFormatting
                                                .normalizeLocation(
                                                    controller.text)
                                            .toLowerCase();

                                    // Check if the normalized location contains the normalized search.
                                    bool matchesLocation =
                                        normalizedClubLocation
                                            .contains(normalizedSearch);

                                    // Check for age restriction.
                                    // If input looks like "21+" then compare exactly (without the plus)
                                    // Otherwise, check if the club's age restriction contains the input.
                                    bool matchesAgeRestriction;
                                    if (RegExp(r'^\d+\+$')
                                        .hasMatch(userInputLowerCase)) {
                                      matchesAgeRestriction =
                                          club.ageRestriction.toString() ==
                                              userInputLowerCase
                                                  .replaceAll("+", "")
                                                  .trim();
                                    } else {
                                      matchesAgeRestriction = club
                                          .ageRestriction
                                          .toString()
                                          .contains(userInputLowerCase);
                                    }

                                    // Return true if any of the criteria match.
                                    return matchesName ||
                                        matchesType ||
                                        matchesLocation ||
                                        matchesAgeRestriction;
                                  }).toList();

                                  // If no clubs match, show a "no clubs found" message.
                                  if (sortedClubs.isEmpty) {
                                    return [
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(
                                            "Ingen lokationer fundet",
                                            style: TextStyle(
                                                color: redAccent, fontSize: 14),
                                          ),
                                        ),
                                      ),
                                    ];
                                  }

                                  if (sortedClubs.isEmpty) {
                                    return [
                                      Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(16.0),
                                          // Row(
                                          //   mainAxisAlignment: MainAxisAlignment.center,
                                          //   children: [
                                          //     Icon(Icons.search_off, size: 50, color: Colors.grey), // Icon
                                          //     SizedBox(width: 8), // Space between icon and text
                                          //     Text(
                                          //       "Ingen lokationer fundet",
                                          //       style: TextStyle(
                                          //         color: redAccent,
                                          //         fontSize: 12,
                                          //         fontWeight: FontWeight.bold,
                                          //       ),
                                          //     ),
                                          //   ],
                                          // )
                                          // Distance efterfølgende!

                                          child: Text(
                                            "Ingen lokationer fundet",
                                            style: TextStyle(
                                                color: redAccent, fontSize: 14),
                                          ),
                                        ),
                                      ),
                                    ];
                                  }

                                  // while(controller.isOpen){
                                  //   controller.openView(); // TODO WHERE DO I PUT THIS
                                  // }
                                  // if (allClubs.isEmpty) {
                                  //   // TODO Needs to be able to opdate
                                  //   //TODO There are 2 instances of view. I want 1 at all times, then sho and hide it. THE VIEW DOESNT UPDATE. IT SHOULD STAY ONE INSTANCE AND UPDATE REALTIME
                                  //   return [
                                  //     HourGlassLoadingScreen(
                                  //       color: secondaryColor,
                                  //     ),
                                  //     // TODO Null error '_owneer !=null': is not true....
                                  //     //TODO REBUILDS NOT ALLOWED!
                                  //     ListTile(
                                  //       title: Text(
                                  //         "Henter lokationer",
                                  //         style: TextStyle(
                                  //             fontSize: 12,
                                  //             fontWeight: FontWeight.bold),
                                  //       ),
                                  //     )
                                  //   ];
                                  // }
                                  // Make sure populated or display loading. Continually populate

                                  // Otherwise, return the filtered clubs.
                                  return sortedClubs.map((club) {
                                    String formattedClubName =
                                        ClubNameFormatter.formatClubName(
                                            club.name);
                                    String formattedClubLocation =
                                        ClubNameFormatter.displayClubLocation(
                                            club);
                                    String formattedDistance =
                                        ClubDistanceCalculator
                                            .displayDistanceToClub(
                                      club: club,
                                      userLat: userLocation.latitude,
                                      userLon: userLocation.longitude,
                                    );
                                    bool hasCustomLogo =
                                        club.typeOfClubImg.isNotEmpty;

                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                                club.logo),
                                        radius: kBigSizeRadius,
                                      ),
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(formattedClubName,
                                              style: kTextStyleP3),
                                          const SizedBox(height: 2.0),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  formattedClubLocation,
                                                  style: kTextStyleP3.copyWith(
                                                      color: primaryColor),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Text(
                                                formattedDistance,
                                                style: kTextStyleP3.copyWith(
                                                    color: primaryColor),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      trailing: hasCustomLogo
                                          ? CircleAvatar(
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                      club.typeOfClubImg),
                                              radius: 15.0,
                                            )
                                          : const SizedBox(
                                              width: 30, height: 30),
                                      onTap: () {
                                        if (controller.isOpen) {
                                          controller.closeView("");
                                        }
                                        Provider.of<NightMapProvider>(context,
                                                listen: false)
                                            .nightMapController
                                            .move(LatLng(club.lat, club.lon),
                                                kCloseMapZoom);
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        ClubBottomSheet.showClubSheet(
                                            context: context, club: club);
                                      },
                                    );
                                  }).toList();

                                  // try {
                                  //   for (var club in allClubs) {
                                  //     // TODO default errorhandeling
                                  //     bool locationMatch =
                                  //         ClubDataLocationFormatting
                                  //             .danishCitiesAndAreas.entries
                                  //             .any((entry) {
                                  //       return entry.value.any((altName) =>
                                  //           altName
                                  //               .toLowerCase()
                                  //               .contains(userInputLowerCase));
                                  //     });
                                  //
                                  //     bool clubNameMatch = club.name
                                  //         .toLowerCase()
                                  //         .contains(userInputLowerCase);
                                  //     bool clubTypeMatch = club.typeOfClub
                                  //         .toLowerCase()
                                  //         .contains(userInputLowerCase);
                                  //     bool ageRestrictionMatch =
                                  //         RegExp(r'^\d+\+$')
                                  //                 .hasMatch(userInputLowerCase)
                                  //             ? club.ageRestriction
                                  //                     .toString() ==
                                  //                 userInputLowerCase
                                  //                     .replaceAll("+", "")
                                  //                     .trim()
                                  //             : club.ageRestriction
                                  //                 .toString()
                                  //                 .contains(userInputLowerCase);
                                  //
                                  //     bool isMatch = locationMatch ||
                                  //         clubNameMatch ||
                                  //         clubTypeMatch ||
                                  //         ageRestrictionMatch;
                                  //
                                  //     // bool isOpen =
                                  //     //     ClubOpeningHoursFormatter.isClubOpen(
                                  //     //         club);
                                  //
                                  //     // bool visitorsMatch = club.visitors != null && club.visitors.toString().contains(userInputLowerCase);
                                  //     // bool ratingMatch = club.rating.toString().contains(userInputLowerCase); // TODO TOGGLE
                                  //     // OfferType offerType; // Future
                                  //   }
                                  //   List<ClubData> sortedClubs = [
                                  //     ...openClubs,
                                  //     ...closedClubs
                                  //   ]..sort((a, b) {
                                  //       final distanceA = ClubDistanceCalculator
                                  //           .calculateDistance(
                                  //         lat1: userLocation.latitude,
                                  //         lon1: userLocation.longitude,
                                  //         lat2: a.lat,
                                  //         lon2: a.lon,
                                  //       );
                                  //       final distanceB = ClubDistanceCalculator
                                  //           .calculateDistance(
                                  //         lat1: userLocation.latitude,
                                  //         lon1: userLocation.longitude,
                                  //         lat2: b.lat,
                                  //         lon2: b.lon,
                                  //       );
                                  //       return distanceA.compareTo(distanceB);
                                  //     });
                                  //
                                  //   if (sortedClubs.isEmpty) {
                                  //     return [
                                  //       Center(
                                  //         child: Column(
                                  //           mainAxisAlignment:
                                  //               MainAxisAlignment.center,
                                  //           children: [
                                  //             Row(
                                  //               mainAxisAlignment:
                                  //                   MainAxisAlignment.start,
                                  //               // Pushes everything left
                                  //               children: [
                                  //                 Icon(
                                  //                     Icons.error_outline_sharp,
                                  //                     size: 35,
                                  //                     color: redAccent),
                                  //                 // Stays on the left
                                  //                 SizedBox(width: 8),
                                  //                 // Space between icon and text
                                  //                 Expanded(
                                  //                   // Allows text to be centered while the icon stays left
                                  //                   child: Center(
                                  //                     child: Text(
                                  //                       "Ingen lokationer fundet",
                                  //                       style: TextStyle(
                                  //                         color: redAccent,
                                  //                         fontSize: 15,
                                  //                         fontWeight:
                                  //                             FontWeight.bold,
                                  //                       ),
                                  //                     ),
                                  //                   ),
                                  //                 ),
                                  //               ],
                                  //             ),
                                  //             const SizedBox(
                                  //               height: kBiggerSpacerValue,
                                  //             ),
                                  //             Text(
                                  //               "Du kan søge efter navn, lokation, type af lokation og´aldersgrænse", //TODO keep updated with sofcoded method
                                  //               style: TextStyle(
                                  //                   fontSize: 12,
                                  //                   color: primaryColor),
                                  //               textAlign: TextAlign.center,
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //     ];
                                  //   }
                                  //
                                  //   return sortedClubs.map((club) {
                                  //     String formattedClubName =
                                  //         ClubNameFormatter.formatClubName(
                                  //             club.name);
                                  //     String formattedClubLocation =
                                  //         ClubNameFormatter.displayClubLocation(
                                  //             club);
                                  //     String formattedDistance =
                                  //         ClubDistanceCalculator
                                  //             .displayDistanceToClub(
                                  //       club: club,
                                  //       userLat: userLocation.latitude,
                                  //       userLon: userLocation.longitude,
                                  //     );
                                  //
                                  //     bool hasCustomLogo =
                                  //         club.typeOfClubImg.isNotEmpty;
                                  //
                                  //     return ListTile(
                                  //       leading: CircleAvatar(
                                  //         backgroundImage:
                                  //             CachedNetworkImageProvider(
                                  //                 club.logo),
                                  //         radius: kBigSizeRadius,
                                  //       ),
                                  //       title: Column(
                                  //         crossAxisAlignment:
                                  //             CrossAxisAlignment.start,
                                  //         children: [
                                  //           Text(
                                  //             formattedClubName,
                                  //             style: kTextStyleP3,
                                  //           ),
                                  //           const SizedBox(height: 2.0),
                                  //           // Spacing between name and location
                                  //           Row(
                                  //             mainAxisAlignment:
                                  //                 MainAxisAlignment
                                  //                     .spaceBetween,
                                  //             children: [
                                  //               Expanded(
                                  //                 child: Text(
                                  //                   formattedClubLocation,
                                  //                   style:
                                  //                       kTextStyleP3.copyWith(
                                  //                           color:
                                  //                               primaryColor),
                                  //                   overflow: TextOverflow
                                  //                       .ellipsis, // Handle long text gracefully
                                  //                 ),
                                  //               ),
                                  //               Text(
                                  //                 formattedDistance,
                                  //                 style: kTextStyleP3.copyWith(
                                  //                     color: primaryColor),
                                  //               ),
                                  //             ],
                                  //           )
                                  //         ],
                                  //       ),
                                  //       trailing: Column(
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment.end,
                                  //         children: [
                                  //           hasCustomLogo
                                  //               ? CircleAvatar(
                                  //                   backgroundImage:
                                  //                       CachedNetworkImageProvider(
                                  //                           club.typeOfClubImg),
                                  //                   radius: 15.0,
                                  //                 )
                                  //               : const SizedBox(
                                  //                   width: 30,
                                  //                   // Same width and height as CircleAvatar
                                  //                   height: 30,
                                  //                 ),
                                  //         ],
                                  //       ),
                                  //       onTap: () {
                                  //         if (controller.isOpen) {
                                  //           controller.closeView("");
                                  //           // controller.closeView(controller.text.trim());
                                  //         }
                                  //         Provider.of<NightMapProvider>(context,
                                  //                 listen: false)
                                  //             .nightMapController
                                  //             .move(LatLng(club.lat, club.lon),
                                  //                 kCloseMapZoom);
                                  //         FocusManager.instance.primaryFocus
                                  //             ?.unfocus();
                                  //         ClubBottomSheet.showClubSheet(
                                  //             context: context, club: club);
                                  //       },
                                  //     );
                                  //   }).toList();
                                  // } catch (e) {
                                  //   print(
                                  //       "Error filtering or sorting clubs: $e");
                                  //   return [
                                  //     ListTile(
                                  //       title: Text("En fejl opstod",
                                  //           style: TextStyle(color: redAccent)),
                                  //       subtitle: Text("Prøv igen senere."),
                                  //     ),
                                  //   ];
                                  // }
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: kNormalSpacerValue),
                    GestureDetector(
                      onTap: () {
                        showAllTypesOfBars(context, userLocation);
                      },
                      child: const FaIcon(
                        defaultDownArrow,
                        color: primaryColor,
                        size: 20.0,
                      ),
                    ),
                    const SizedBox(width: kNormalSpacerValue),
                  ],
                ),
              ),

              // The actual map
              Expanded(
                child: GestureDetector(
                  // Maybe close everyhting else when clicking map?
                  behavior: HitTestBehavior.translucent,
                  // controller.closeView// TODO NEED TO CLOSE CONTROLLER Otherwise black screen!
                  onTap: () {
                    // _closeSearchAndOverlay(); Close search TODO
                    FocusManager.instance.primaryFocus?.unfocus();
                    // Unfocus the SearchField when tapping the map
                    FocusScope.of(context).unfocus();
                  },
                  child: NightMap(key: nightMapKey), // Your map widget
                ),
              ),
            ],
          );
        });
  }

  void showAllTypesOfBars(BuildContext context, LatLng userLocation) {
    final clubDataHelper =
        Provider.of<NightMapProvider>(context, listen: false).clubDataHelper;

    showModalBottomSheet(
      context: context,
      backgroundColor: black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        return FutureBuilder(
          future: _waitForClubs(clubDataHelper),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return _buildLoadingIndicator();
            }

            var allClubs = clubDataHelper.clubData.values.toList();
            final clubsByType = _groupClubsByType(allClubs);
            final sortedClubTypes = _sortClubTypes(clubsByType);

            return ListView(
              children: sortedClubTypes.map((entry) {
                final type = entry.key;
                final clubs = _sortClubsByDistance(entry.value, userLocation);

                return ExpansionTile(
                  title: _buildExpansionTileTitle(type, clubs),
                  children: _buildClubListTiles(clubs, context, userLocation),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }

  Future<void> _waitForClubs(ClubDataHelper clubDataHelper) async {
    while (clubDataHelper.clubData.length < clubDataHelper.totalAmountOfClubs) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: secondaryColor),
          const SizedBox(height: 16),
          Text(
            'Henter lokationer',
            style: kTextStyleP1.copyWith(color: primaryColor),
          ),
        ],
      ),
    );
  }

  Map<String, List<ClubData>> _groupClubsByType(List<ClubData> allClubs) {
    final Map<String, List<ClubData>> clubsByType = {};
    for (var club in allClubs) {
      clubsByType.putIfAbsent(club.typeOfClub, () => []).add(club);
    }
    return clubsByType;
  }

  List<MapEntry<String, List<ClubData>>> _sortClubTypes(
      Map<String, List<ClubData>> clubsByType) {
    return clubsByType.entries.toList()
      ..sort((a, b) => b.value.length.compareTo(a.value.length));
  }

  List<ClubData> _sortClubsByDistance(
      List<ClubData> clubs, LatLng userLocation) {
    clubs.sort((a, b) {
      final distanceA = Geolocator.distanceBetween(
        userLocation.latitude,
        userLocation.longitude,
        a.lat,
        a.lon,
      );
      final distanceB = Geolocator.distanceBetween(
        userLocation.latitude,
        userLocation.longitude,
        b.lat,
        b.lon,
      );
      return distanceA.compareTo(distanceB);
    });
    return clubs;
  }

  Widget _buildExpansionTileTitle(String type, List<ClubData> clubs) {
    return Row(
      children: [
        BarTypeMapToggle(
          clubType: type,
          onToggle: (isToggled) {},
          updateMarkers: () {
            nightMapKey.currentState?.updateMarkers(); //TODO NEED REWORK
          },
        ),
        CircleAvatar(
          backgroundImage:
              CachedNetworkImageProvider(clubs.first.typeOfClubImg),
          radius: kBigSizeRadius,
        ),
        const SizedBox(width: kSmallPadding),
        Text(
          ClubTypeFormatter.formatClubType(type),
          style: kTextStyleH4.copyWith(color: primaryColor),
        ),
        const Spacer(),
        Text(
          '(${clubs.length})',
          style: kTextStyleP3,
        ),
      ],
    );
  }

  List<Widget> _buildClubListTiles(

      List<ClubData> clubs, BuildContext context, LatLng userLocation) {
    return clubs.map((club) {
      final String clubOpeningHoursFormatted = ClubOpeningHoursFormatter.displayClubOpeningHoursFormatted(club);

      return ListTile(
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(club.logo),
          radius: kNormalSizeRadius,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                ClubNameFormatter.formatClubName(club.name),
                style: kTextStyleP1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              ClubAgeRestrictionFormatter
                  .displayClubAgeRestrictionFormattedOnlyAge(club),
              style: kTextStyleP2.copyWith(color: primaryColor),
            ),
            const SizedBox(width: kSmallPadding),
            Text(
              ClubDistanceCalculator.displayDistanceToClub(
                club: club,
                userLat: userLocation.latitude,
                userLon: userLocation.longitude,
              ),
              style: kTextStyleP2.copyWith(color: primaryColor),
            ),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                ClubNameFormatter.displayClubLocation(club),
                style: kTextStyleP3.copyWith(color: primaryColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
            clubOpeningHoursFormatted,
            style: clubOpeningHoursFormatted.toLowerCase() == "lukket i dag."
      ? kTextStyleP3.copyWith(color: redAccent)
          : kTextStyleP3,
      ),
          ],
        ),
        onTap: () {
          Navigator.pop(context);
          Provider.of<NightMapProvider>(context, listen: false)
              .nightMapController
              .move(LatLng(club.lat, club.lon), kCloseMapZoom);
          ClubBottomSheet.showClubSheet(context: context, club: club);
        },
      );
    }).toList();
  }
}
