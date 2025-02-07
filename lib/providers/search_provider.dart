import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nightview/helpers/clubs/club_data_helper.dart';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:latlong2/latlong.dart';

class SearchProvider extends ChangeNotifier {
  final ClubDataHelper clubDataHelper = ClubDataHelper();

  List<ClubData> _allClubs = []; // needs to be filled when clubs load. They load in correct order, this just needs to be iterated when clubs load.
  List<ClubData> _filteredClubs = [];

  bool showOnlyOpen = false;
  bool sortByDistance = true;
  bool showFavoritesOnly = false;
  int minRating = 0;

  List<ClubData> get filteredClubs => _filteredClubs;

  void setClubs(List<ClubData> clubs) {
    _allClubs = clubs;
    _filteredClubs = clubs;
    notifyListeners();
  }

  void updateSearch(String query, LatLng? userLocation) {
    final now = DateTime.now();

    _filteredClubs = _allClubs.where((club) {
      // Unified search matching
      final searchMatch = _matchesSearchQuery(club, query);
      final locationMatch = _matchesLocation(club, userLocation);
      return searchMatch && locationMatch;
    }).toList();

    _sortClubs(userLocation);
    notifyListeners();
  }

  bool _matchesSearchQuery(ClubData club, String query) {
    if (query.isEmpty) return true;

    final searchTerms = [
      club.name,
      club.typeOfClub,
      club.ageRestriction.toString(),
      club.rating.toStringAsFixed(1),
      club.totalPossibleAmountOfVisitors.toString(),
    ];

    return searchTerms.any((term) => term.toLowerCase().contains(query.toLowerCase()));
  }

  bool _matchesLocation(ClubData club, LatLng? userLocation) {
    if (userLocation == null || !sortByDistance) return true;

    final distance = Geolocator.distanceBetween(
      userLocation.latitude,
      userLocation.longitude,
      club.lat,
      club.lon,
    );

    return distance <= 10000; // 10km
  }

  void _sortClubs(LatLng? userLocation) {
    if (userLocation == null) return;

    _filteredClubs.sort((a, b) {
      if (sortByDistance) {
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
      }
      return a.name.compareTo(b.name);
    });
  }

  List<ClubData> filterClubs(String query, LatLng? userLocation) {
    final now = DateTime.now();

    // Filter clubs based on all criteria
    List<ClubData> filtered = _allClubs.where((club) {
      final matchesQuery = _matchesSearchQuery(club, query);
      final withinDistance = _matchesLocation(club, userLocation);
      // final isOpen = !showOnlyOpen || club.isOpenNow(now); // Ensure `isOpenNow()` is implemented
      final isFavorite = !showFavoritesOnly || club.favorites.isNotEmpty;
      final matchesRating = club.rating >= minRating;

      return matchesQuery && withinDistance && isFavorite && matchesRating;
      // isOpen &&
    }).toList();

    // Sort results by distance if enabled
    if (sortByDistance && userLocation != null) {
      filtered.sort((a, b) {
        final distanceA = Geolocator.distanceBetween(userLocation.latitude, userLocation.longitude, a.lat, a.lon);
        final distanceB = Geolocator.distanceBetween(userLocation.latitude, userLocation.longitude, b.lat, b.lon);
        return distanceA.compareTo(distanceB);
      });
    }

    return filtered;
  }


  // void updateSearch(String query, LatLng userLocation) {
  //   _filteredClubs = _allClubs.where((club) {
  //     final matchesQuery = club.name.toLowerCase().contains(query.toLowerCase()) ||
  //         club.typeOfClub.toLowerCase().contains(query.toLowerCase()) ||
  //         club.ageRestriction.toString().contains(query) ||
  //         club.rating.toString().contains(query) ||
  //         club.totalPossibleAmountOfVisitors.toString().contains(query);
  //
  //     final withinDistance = !sortByDistance || Geolocator.distanceBetween(
  //         userLocation.latitude, userLocation.longitude, club.lat, club.lon) / 1000 <= 10.0; // 10 km limit
  //
  //     final isOpen = !showOnlyOpen || club.isOpenNow(); //Todo
  // final isFavorite = !showFavoritesOnly || club.favorites.isNotEmpty;
  // final matchesRating = club.rating >= minRating;
  //
  // return matchesQuery && withinDistance;
  // &&
  // isOpen && isFavorite && matchesRating;
  // }).toList();

  // if (sortByDistance) {
  //   _filteredClubs.sort((a, b) {
  //     double distanceA = Geolocator.distanceBetween(
  //         userLocation.latitude, userLocation.longitude, a.lat, a.lon);
  //     double distanceB = Geolocator.distanceBetween(
  //         userLocation.latitude, userLocation.longitude, b.lat, b.lon);
  //     return distanceA.compareTo(distanceB);
  //   });
  // }
  //
  // notifyListeners();
  // }

  void toggleShowOnlyOpen() {
    showOnlyOpen = !showOnlyOpen;
    notifyListeners();
  }

  void toggleSortByDistance() {
    sortByDistance = !sortByDistance;
    notifyListeners();
  }

  void toggleShowFavoritesOnly() {
    showFavoritesOnly = !showFavoritesOnly;
    notifyListeners();
  }

  void setMinRating(int rating) {
    minRating = rating;
    notifyListeners();
  }
}

