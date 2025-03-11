import '../../models/clubs/club_data.dart';
import 'package:intl/intl.dart';

// Define top-level functions for each translation.
String clubTypeBar() =>
    Intl.message('Bar', name: 'clubTypeBar', desc: 'Club type: Bar');
String clubTypeBarClub() => Intl.message('Bar/Klub',
    name: 'clubTypeBarClub', desc: 'Club type: Bar/Klub');
String clubTypeBeerBar() =>
    Intl.message('Ølbar', name: 'clubTypeBeerBar', desc: 'Club type: Beer bar');
String clubTypeBodega() =>
    Intl.message('Bodega', name: 'clubTypeBodega', desc: 'Club type: Bodega');
String clubTypeClub() =>
    Intl.message('Klub', name: 'clubTypeClub', desc: 'Club type: Club');
String clubTypeCocktailBar() => Intl.message('Cocktailbar',
    name: 'clubTypeCocktailBar', desc: 'Club type: Cocktail bar');
String clubTypeGayBar() =>
    Intl.message('Gaybar', name: 'clubTypeGayBar', desc: 'Club type: Gay bar');
String clubTypeJazzBar() => Intl.message('Jazzbar',
    name: 'clubTypeJazzBar', desc: 'Club type: Jazz bar');
String clubTypeKaraokeBar() => Intl.message('Karaokebar',
    name: 'clubTypeKaraokeBar', desc: 'Club type: Karaoke bar');
String clubTypeLiveMusicBar() => Intl.message('Livemusikbar',
    name: 'clubTypeLiveMusicBar', desc: 'Club type: Live music bar');
String clubTypePub() =>
    Intl.message('Pub', name: 'clubTypePub', desc: 'Club type: Pub');
String clubTypeSportsBar() => Intl.message('Sportsbar',
    name: 'clubTypeSportsBar', desc: 'Club type: Sports bar');
String clubTypeWineBar() => Intl.message('Vinbar',
    name: 'clubTypeWineBar', desc: 'Club type: Wine bar');

class ClubTypeFormatter {
  static String displayClubTypeFormatted(ClubData club) {
    return formatClubType(club.typeOfClub);
  }

  static String formatClubType(String typeOfClub) {
    final translator = clubTypes[typeOfClub];
    final translated = translator != null ? translator() : typeOfClub;
    return translated.substring(0, 1).toUpperCase() + translated.substring(1);
  }

  static final Map<String, String Function()> clubTypes = {
    'bar': clubTypeBar,
    'bar_club': clubTypeBarClub,
    'beer_bar': clubTypeBeerBar,
    'bodega': clubTypeBodega,
    'club': clubTypeClub,
    'cocktail_bar': clubTypeCocktailBar,
    'gay_bar': clubTypeGayBar,
    'jazz_bar': clubTypeJazzBar,
    'karaoke_bar': clubTypeKaraokeBar,
    'live_music_bar': clubTypeLiveMusicBar,
    'pub': clubTypePub,
    'sports_bar': clubTypeSportsBar,
    'wine_bar': clubTypeWineBar,
  };
}
