class GeofenceCorner {
  final double latitude;
  final double longitude;

  GeofenceCorner({required this.latitude, required this.longitude});

  factory GeofenceCorner.fromMap(Map<String, dynamic> map) {
    return GeofenceCorner(
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}