import 'package:nightview/locations/geofence_corner.dart';
import 'package:nightview/locations/geofence_center.dart';

class Geofence {
  final String clubId;
  final List<GeofenceCorner> corners;
  final GeofenceCenter center;
  final double radius;

  Geofence({
    required this.clubId,
    required this.corners,
    required this.center,
    this.radius = 10.0, // Default radius, adjust as needed
  });
}
