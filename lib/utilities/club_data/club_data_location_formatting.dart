class ClubDataLocationFormatting {
  /// Map of the official city names to a list of synonyms.
  static final Map<String, List<String>> danishCitiesAndAreas = {
    "København": [
      "København",
      "Københav",
      "Københa",
      "Københ",
      "Køben",
      "Købe",
      "Køb" "Copenhagen",
      "copenhage",
      "copenhag",
      "copenha",
      "copenh",
      "copen",
      "cope",
      "cop" "kbh",
      "Koebenhavn",
      "Koeb",
    ],
    "Aarhus": ["Aarhus", "Århus", "Arhus", "århu", "årh", "år"],
    "Odense": ["Odense"],
    "Aalborg": ["Aalborg", "Ålborg"],
    "Frederiksberg": ["Frederiksberg"],
    "Esbjerg": ["Esbjerg"],
    "Randers": ["Randers"],
    "Kolding": ["Kolding"],
    "Vejle": ["Vejle"],
    "Horsens": ["Horsens"],
    "Herning": ["Herning"],
    "Roskilde": ["Roskilde"],
    "Silkeborg": ["Silkeborg"],
    "Næstved": ["Næstved", "Naestved"],
    "Fredericia": ["Fredericia"],
    "Helsingør": ["Helsingør", "Helsingoer"],
    "Viborg": ["Viborg"],
    "Køge": ["Køge", "Koge"],
    "Holstebro": ["Holstebro"],
    "Slagelse": ["Slagelse"],
    "Svendborg": ["Svendborg"],
    "Sønderborg": ["Sønderborg", "Soenderborg"],
    "Hjørring": ["Hjørring", "Hjorring"],
    "Holbæk": ["Holbæk", "Holbaek"],
    "Frederikshavn": ["Frederikshavn"],
    "Haderslev": ["Haderslev"],
    "Skive": ["Skive"],
    "Ringsted": ["Ringsted"],
    "Farum": ["Farum"],
    "Nykøbing Falster": ["Nykøbing Falster", "Nykobing Falster"],
    "Aabenraa": ["Aabenraa"],
    "Kalundborg": ["Kalundborg"],
    "Nyborg": ["Nyborg"],
  };

  /// Instead of dozens of _isInCity functions, we define bounding boxes here.
  /// The keys are the official city names.
  static final Map<String, Map<String, double>> cityBoundingBoxes = {
    // Denmark
    "København": {
      "minLat": 55.6,
      "maxLat": 55.8,
      "minLon": 12.4,
      "maxLon": 12.7
    },
    "Aarhus": {"minLat": 56.1, "maxLat": 56.2, "minLon": 10.1, "maxLon": 10.3},
    "Odense": {"minLat": 55.3, "maxLat": 55.5, "minLon": 10.3, "maxLon": 10.5},
    "Aalborg": {"minLat": 57.0, "maxLat": 57.1, "minLon": 9.8, "maxLon": 10.0},
    // Sweden
    "Stockholm": {
      "minLat": 59.25,
      "maxLat": 59.40,
      "minLon": 17.95,
      "maxLon": 18.15
    },
    "Göteborg": {
      "minLat": 57.65,
      "maxLat": 57.75,
      "minLon": 11.90,
      "maxLon": 12.00
    },
    "Malmö": {
      "minLat": 55.55,
      "maxLat": 55.65,
      "minLon": 12.95,
      "maxLon": 13.05
    },
    // Germany
    "Berlin": {
      "minLat": 52.45,
      "maxLat": 52.55,
      "minLon": 13.30,
      "maxLon": 13.50
    },
    "Hamburg": {
      "minLat": 53.50,
      "maxLat": 53.60,
      "minLon": 9.90,
      "maxLon": 10.10
    },
    "München": {
      "minLat": 48.10,
      "maxLat": 48.20,
      "minLon": 11.50,
      "maxLon": 11.65
    },
    // France
    "Paris": {"minLat": 48.80, "maxLat": 48.90, "minLon": 2.25, "maxLon": 2.40},
    "Marseille": {
      "minLat": 43.25,
      "maxLat": 43.35,
      "minLon": 5.35,
      "maxLon": 5.45
    },
    "Lyon": {"minLat": 45.70, "maxLat": 45.80, "minLon": 4.80, "maxLon": 4.90},
    // United Kingdom
    "London": {
      "minLat": 51.45,
      "maxLat": 51.55,
      "minLon": -0.20,
      "maxLon": 0.00
    },
    "Manchester": {
      "minLat": 53.45,
      "maxLat": 53.50,
      "minLon": -2.30,
      "maxLon": -2.20
    },
    // Spain
    "Madrid": {
      "minLat": 40.35,
      "maxLat": 40.45,
      "minLon": -3.75,
      "maxLon": -3.65
    },
    "Barcelona": {
      "minLat": 41.35,
      "maxLat": 41.45,
      "minLon": 2.10,
      "maxLon": 2.20
    },
    // Italy
    "Rome": {
      "minLat": 41.85,
      "maxLat": 41.95,
      "minLon": 12.45,
      "maxLon": 12.55
    },
    "Milan": {"minLat": 45.40, "maxLat": 45.50, "minLon": 9.15, "maxLon": 9.25},
    // Netherlands
    "Amsterdam": {
      "minLat": 52.35,
      "maxLat": 52.40,
      "minLon": 4.85,
      "maxLon": 4.95
    },
    "Rotterdam": {
      "minLat": 51.90,
      "maxLat": 51.95,
      "minLon": 4.45,
      "maxLon": 4.55
    },
    // Norway
    "Oslo": {
      "minLat": 59.90,
      "maxLat": 59.95,
      "minLon": 10.70,
      "maxLon": 10.80
    },
    "Bergen": {
      "minLat": 60.35,
      "maxLat": 60.40,
      "minLon": 5.30,
      "maxLon": 5.35
    },
    // Finland
    "Helsinki": {
      "minLat": 60.15,
      "maxLat": 60.20,
      "minLon": 24.90,
      "maxLon": 25.00
    },
    "Tampere": {
      "minLat": 61.45,
      "maxLat": 61.50,
      "minLon": 23.75,
      "maxLon": 23.85
    },
  };

  /// Returns the official city name if the given coordinates fall within one
  static String determineLocationFromCoordinates(double lat, double lon) {
    for (var entry in cityBoundingBoxes.entries) {
      final bounds = entry.value;
      if (lat >= bounds["minLat"]! &&
          lat <= bounds["maxLat"]! &&
          lon >= bounds["minLon"]! &&
          lon <= bounds["maxLon"]!) {
        return entry.key;
      }
    }
    return ""; // Unknown or smaller locations.
  }

  /// Calculates the Levenshtein distance between two strings.
  static int levenshtein(String s, String t) {
    final int m = s.length;
    final int n = t.length;
    List<List<int>> d = List.generate(m + 1, (i) => List.filled(n + 1, 0));

    for (int i = 0; i <= m; i++) {
      d[i][0] = i;
    }
    for (int j = 0; j <= n; j++) {
      d[0][j] = j;
    }
    for (int i = 1; i <= m; i++) {
      for (int j = 1; j <= n; j++) {
        int cost = s[i - 1] == t[j - 1] ? 0 : 1;
        d[i][j] = [
          d[i - 1][j] + 1,
          d[i][j - 1] + 1,
          d[i - 1][j - 1] + cost,
        ].reduce((a, b) => a < b ? a : b);
      }
    }
    return d[m][n];
  }

  /// Returns true if the Levenshtein distance between [a] and [b] is within [threshold].
  static bool isFuzzyMatch(String a, String b, [int threshold = 1]) {
    // TEST
    return levenshtein(a, b) <= threshold;
  }

  /// Normalizes a given location string to its canonical city name if possible.
  /// For example, if a club’s location is "Copenhagen City Centre" and a synonym "copenhagen"
  /// appears (or is a fuzzy match), this returns "København".
  static String normalizeLocation(String location) {
    final lowerLocation = location.toLowerCase();
    for (var entry in danishCitiesAndAreas.entries) {
      for (var alt in entry.value) {
        String altLower = alt.toLowerCase();
        // Check if the location contains the synonym or if they are a fuzzy match.
        if (lowerLocation.contains(altLower) ||
            isFuzzyMatch(lowerLocation, altLower)) {
          return entry.key;
        }
      }
    }
    return location;
  }
}
