import 'package:nightview/constants/enums.dart';

class ClubData {
  final String id;
  final String name;
  final String logo;
  final String? mainOfferImg;
  final String typeOfClub;

  final int ageRestriction;
  final int totalPossibleAmountOfVisitors;
  int visitors;
  int rating;

  final double lat;
  final double lon;

  final Map<String, Map<String, String>> openingHours;

  final List<dynamic> favorites;
  final List<dynamic> corners;

  final OfferType offerType;

  ClubData({
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
    required this.rating,
    required this.openingHours,
    required this.totalPossibleAmountOfVisitors,
    this.visitors = 0,
  });

}