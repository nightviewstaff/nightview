class AdvancedSearchFilter {
  // Constants for sliders
  static const double maxDistanceKm = 60;
  static const double defaultMinCrowdFillPercent = 40; // 40%
  static const double defaultMinFemalePercent = 20; // 20%

  // Default values
  static const double defaultDistanceMin = 0;
  static const double defaultDistanceMax = 8000; // in meters
  static const double defaultAgeMin = 18;
  static const double defaultAgeMax = 100;
  static const double defaultMoneyMin = 0;
  static const double defaultMoneyMax = 5;
  static const int defaultRatingMin = 3;
  static const int defaultRatingMax = 5;
  static const bool defaultShowOpenOnly = true;

  // Actual filter values
  final double distanceMin;
  final double distanceMax;
  final double ageMin;
  final double ageMax;
  final double moneyMin;
  final double moneyMax;
  final int ratingMin;
  final int ratingMax;
  final bool showOpenOnly;
  final double minCrowdFillPercent;
  final double minFemalePercent;
  final List<String> selectedLocationTypes;

  const AdvancedSearchFilter({
    this.distanceMin = defaultDistanceMin,
    this.distanceMax = defaultDistanceMax,
    this.ageMin = defaultAgeMin,
    this.ageMax = defaultAgeMax,
    this.moneyMin = defaultMoneyMin,
    this.moneyMax = defaultMoneyMax,
    this.ratingMin = defaultRatingMin,
    this.ratingMax = defaultRatingMax,
    this.showOpenOnly = defaultShowOpenOnly,
    this.minCrowdFillPercent = defaultMinCrowdFillPercent,
    this.minFemalePercent = defaultMinFemalePercent,
    required this.selectedLocationTypes, // Make required to enforce initialization
  });

  AdvancedSearchFilter copyWith({
    double? distanceMin,
    double? distanceMax,
    double? ageMin,
    double? ageMax,
    double? moneyMin,
    double? moneyMax,
    int? ratingMin,
    int? ratingMax,
    bool? showOpenOnly,
    double? minCrowdFillPercent,
    double? minFemalePercent,
    List<String>? selectedLocationTypes,
  }) {
    return AdvancedSearchFilter(
      distanceMin: distanceMin ?? this.distanceMin,
      distanceMax: distanceMax ?? this.distanceMax,
      ageMin: ageMin ?? this.ageMin,
      ageMax: ageMax ?? this.ageMax,
      moneyMin: moneyMin ?? this.moneyMin,
      moneyMax: moneyMax ?? this.moneyMax,
      ratingMin: ratingMin ?? this.ratingMin,
      ratingMax: ratingMax ?? this.ratingMax,
      showOpenOnly: showOpenOnly ?? this.showOpenOnly,
      minCrowdFillPercent: minCrowdFillPercent ?? this.minCrowdFillPercent,
      minFemalePercent: minFemalePercent ?? this.minFemalePercent,
      selectedLocationTypes:
          selectedLocationTypes ?? this.selectedLocationTypes,
    );
  }

  AdvancedSearchFilter clone() {
    return copyWith();
  }
}
