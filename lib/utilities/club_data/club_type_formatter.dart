import '../../models/clubs/club_data.dart';

class ClubTypeFormatter {

  static String displayClubTypeFormatted(ClubData club) {
    return formatClubType(club.typeOfClub);
  }

  static String formatClubType(String typeOfClub) {
    final clubTypesMap = clubTypes[typeOfClub] ??
        typeOfClub; // Default to original if not found.
    return clubTypesMap.substring(0, 1).toUpperCase() + clubTypesMap.substring(1);
  }

  static final Map<String, String> clubTypes = {
    'bar': 'Bar',
    'bar_club': 'Bar/Klub',
    'beer_bar': 'Ølbar',
    'bodega': 'Bodega',
    'club': 'Klub',
    'cocktail_bar': 'Cocktailbar',
    'gay_bar': 'Gaybar',
    'jazz_bar': 'Jazzbar',
    'karaoke_bar': 'Karaokebar',
    'live_music_bar': 'Livemusikbar',
    'pub': 'Pub',
    'sports_bar': 'Sportsbar',
    'wine_bar': 'Vinbar',
  };


}
