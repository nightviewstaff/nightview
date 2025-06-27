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

  static List<ClubData> sortClubsByDistance({
    required double userLat,
    required double userLon,
    required List<ClubData> clubs,
  }) {
    return [...clubs] // Copy list to avoid modifying the original
      ..sort((a, b) {
        final distanceA = calculateDistance(
          lat1: userLat,
          lon1: userLon,
          lat2: a.lat,
          lon2: a.lon,
        );
        final distanceB = calculateDistance(
          lat1: userLat,
          lon1: userLon,
          lat2: b.lat,
          lon2: b.lon,
        );
        return distanceA.compareTo(distanceB); // Sort ascending
      });
  }

  static String _formatDistance(double distance) {
    if (distance < 1) {
      final meters = (distance * 1000).ceil();
      final rounded = meters <= 100
          ? 100
          : (meters % 100 <= 50
              ? (meters ~/ 100) * 100 + 50
              : ((meters ~/ 100) + 1) * 100);
      return "$rounded m";
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

  static String displayWalkingTimeToClub({
    required double userLat,
    required double userLon,
    required ClubData club,
  }) {
    final distanceInKm = calculateDistance(
      lat1: userLat,
      lon1: userLon,
      lat2: club.lat,
      lon2: club.lon,
    );

    const walkingSpeedKmPerHour = 4.2;
    final totalMinutes = (distanceInKm / walkingSpeedKmPerHour * 60).ceil();

    if (totalMinutes < 60) {
      return '$totalMinutes min';
    } else {
      final hours = totalMinutes ~/ 60;
      final minutes = totalMinutes % 60;
      return minutes > 0 ? '$hours hr $minutes min' : '$hours hr';
    }
  }
}
