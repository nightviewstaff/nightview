import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/icons.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/locations/location_service.dart';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/screens/night_map/night_map.dart';
import 'package:nightview/utilities/club_data/club_age_restriction_formatter.dart';
import 'package:nightview/utilities/club_data/club_distance_calculator.dart';
import 'package:nightview/utilities/club_data/club_opening_hours_formatter.dart';
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
  final GlobalKey<NightMapState> nightMapKey =
      GlobalKey<NightMapState>(); // Prop needs refac
  // Map<String, bool> toggledClubTypeStates = {};

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

  //TODO Remove searchfield when pressed another place.
  //TODO Search for place.
  List<SearchFieldListItem> getSearchSuggestions(
      LatLng userLocation, String query) {
    final clubDataHelper =
        Provider.of<GlobalProvider>(context, listen: false).clubDataHelper;

    print('QUERY: $query');
    final sortedClubsByQuery = clubDataHelper.clubData.values.where((clubData) {
      final clubName =
          ClubNameFormatter.displayClubName(clubData).toLowerCase();
      final clubLocation =
          ClubNameFormatter.displayClubLocation(clubData).toLowerCase();
      final searchQuery = query.toLowerCase();

      return clubName.contains(searchQuery) ||
          clubLocation.contains(searchQuery);
    }).toList();

    sortedClubsByQuery.sort((a, b) {
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
      return distanceA.compareTo(distanceB); // Closest clubs first
    });

    return sortedClubsByQuery.map((clubData) {
      final formattedClubName = ClubNameFormatter.displayClubName(clubData);
      final formattedClubNameShort = ClubNameFormatter.displayClubNameShort(clubData, 20);
      final formattedClubLocation =
          ClubNameFormatter.displayClubLocation(clubData);
      final hasCustomLogo = clubData.logo != clubData.typeOfClubImg;
      final formattedDistance = ClubDistanceCalculator.displayDistanceToClub(
        userLat: userLocation.latitude,
        userLon: userLocation.longitude,
        club: clubData,
      );

      return SearchFieldListItem<ClubData>(
        formattedClubName,
        item: clubData,
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(clubData.logo),
            radius: kBigSizeRadius,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formattedClubNameShort,
                style: kTextStyleP3,
              ),
              const SizedBox(height: 2.0), // Spacing between name and location
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      formattedClubLocation,
                      style: kTextStyleP3.copyWith(color: primaryColor),
                      overflow:
                          TextOverflow.ellipsis, // Handle long text gracefully
                    ),
                  ),
                  Text(
                    formattedDistance,
                    style: kTextStyleP3.copyWith(color: primaryColor),
                  ),
                ],
              )
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              hasCustomLogo
                  ? CircleAvatar(
                      backgroundImage:
                          CachedNetworkImageProvider(clubData.typeOfClubImg),
                      radius: 15.0,
                    )
                  : const SizedBox(
                      width: 30, // Same width and height as CircleAvatar
                      height: 30,
                    ),
            ],
          ),
        ),
      );
    }).toList();
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
        future:
        LocationService.getUserLocation(),
        // Needed in order to call showalltypesbar + seach. Prop needs refac
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text('N/A'));
          }

          final userLocation = snapshot.data!;

          return Column(
            children:
                //toggledStates.keys.map((clubTypeKey))
                [
              Padding(
                padding: const EdgeInsets.all(kMainPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Brugere i byen nu',
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
                              radius: kNormalSizeRadius,
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
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    searchController.clear();
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: SearchField(
                          controller: searchController,
                          itemHeight: 60.0,
                          suggestions: getSearchSuggestions(
                              userLocation, searchController.text),
                          searchInputDecoration: SearchInputDecoration(
                            hintText: ' Søg efter steder eller områder',
                            // TODO Color cursorColor: primaryColor
                            searchStyle: kTextStyleP1,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 10.0),
                            // Left!
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: kMainStrokeWidth,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(kNormalSizeRadius),
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
                                .move(LatLng(value.item.lat, value.item.lon),
                                    kCloseMapZoom);
                            // ClubBottomSheet.showClubSheet(
                            //     context: context, club: value.item);
                          },
                        ),
                      ),
                      const SizedBox(
                        width: kNormalSpacerValue,
                      ),
                      GestureDetector(
                        onTap: () {
                          showAllTypesOfBars(context,
                              userLocation); // Trigger the bottom sheet
                        },
                        child: const FaIcon(
                          //   Delete this?!
                          defaultDownArrow,
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
              ),
              Expanded(
                child: GestureDetector(
                  // Maybe close everyhting else when clicking map?
                  behavior: HitTestBehavior.translucent,
                  // Detect taps on the map
                  onTap: () {
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

// Sort club types by the number of clubs (most first)
    final sortedClubTypes = clubsByType.entries.toList()
      ..sort((a, b) => b.value.length.compareTo(a.value.length));

    showModalBottomSheet(
      context: context,
      backgroundColor: black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        // TODO Make CustomCircularIndicator class to use everywhere
        return ListView(
          children: sortedClubTypes.map((entry) {
            // Center logic for reusability
            final type = entry.key;
            final clubs = entry.value;

            clubs.sort((a, b)
            {
              // Make reuseable method. Used more places
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


              // Show all at the top with toggle. TODO
              title: Row(
                children: [
                  BarTypeMapToggle(
                    // Diff actions when long press etc.
                    clubType: type,
                    onToggle: (isToggled) {
                      // String formattedClubType = ClubTypeFormatter
                      //     .formatClubType(type);
                      // String formattedToggle = isToggled ? "slået til" : "slået fra";
                      // CustomModalMessage.showCustomBottomSheetOneSecond( //TODO rewamp - popup
                      //   context: context,
                      //   message: "$formattedClubType er $formattedToggle på kortet.",
                      //   textStyle: kTextStyleP1,
                      //   autoDismissDuration: Duration(milliseconds: 800),
                      // );
                    },
                    updateMarkers: () {
                      nightMapKey.currentState?.updateMarkers();
                    },

                  ),
                  // built in padding from BTMT.
                  CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider(clubs.first.typeOfClubImg),
                    radius: kBigSizeRadius,
                  ),
                  const SizedBox(width: kSmallPadding),
                  Text(
                    ClubTypeFormatter.formatClubType(type),
                    style: kTextStyleH4.copyWith(color: primaryColor),
                    // overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Text(
                    '(${clubs.length})', // Display the count
                    style: kTextStyleP3,
                  ),
                ],
              ),
              children: clubs.map((club) {
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
                          overflow:
                              TextOverflow.ellipsis, // Prevents text overflow
                        ),
                      ),
                      Text(
                        ClubAgeRestrictionFormatter
                            .displayClubAgeRestrictionFormattedOnlyAge(club),
                        style: kTextStyleP2.copyWith(color: primaryColor), // A
                      ),
                      const SizedBox(width: kSmallPadding),
                      Text(
                        ClubDistanceCalculator.displayDistanceToClub(
                          club: club,
                          userLat: userLocation.latitude,
                          userLon: userLocation.longitude,
                        ),
                        style: kTextStyleP2.copyWith(
                            color: primaryColor), // Adjust style
                      ),
                    ],
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // Push content to edges
                    children: [
                      Expanded(
                        child: Text(
                          ClubNameFormatter.displayClubLocation(club),
                          style: kTextStyleP3.copyWith(color: primaryColor),
                          overflow: TextOverflow
                              .ellipsis, // Handle long text gracefully
                        ),
                      ),
                      Text(
                        ClubOpeningHoursFormatter
                            .displayClubOpeningHoursFormatted(club),
                        style: kTextStyleP3, // Adjust style as needed
                      ),
                    ],
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
