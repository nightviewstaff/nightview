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
    "København": {
      "minLat": 55.6,
      "maxLat": 55.8,
      "minLon": 12.4,
      "maxLon": 12.7
    },
    "Aarhus": {"minLat": 56.1, "maxLat": 56.2, "minLon": 10.1, "maxLon": 10.3},
    "Odense": {"minLat": 55.3, "maxLat": 55.5, "minLon": 10.3, "maxLon": 10.5},
    "Aalborg": {"minLat": 57.0, "maxLat": 57.1, "minLon": 9.8, "maxLon": 10.0},
    "Frederiksberg": {
      "minLat": 55.66,
      "maxLat": 55.68,
      "minLon": 12.50,
      "maxLon": 12.55
    },
    "Esbjerg": {
      "minLat": 55.45,
      "maxLat": 55.55,
      "minLon": 8.40,
      "maxLon": 8.50
    },
    "Randers": {
      "minLat": 56.45,
      "maxLat": 56.50,
      "minLon": 10.00,
      "maxLon": 10.10
    },
    "Kolding": {
      "minLat": 55.48,
      "maxLat": 55.54,
      "minLon": 9.46,
      "maxLon": 9.52
    },
    "Vejle": {"minLat": 55.70, "maxLat": 55.74, "minLon": 9.50, "maxLon": 9.56},
    "Horsens": {
      "minLat": 55.85,
      "maxLat": 55.90,
      "minLon": 9.80,
      "maxLon": 10.00
    },
    "Herning": {
      "minLat": 56.13,
      "maxLat": 56.18,
      "minLon": 8.95,
      "maxLon": 9.05
    },
    "Roskilde": {
      "minLat": 55.63,
      "maxLat": 55.67,
      "minLon": 12.07,
      "maxLon": 12.13
    },
    "Silkeborg": {
      "minLat": 56.17,
      "maxLat": 56.22,
      "minLon": 9.53,
      "maxLon": 9.57
    },
    "Næstved": {
      "minLat": 55.22,
      "maxLat": 55.27,
      "minLon": 11.75,
      "maxLon": 11.82
    },
    "Fredericia": {
      "minLat": 55.56,
      "maxLat": 55.61,
      "minLon": 9.74,
      "maxLon": 9.80
    },
    "Helsingør": {
      "minLat": 56.02,
      "maxLat": 56.05,
      "minLon": 12.60,
      "maxLon": 12.63
    },
    "Viborg": {
      "minLat": 56.45,
      "maxLat": 56.50,
      "minLon": 9.38,
      "maxLon": 9.42
    },
    "Køge": {
      "minLat": 55.45,
      "maxLat": 55.50,
      "minLon": 12.17,
      "maxLon": 12.22
    },
    "Holstebro": {
      "minLat": 56.36,
      "maxLat": 56.41,
      "minLon": 8.61,
      "maxLon": 8.66
    },
    "Slagelse": {
      "minLat": 55.40,
      "maxLat": 55.45,
      "minLon": 11.34,
      "maxLon": 11.39
    },
    "Svendborg": {
      "minLat": 55.05,
      "maxLat": 55.10,
      "minLon": 10.60,
      "maxLon": 10.65
    },
    "Sønderborg": {
      "minLat": 54.90,
      "maxLat": 54.95,
      "minLon": 9.75,
      "maxLon": 9.80
    },
    "Hjørring": {
      "minLat": 57.45,
      "maxLat": 57.50,
      "minLon": 9.90,
      "maxLon": 10.00
    },
    "Holbæk": {
      "minLat": 55.70,
      "maxLat": 55.75,
      "minLon": 11.63,
      "maxLon": 11.67
    },
    "Frederikshavn": {
      "minLat": 57.43,
      "maxLat": 57.48,
      "minLon": 10.50,
      "maxLon": 10.55
    },
    "Haderslev": {
      "minLat": 55.24,
      "maxLat": 55.27,
      "minLon": 9.47,
      "maxLon": 9.52
    },
    "Skive": {"minLat": 56.34, "maxLat": 56.39, "minLon": 9.02, "maxLon": 9.08},
    "Ringsted": {
      "minLat": 55.44,
      "maxLat": 55.48,
      "minLon": 11.77,
      "maxLon": 11.82
    },
    "Farum": {
      "minLat": 55.80,
      "maxLat": 55.85,
      "minLon": 12.35,
      "maxLon": 12.40
    },
    "Nykøbing Falster": {
      "minLat": 54.76,
      "maxLat": 54.80,
      "minLon": 11.87,
      "maxLon": 11.92
    },
    "Aabenraa": {
      "minLat": 55.03,
      "maxLat": 55.07,
      "minLon": 9.42,
      "maxLon": 9.47
    },
    "Kalundborg": {
      "minLat": 55.66,
      "maxLat": 55.70,
      "minLon": 11.07,
      "maxLon": 11.12
    },
    "Nyborg": {
      "minLat": 55.32,
      "maxLat": 55.36,
      "minLon": 10.78,
      "maxLon": 10.82
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
