import '../../models/clubs/club_data.dart';
import 'club_data_location_formatting.dart';
import 'club_distance_calculator.dart';

class ClubNameFormatter {
  // TODO rework so i have everything with its own method. then call them when needed.
  //TODO Display everything in here properly

  //TODO If same club say place (Irish pub frederiksberg)
  static String displayClubName(ClubData club){
    return formatClubName(club.name);
  }

  //TODO big small location text
  static String displayClubLocation(ClubData club){
    return ClubDataLocationFormatting.determineLocationFromCoordinates(club.lat, club.lon);
  }

  static String displayDistanceToClub({
    required double userLat,
    required double userLon,
    required ClubData club,
  }) {
    return _formatDistance(
      ClubDistanceCalculator.calculateDistance(
        lat1: userLat,
        lon1: userLon,
        lat2: club.lat,
        lon2: club.lon,
      ),
    );
  }


  static String displayClubNameWithLocationAndDistance({
    required ClubData club,
    required double userLat,
    required double userLon,
  }) {
    String formattedName = formatClubName(club.name);
    String location =
        ClubDataLocationFormatting.determineLocationFromCoordinates(
            club.lat, club.lon);
    double distance = ClubDistanceCalculator.calculateDistance(
      lat1: userLat,
      lon1: userLon,
      lat2: club.lat,
      lon2: club.lon,
    );

    // Convert distance to meters if it's less than 1 km
    String distanceText = distance < 1
        ? "${(distance * 1000).toStringAsFixed(0)} m"
        : "${distance.toStringAsFixed(1)} km";

    return "$formattedName ($distanceText)\n($location)"; // TODO Want distanceText pushed right
  }

  static String displayClubNameFormatted(ClubData club) {
    // Redundant to have a method that returns another method?
    return formatClubName(club.name);
  }

  static String formatClubName(String clubName) {
    // Return as-is if the name is already all caps or contains only numbers.
    if (RegExp(r'^[A-Z0-9]+$').hasMatch(clubName)) {
      return clubName;
    }
    return clubName
        .split(' ') // Split the name by spaces into a list of words
        .map((word) => word.isNotEmpty
            ? word[0].toUpperCase() +
                word.substring(1).toLowerCase() // Capitalize first letter
            : '') // Handle empty words (if any)
        .join(' '); // Join the words back with spaces

    //TODO Make exceptions for specific names like 'BAR', 'KB3' and so on.
  }

  static String _formatDistance(double distance) {
    //TODO redund
    return distance < 1
        ? "${(distance * 1000).toStringAsFixed(0)} m"
        : "${distance.toStringAsFixed(1)} km";
  }
}
