import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/icons.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/helpers/clubs/club_data_helper.dart';
import 'package:nightview/locations/location_service.dart';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/providers/night_map_provider.dart';
import 'package:nightview/screens/night_map/night_map.dart';
import 'package:nightview/screens/night_map/utility/custom_search_bar.dart';
import 'package:nightview/utilities/club_data/club_age_restriction_formatter.dart';
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
                                  backgroundColor: Colors.white,
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
                padding: const EdgeInsets.all(kMainPadding),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent, // ??? TODO
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: Row(
                    children: [

                      Expanded(
                        child: CustomSearchBar(
                          // position:
                          onClubSelected: (position) {
                            nightMapKey.currentState?.moveToPosition(position);
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

              // The actual map
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
          CircularProgressIndicator(color: primaryColor),
          const SizedBox(height: 16),
          Text(
            'Henter alle klubber',
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

  List<ClubData> _sortClubsByDistance(List<ClubData> clubs, LatLng userLocation) {
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
              ClubOpeningHoursFormatter.displayClubOpeningHoursFormatted(club),
              style: kTextStyleP3,
            ),
          ],
        ),
        onTap: () {
          Navigator.pop(context);
          Provider.of<NightMapProvider>(context, listen: false)
              .nightMapController
              .move(LatLng(club.lat, club.lon), kCloseMapZoom);
        },
      );
    }).toList();
  }

}
