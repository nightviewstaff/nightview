import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationService {
  static Future<LatLng> getUserLocation() async {
    // return LatLng(55.6761, 12.5683);
    try {
      // Step 1: Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled');
        // On Simulator, this might always be false unless manually enabled
        return LatLng(55.6761, 12.5683); // Fallback to Copenhagen
      }

      // Step 2: Check and request permissions
      LocationPermission permission = await Geolocator.checkPermission();
      print('Initial permission state: $permission');
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        print('Permission after request: $permission');
        if (permission == LocationPermission.denied) {
          print('Location permission denied');
          return LatLng(55.6761, 12.5683); // Fallback
        }
        if (permission == LocationPermission.deniedForever) {
          print('Location permission denied forever');
          return LatLng(55.6761, 12.5683); // Fallback
        }
      }

      // Step 3: Get position with a timeout
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit:
            Duration(seconds: 1), // TODO. NOTHING LOADS BEFORE infinite wait
      ).timeout(Duration(seconds: 1), onTimeout: () {
        print('getCurrentPosition timed out');
        throw TimeoutException('Location fetch timed out');
      });

      print('Location fetched: ${position.latitude}, ${position.longitude}');
      return LatLng(position.latitude, position.longitude);
    } catch (e, stackTrace) {
      print(
          'Error fetching location (${e.runtimeType}): $e\nStackTrace: $stackTrace');
      // Return a fallback location so the app doesn't hang
      return LatLng(55.6761, 12.5683); // Copenhagen as default
    }
  }
}
