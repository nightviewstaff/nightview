import 'package:nightview/constants/enums.dart';

class ClubData {
  final String id;
  final String name;
  final String logo;
  final String? mainOfferImg;
  final String typeOfClub;
  final String typeOfClubImg;

  final int ageRestriction;
  final int totalPossibleAmountOfVisitors;
  int visitors;
  int rating;

  final double lat;
  final double lon;

  final Map<String, Map<String, dynamic>?>? openingHours; // can support day-specific ageRestriction

  final List<dynamic> favorites;
  final List<dynamic> corners;

  final OfferType offerType;

  ClubData({
    // would be nice to only have the necessaries required, so the marker can be displayed even if db is incomplete
    required this.id,
    required this.name,
    required this.logo,
    required this.lat,
    required this.lon,
    required this.favorites,
    required this.corners,
    required this.offerType,
    required this.mainOfferImg,
    required this.ageRestriction,
    required this.typeOfClub,
    required this.typeOfClubImg,
    required this.rating,
    required this.openingHours,
    required this.totalPossibleAmountOfVisitors,
    this.visitors = 0,
  });
}
