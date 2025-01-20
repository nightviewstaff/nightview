import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationService { // TODO Prop needs to be removed entirely - should be done in provider.
  static Future<LatLng?> getUserLocation() async {
    //TODO Move so can acess from anywhere
    // Move
    try {
      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever ||
            permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      // Get the user's current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Convert Position to LatLng
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      return null; // Return null if there's an error
    }
  }


}
