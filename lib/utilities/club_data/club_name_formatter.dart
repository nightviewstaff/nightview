
import '../../models/clubs/club_data.dart';
import 'club_data_location_formatting.dart';

class ClubNameFormatter {
  // TODO rework so i have everything with its own method. then call them when needed.
  //TODO Display everything in here properly

  //TODO If same club say place (Irish pub frederiksberg)
  static String displayClubName(ClubData club) {
    return formatClubName(club.name);
  }

  static String displayClubNameShort(ClubData club, int maxLength) {
    return formatClubNameShort(club.name, maxLength);
  }

  static String displayClubNameClubHeader(ClubData club) {
    return formatClubName(club.name);
  }


  // static Text displayClubNameText(ClubData club){
  // }

  //TODO big small location text
  static String displayClubLocation(ClubData club) { // ERROR handeling? todo
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

  static String formatClubNameShort(String clubName, int maxLength) {
    String formattedName = formatClubName(clubName);

    // If the name fits within the maximum length, return as is.
    if (formattedName.length <= maxLength) {
      return formattedName;
    }

    // Truncate and append "..." if the name exceeds the maximum length.
    return '${formattedName.substring(0, maxLength - 3)}...';
  }


}
