import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/screens/night_map/night_map.dart';
import 'package:nightview/utilities/club_data/club_type_formatter.dart';
import 'package:nightview/widgets/icons/bar_type_toggle.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utilities/club_data/club_name_formatter.dart';

class NightMapMainScreen extends StatefulWidget {
  static const id = 'night_map_main_screen';

  const NightMapMainScreen({super.key});

  @override
  State<NightMapMainScreen> createState() => _NightMapMainScreenState();
}

class _NightMapMainScreenState extends State<NightMapMainScreen> {
  final searchController = TextEditingController();

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

  Future<LatLng?> getUserLocation() async {
    //TODO Move so can acess from anywhere
    // Move
    try {
      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever ||
            permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      // Get the user's current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Convert Position to LatLng
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      return null; // Return null if there's an error
    }
  }

  List<SearchFieldListItem> getSearchSuggestions() {
    List<SearchFieldListItem> suggestions = [];

    Provider.of<GlobalProvider>(context)
        .clubDataHelper
        .clubData
        .forEach((id, clubData) {
      suggestions.add(
        SearchFieldListItem<ClubData>(
          "${ClubNameFormatter.formatClubName(clubData.name)}\n"
          "${ClubNameFormatter.displayClubLocation(clubData)}",
          item: clubData,
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(clubData.logo),
              radius: 25.0,
            ),
            title: Text(
              "${ClubNameFormatter.formatClubName(clubData.name)}\n"
              "${ClubNameFormatter.displayClubLocation(clubData)}",
              // What is the diff with these 2 diplays
              style: kTextStyleP3,
            ), // TODO If logo = default dont show CA below.
            trailing: clubData.logo != clubData.typeOfClubImg
                ? CircleAvatar(
                    backgroundImage: NetworkImage(clubData.typeOfClubImg),
                    radius: 15.0, // Specific size TBD.
                  )
                : null, // Hide the trailing CircleAvatar if logo equals typeOfClubImg
          ),
        ),
      );
    });

    return suggestions;
  }

  /// REPLACE ABOVE WITH:
  /// List<SearchFieldListItem> getSearchSuggestions() {
  //   final clubDataHelper = Provider.of<GlobalProvider>(context).clubDataHelper;
  //
  //   return clubDataHelper.clubData.values.map((clubData) {
  //     final formattedName = ClubNameFormatter.displayClubNameFormattedWithLocation(clubData);
  //     final hasCustomLogo = clubData.logo != clubData.typeOfClubImg;
  //
  //     return SearchFieldListItem<ClubData>(
  //       formattedName,
  //       item: clubData,
  //       child: ListTile(
  //         leading: CircleAvatar(
  //           backgroundImage: NetworkImage(clubData.logo),
  //           radius: 25.0,
  //         ),
  //         title: Text(
  //           formattedName,
  //           style: kTextStyleP3,
  //         ),
  //         trailing: hasCustomLogo
  //             ? CircleAvatar(
  //                 backgroundImage: NetworkImage(clubData.typeOfClubImg),
  //                 radius: 15.0,
  //               )
  //             : null,
  //       ),
  //     );
  //   }).toList();
  // }

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
    return FutureBuilder<LatLng?>(
        future: getUserLocation(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text('Failed to fetch location'));
          }

          final userLocation = snapshot.data!;

          return Column(
            children:
                // toggledStates.keys.map((clubTypeKey))
                [
              Padding(
                padding: const EdgeInsets.all(kMainPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Brugere i byen',
                      style: kTextStyleH3,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 40.00,
                          // width: getwidth(), Ugly if partyCount < 10
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            border: Border.all(
                              color: white,
                              width: kMainStrokeWidth,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: kMainPadding),
                            child: Center(
                              // Center the text vertically
                              child: Text(
                                Provider.of<GlobalProvider>(context)
                                    .partyCount
                                    .toString(),
                                style:
                                    kTextStyleH3.copyWith(color: primaryColor),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: kNormalSpacerValue,
                        ),
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
                            return CircularPercentIndicator(
                              radius: 20.0,
                              lineWidth: 3.0,
                              // Adjusted to be smaller
                              percent: getDecimalValue(
                                amount: Provider.of<GlobalProvider>(context)
                                    .partyCount,
                                fullAmount: userCount,
                              ),
                              center: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: (getDecimalValue(
                                                  amount: Provider.of<
                                                              GlobalProvider>(
                                                          context)
                                                      .partyCount,
                                                  fullAmount: userCount) *
                                              100)
                                          .toStringAsFixed(0),
                                      style: kTextStyleH3.copyWith(
                                          color: primaryColor,
                                          fontSize: 15.0), // Adjusted font size
                                    ),
                                    TextSpan(
                                      text: '%',
                                      style: kTextStyleH3.copyWith(
                                          fontSize: 15.0), // Adjusted font size
                                    ),
                                  ],
                                ),
                              ),
                              progressColor: secondaryColor,
                              backgroundColor: Colors.white,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(kMainPadding),
                child: Row(
                  children: [
                    Expanded(
                      child: SearchField(
                        controller: searchController,
                        itemHeight: 60.0,
                        suggestions: getSearchSuggestions(),
                        searchInputDecoration: SearchInputDecoration(
                          hintText: 'Søg efter steder'
                          // ', områder eller typer'
                          ,
                          searchStyle: kTextStyleH3ToP1,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 10.0),
                          // Left!
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: kMainStrokeWidth,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                          ),
                          // TODO NEED PADDING BETWEEN TEXT AND ICON
                          prefixIcon: const Icon(
                            FontAwesomeIcons.magnifyingGlass,
                            color: primaryColor,
                            size: 20.0,
                          ),
                        ),
                        onSuggestionTap: (value) {
                          FocusManager.instance.primaryFocus?.unfocus();
                          searchController.clear();

                          Provider.of<GlobalProvider>(context, listen: false)
                              .nightMapController
                              .move(
                                  LatLng(value.item.lat, value.item.lon),
                                  // TODO BUG. Move to person
                                  kCloseMapZoom);

                          // TODO  NightMap.showClubSheet(context: context, club: value.item);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: kNormalSpacerValue,
                    ),
                    GestureDetector(
                      onTap: () {
                        showAllTypesOfBars(
                            context, userLocation); // Trigger the bottom sheet
                      },
                      child: const FaIcon(
                        //   Delete this?!
                        FontAwesomeIcons.chevronDown,
                        color: primaryColor,
                        size: 20.0,
                      ),
                    ),
                    const SizedBox(
                      width: kSmallSpacerValue,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: NightMap(),
              ),
            ],
          );
        });
  }

  void showAllTypesOfBars(BuildContext context, LatLng userLocation) {
    // TODO Always sort after closest.
    // todo Class of it own
    // Fetch all clubs and their types
    final clubDataHelper =
        Provider.of<GlobalProvider>(context, listen: false).clubDataHelper;
    final allClubs = clubDataHelper.clubData.values.toList(); // Fetch all clubs
    final Map<String, List<ClubData>> clubsByType = {};

    // Group clubs by their type
    for (var club in allClubs) {
      clubsByType.putIfAbsent(club.typeOfClub, () => []).add(club);
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        // TODO Make CustomCircularIndicator class to use everywhere
        return ListView(
          children: clubsByType.entries.map((entry) {
            final type = entry.key;
            final clubs = entry.value;

            clubs.sort((a, b) {
              final double distanceA = Geolocator.distanceBetween(
                userLocation.latitude,
                userLocation.longitude,
                a.lat,
                a.lon,
              );
              final double distanceB = Geolocator.distanceBetween(
                userLocation.latitude,
                userLocation.longitude,
                b.lat,
                b.lon,
              );
              return distanceA.compareTo(distanceB);
            });


            return ExpansionTile(
              // Show an image of typeOfClubImg before the text
              title: Row(
                children: [
                  // BarTypeToggle(
                  //   onToggle: (isToggled) {
                  //     if (isToggled) {
                  //       TODO
                  // } else {
                  //   TODO
                  // }
                  // },
                  // ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(clubs.first.typeOfClubImg),
                    radius: 25.0,
                  ),
                  const SizedBox(width: 10.0), // Space between image and text
                  Text(
                    ClubTypeFormatter.formatClubType(type),
                    style: kTextStyleH3.copyWith(color: primaryColor),
                  ),
                ],
              ),
              children: clubs.map((club) {
                return ListTile(
                  //TODO Sort list by distance
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(club.logo),
                    radius: 20.0,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          ClubNameFormatter.formatClubName(club.name),
                          style: kTextStyleH3,
                          overflow:
                              TextOverflow.ellipsis, // Prevents text overflow
                        ),
                      ),
                      Text(
                        ClubNameFormatter.displayDistanceToClub(
                          club: club,
                          userLat: userLocation.latitude,
                          userLon: userLocation.longitude,
                        ),
                        style: kTextStyleP2.copyWith(
                            color: primaryColor), // Adjust style
                      ),
                    ],
                  ),
                  subtitle: Text(
                    ClubNameFormatter.displayClubLocation(club),
                    style: kTextStyleP3,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Provider.of<GlobalProvider>(context, listen: false)
                        .nightMapController
                        .move(LatLng(club.lat, club.lon), kCloseMapZoom);
                  },
                );
              }).toList(),
            );
          }).toList(),
        );
      },
    );
  }
}
