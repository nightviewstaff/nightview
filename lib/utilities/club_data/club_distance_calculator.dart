import 'dart:math';

import '../../models/clubs/club_data.dart';

class ClubDistanceCalculator {
  static String displayDistanceToClub({
    required double userLat,
    required double userLon,
    required ClubData club,
  }) {
    return _formatDistance(
      ClubDistanceCalculator.calculateDistance(
        lat1: userLat,
        lon1: userLon,
        lat2: club.lat,
        lon2: club.lon,
      ),
    );
  }

  static String _formatDistance(double distance) {
    if (distance > 99) {
      // If distance is greater than 99 km, display as "99+"
      return "99+ km";
    } else if (distance < 1) {
      // Less than 1 km, show in meters without decimals
      return "${(distance * 1000).toStringAsFixed(0)} m";
    } else if (distance < 10) {
      // Between 1 and 10 km, show with 1 decimal
      return "${distance.toStringAsFixed(1)} km";
    } else {
      // 10 km or more, show as whole number
      return "${distance.toStringAsFixed(0)} km";
    }
  }


  static double calculateDistance({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    const double radiusOfEarth = 6371; // Earth's radius in kilometers

    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return radiusOfEarth * c; // Distance in kilometers
  }

  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}
