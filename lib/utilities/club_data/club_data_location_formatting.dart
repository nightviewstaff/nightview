class ClubDataLocationFormatting {
  static String determineLocationFromCoordinates(double lat, double lon) {
    if (_isInCopenhagen(lat, lon)) {
      return "København";
    } else if (_isInAarhus(lat, lon)) {
      return "Aarhus";
    } else if (_isInOdense(lat, lon)) {
      return "Odense";
    } else if (_isInAalborg(lat, lon)) {
      return "Aalborg";
    } else if (_isInFrederiksberg(lat, lon)) {
      return "Frederiksberg";
    } else if (_isInEsbjerg(lat, lon)) {
      return "Esbjerg";
    } else if (_isInRanders(lat, lon)) {
      return "Randers";
    } else if (_isInKolding(lat, lon)) {
      return "Kolding";
    } else if (_isInVejle(lat, lon)) {
      return "Vejle";
    } else if (_isInHorsens(lat, lon)) {
      return "Horsens";
    } else if (_isInHerning(lat, lon)) {
      return "Herning";
    } else if (_isInRoskilde(lat, lon)) {
      return "Roskilde";
    } else if (_isInSilkeborg(lat, lon)) {
      return "Silkeborg";
    } else if (_isInNaestved(lat, lon)) {
      return "Næstved";
    } else if (_isInFredericia(lat, lon)) {
      return "Fredericia";
    } else if (_isInHelsingor(lat, lon)) {
      return "Helsingør";
    } else if (_isInViborg(lat, lon)) {
      return "Viborg";
    } else if (_isInKoge(lat, lon)) {
      return "Køge";
    } else if (_isInHolstebro(lat, lon)) {
      return "Holstebro";
    } else if (_isInSlagelse(lat, lon)) {
      return "Slagelse";
    } else if (_isInSvendborg(lat, lon)) {
      return "Svendborg";
    } else if (_isInSonderborg(lat, lon)) {
      return "Sønderborg";
    } else if (_isInHjorring(lat, lon)) {
      return "Hjørring";
    } else if (_isInHolbaek(lat, lon)) {
      return "Holbæk";
    } else if (_isInFrederikshavn(lat, lon)) {
      return "Frederikshavn";
    } else if (_isInHaderslev(lat, lon)) {
      return "Haderslev";
    } else if (_isInSkive(lat, lon)) {
      return "Skive";
    } else if (_isInRingsted(lat, lon)) {
      return "Ringsted";
    } else if (_isInFarum(lat, lon)) {
      return "Farum";
    } else if (_isInNykobingFalster(lat, lon)) {
      return "Nykøbing Falster";
    } else if (_isInAabenraa(lat, lon)) {
      return "Aabenraa";
    } else if (_isInKalundborg(lat, lon)) {
      return "Kalundborg";
    } else if (_isInNyborg(lat, lon)) {
      return "Nyborg";
    } else {
      return ""; // Default for unknown or smaller locations
    }
  } // Class could be improved.

  static bool _isInCopenhagen(double lat, double lon) {
    return lat >= 55.6 && lat <= 55.8 && lon >= 12.4 && lon <= 12.7; // 1,154k pop
  }

  static bool _isInAarhus(double lat, double lon) {
    return lat >= 56.1 && lat <= 56.2 && lon >= 10.1 && lon <= 10.3; // 238k pop
  }

  static bool _isInOdense(double lat, double lon) {
    return lat >= 55.3 && lat <= 55.5 && lon >= 10.3 && lon <= 10.5; // 146k pop
  }

  static bool _isInAalborg(double lat, double lon) {
    return lat >= 57.0 && lat <= 57.1 && lon >= 9.8 && lon <= 10.0; // 122k pop
  }

  static bool _isInFrederiksberg(double lat, double lon) {
    return lat >= 55.66 && lat <= 55.68 && lon >= 12.50 && lon <= 12.55; // 95k pop
  }

  static bool _isInEsbjerg(double lat, double lon) {
    return lat >= 55.45 && lat <= 55.55 && lon >= 8.40 && lon <= 8.50; // 72k pop
  }

  static bool _isInRanders(double lat, double lon) {
    return lat >= 56.45 && lat <= 56.50 && lon >= 10.00 && lon <= 10.10; // 56k pop
  }

  static bool _isInKolding(double lat, double lon) {
    return lat >= 55.48 && lat <= 55.54 && lon >= 9.46 && lon <= 9.52; // 55k pop
  }

  static bool _isInVejle(double lat, double lon) {
    return lat >= 55.70 && lat <= 55.74 && lon >= 9.50 && lon <= 9.56; // 51k pop
  }

  static bool _isInHorsens(double lat, double lon) {
    return lat >= 55.85 && lat <= 55.90 && lon >= 9.80 && lon <= 10.00; // 50k pop
  }

  static bool _isInHerning(double lat, double lon) {
    return lat >= 56.13 && lat <= 56.18 && lon >= 8.95 && lon <= 9.05; // 45k pop
  }

  static bool _isInRoskilde(double lat, double lon) {
    return lat >= 55.63 && lat <= 55.67 && lon >= 12.07 && lon <= 12.13; // 44k pop
  }

  static bool _isInSilkeborg(double lat, double lon) {
    return lat >= 56.17 && lat <= 56.22 && lon >= 9.53 && lon <= 9.57; // 42k pop
  }

  static bool _isInNaestved(double lat, double lon) {
    return lat >= 55.22 && lat <= 55.27 && lon >= 11.75 && lon <= 11.82; // 41k pop
  }

  static bool _isInFredericia(double lat, double lon) {
    return lat >= 55.56 && lat <= 55.61 && lon >= 9.74 && lon <= 9.80; // 37k pop
  }

  static bool _isInHelsingor(double lat, double lon) {
    return lat >= 56.02 && lat <= 56.05 && lon >= 12.60 && lon <= 12.63; // 35k pop
  }

  static bool _isInViborg(double lat, double lon) {
    return lat >= 56.45 && lat <= 56.50 && lon >= 9.38 && lon <= 9.42; // 35k pop
  }

  static bool _isInKoge(double lat, double lon) {
    return lat >= 55.45 && lat <= 55.50 && lon >= 12.17 && lon <= 12.22; // 34k pop
  }

  static bool _isInHolstebro(double lat, double lon) {
    return lat >= 56.36 && lat <= 56.41 && lon >= 8.61 && lon <= 8.66; // 32k pop
  }

  static bool _isInSlagelse(double lat, double lon) {
    return lat >= 55.40 && lat <= 55.45 && lon >= 11.34 && lon <= 11.39; // 32k pop
  }

  static bool _isInSvendborg(double lat, double lon) {
    return lat >= 55.05 && lat <= 55.10 && lon >= 10.60 && lon <= 10.65; // 28k pop
  }

  static bool _isInSonderborg(double lat, double lon) {
    return lat >= 54.90 && lat <= 54.95 && lon >= 9.75 && lon <= 9.80; // 27k pop
  }

  static bool _isInHjorring(double lat, double lon) {
    return lat >= 57.45 && lat <= 57.50 && lon >= 9.90 && lon <= 10.00; // 25k pop
  }

  static bool _isInHolbaek(double lat, double lon) {
    return lat >= 55.70 && lat <= 55.75 && lon >= 11.63 && lon <= 11.67; // 24k pop
  }

  static bool _isInFrederikshavn(double lat, double lon) {
    return lat >= 57.43 && lat <= 57.48 && lon >= 10.50 && lon <= 10.55; // 24k pop
  }

  static bool _isInHaderslev(double lat, double lon) {
    return lat >= 55.24 && lat <= 55.27 && lon >= 9.47 && lon <= 9.52; // 21k pop
  }

  static bool _isInSkive(double lat, double lon) {
    return lat >= 56.34 && lat <= 56.39 && lon >= 9.02 && lon <= 9.08; // 21k pop
  }

  static bool _isInRingsted(double lat, double lon) {
    return lat >= 55.44 && lat <= 55.48 && lon >= 11.77 && lon <= 11.82; // 20k pop
  }

  static bool _isInFarum(double lat, double lon) {
    return lat >= 55.80 && lat <= 55.85 && lon >= 12.35 && lon <= 12.40; // 18k pop
  }

  static bool _isInNykobingFalster(double lat, double lon) {
    return lat >= 54.76 && lat <= 54.80 && lon >= 11.87 && lon <= 11.92; // 17k pop
  }

  static bool _isInAabenraa(double lat, double lon) {
    return lat >= 55.03 && lat <= 55.07 && lon >= 9.42 && lon <= 9.47; // 16k pop
  }

  static bool _isInKalundborg(double lat, double lon) {
    return lat >= 55.66 && lat <= 55.70 && lon >= 11.07 && lon <= 11.12; // 16k pop
  }

  static bool _isInNyborg(double lat, double lon) {
    return lat >= 55.32 && lat <= 55.36 && lon >= 10.78 && lon <= 10.82; // 16k pop
  }



}
