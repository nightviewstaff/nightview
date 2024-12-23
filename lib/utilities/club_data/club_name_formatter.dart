import 'package:flutter/cupertino.dart';

import '../../models/clubs/club_data.dart';
import 'club_data_location_formatting.dart';
import 'club_distance_calculator.dart';

class ClubNameFormatter {
  // TODO rework so i have everything with its own method. then call them when needed.
  //TODO Display everything in here properly

  //TODO If same club say place (Irish pub frederiksberg)
  static String displayClubName(ClubData club) {
    return formatClubName(club.name);
  }

  // static Text displayClubNameText(ClubData club){
  // }

  //TODO big small location text
  static String displayClubLocation(ClubData club) {
    return ClubDataLocationFormatting.determineLocationFromCoordinates(
        club.lat, club.lon);
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


}
