import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:nightview/providers/night_map_provider.dart';
import 'package:nightview/utilities/club_data/club_data_location_formatting.dart';
import 'package:nightview/utilities/club_data/club_distance_calculator.dart';
import 'package:nightview/utilities/club_data/club_opening_hours_formatter.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';

class CustomSearchBar extends StatelessWidget {
  final LatLng userLocation;
  final ValueNotifier<List<ClubData>> clubDataListNotifier;
  final ValueNotifier<Set<String>> clubTypesNotifier;

  const CustomSearchBar({
    Key? key,
    required this.userLocation,
    required this.clubDataListNotifier,
    required this.clubTypesNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<ClubData>>(
      valueListenable: clubDataListNotifier,
      builder: (context, allClubs, _) {
        return ValueListenableBuilder<Set<String>>(
          valueListenable: clubTypesNotifier,
          builder: (context, typeOfClub, _) {
            return SearchAnchor(
              viewBackgroundColor: secondaryColor,
              viewElevation: 2,
              builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  keyboardType: TextInputType.text,
                  controller: controller,
                  leading: Icon(Icons.search_sharp, color: primaryColor),
                  hintText: "Søg efter lokationer, områder eller andet",
                  hintStyle: MaterialStateProperty.all(kTextStyleP2),
                  backgroundColor: MaterialStateProperty.all(grey.shade800),
                  shadowColor: MaterialStateProperty.all(secondaryColor),
                  elevation: MaterialStateProperty.all(4),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                );
              },
              suggestionsBuilder: (BuildContext context, SearchController controller) {
                final String userInputLowerCase = controller.text.toLowerCase().trim();

                if (userInputLowerCase.isEmpty) {
                  final sortedByDistance = ClubDistanceCalculator.sortClubsByDistance(
                    userLat: userLocation.latitude,
                    userLon: userLocation.longitude,
                    clubs: allClubs,
                  );
                  return _buildSuggestions(sortedByDistance, context);
                }

                List<ClubData> openClubs = [];
                List<ClubData> closedClubs = [];

                for (var club in allClubs) {
                  bool locationMatch = ClubDataLocationFormatting.danishCitiesAndAreas.entries
                      .any((entry) => entry.value.any((altName) => altName.toLowerCase().contains(userInputLowerCase)));
                  bool clubNameMatch = club.name.toLowerCase().contains(userInputLowerCase);
                  bool clubTypeMatch = club.typeOfClub.toLowerCase().contains(userInputLowerCase);
                  bool ageRestrictionMatch = RegExp(r'^\d+\+$').hasMatch(userInputLowerCase)
                      ? club.ageRestriction.toString() == userInputLowerCase.replaceAll("+", "").trim()
                      : club.ageRestriction.toString().contains(userInputLowerCase);

                  bool isMatch = locationMatch || clubNameMatch || clubTypeMatch || ageRestrictionMatch;
                  bool isOpen = ClubOpeningHoursFormatter.isClubOpen(club);

                  if (isMatch) {
                    if (isOpen) {
                      openClubs.add(club);
                    } else {
                      closedClubs.add(club);
                    }
                  }
                }

                final sortedClubs = [
                  ...openClubs,
                  ...closedClubs,
                ]..sort((a, b) {
                  final distanceA = ClubDistanceCalculator.calculateDistance(
                    lat1: userLocation.latitude,
                    lon1: userLocation.longitude,
                    lat2: a.lat,
                    lon2: a.lon,
                  );
                  final distanceB = ClubDistanceCalculator.calculateDistance(
                    lat1: userLocation.latitude,
                    lon1: userLocation.longitude,
                    lat2: b.lat,
                    lon2: b.lon,
                  );
                  return distanceA.compareTo(distanceB);
                });

                if (sortedClubs.isEmpty) {
                  return _noResultsFound();
                }

                return _buildSuggestions(sortedClubs, context);
              },
            );
          },
        );
      },
    );
  }

  List<Widget> _buildSuggestions(List<ClubData> clubs, BuildContext context) {
    return clubs.map((club) {
      return ListTile(
        title: Text(club.name, style: kTextStyleP1),
        subtitle: Text(ClubDistanceCalculator.displayDistanceToClub(
          userLat: userLocation.latitude,
          userLon: userLocation.longitude,
          club: club,
        )),
        trailing: Text(ClubOpeningHoursFormatter.displayClubOpeningHoursFormatted(club)),
        onTap: () {
          Provider.of<NightMapProvider>(context, listen: false)
              .nightMapController
              .move(LatLng(club.lat, club.lon), kCloseMapZoom);
        },
      );
    }).toList();
  }

  List<Widget> _noResultsFound() {
    return [
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 50, color: Colors.grey),
            const SizedBox(height: 10),
            Text("Ingen resultater fundet", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(
              "Du kan søge efter navn, lokation, type, aldersgrænse, åbningstider og distance",
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ];
  }
}
