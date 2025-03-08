// import 'package:flutter/foundation.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:nightview/models/clubs/club_data.dart';
// import 'package:nightview/utilities/club_data/club_data_location_formatting.dart';
// import 'package:nightview/utilities/club_data/club_distance_calculator.dart';
// import 'package:nightview/utilities/club_data/club_opening_hours_formatter.dart';
//
// class SearchService {
//   Future<List<ClubData>> performSearch(String query, List<ClubData> allClubs, LatLng userLocation) async {
//     return compute(_searchIsolate, SearchIsolateParams(query, allClubs, userLocation));
//   }
//
//   static List<ClubData> _searchIsolate(SearchIsolateParams params) {
//     final queryLower = params.query.toLowerCase().trim();
//     List<ClubData> openClubs = [];
//     List<ClubData> closedClubs = [];
//
//     if (queryLower.isEmpty) {
//       return ClubDistanceCalculator.sortClubsByDistance(
//         userLat: params.userLocation.latitude,
//         userLon: params.userLocation.longitude,
//         clubs: params.allClubs,
//       );
//     }
//
//     for (var club in params.allClubs) {
//       bool locationMatch = ClubDataLocationFormatting.danishCitiesAndAreas.entries.any((entry) {
//         return entry.value.any((altName) => altName.toLowerCase().contains(queryLower));
//       });
//
//       bool nameMatch = club.name.toLowerCase().contains(queryLower);
//       bool typeMatch = club.typeOfClub.toLowerCase().contains(queryLower);
//       bool ageMatch = club.ageRestriction.toString().contains(queryLower);
//
//       bool isMatch = locationMatch || nameMatch || typeMatch || ageMatch;
//       bool isOpen = ClubOpeningHoursFormatter.isClubOpen(club);
//
//       if (isMatch) {
//         (isOpen ? openClubs : closedClubs).add(club);
//       }
//     }
//
//     List<ClubData> sortedClubs = [...openClubs, ...closedClubs]
//       ..sort((a, b) {
//         double distanceA = ClubDistanceCalculator.calculateDistance(
//           lat1: params.userLocation.latitude,
//           lon1: params.userLocation.longitude,
//           lat2: a.lat,
//           lon2: a.lon,
//         );
//         double distanceB = ClubDistanceCalculator.calculateDistance(
//           lat1: params.userLocation.latitude,
//           lon1: params.userLocation.longitude,
//           lat2: b.lat,
//           lon2: b.lon,
//         );
//         return distanceA.compareTo(distanceB);
//       });
//
//     return sortedClubs;
//   }
// }
//
// class SearchIsolateParams {
//   final String query;
//   final List<ClubData> allClubs;
//   final LatLng userLocation;
//
//   SearchIsolateParams(this.query, this.allClubs, this.userLocation);
// }
