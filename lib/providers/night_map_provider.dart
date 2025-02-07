import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:nightview/helpers/clubs/club_data_helper.dart';
import 'package:nightview/helpers/users/misc/location_helper.dart';
import 'package:nightview/locations/location_service.dart';

class NightMapProvider with ChangeNotifier {
  final MapController nightMapController = MapController();
  final ClubDataHelper clubDataHelper = ClubDataHelper();
  final locationHelper = LocationHelper(
    // Default no-op function to avoid errors
    onPositionUpdate: (location) async {
    },
  );

  List<Marker> _markers = [];

  List<Marker> get markers => _markers;

  get lastKnownPosition => LocationService.getUserLocation(); //TODO store value and update when called

  // void updateMarkers(List<Marker> newMarkers) { // TODO NEED REWORK
  //   _markers = newMarkers;
  //   notifyListeners(); // ✅ Updates only relevant UI components, not the entire map.
  // }

  Future<void> updatePositionAndEvaluateVisitors({required double lat, required double lon}) async {
    clubDataHelper.evaluateVisitors();
    notifyListeners(); // ✅ Only updates relevant map components.
  // TODO setUserLastposition  figure out. This maybe needs replacing.
  }

  void moveToUserLocation(LatLng position) {
    nightMapController.move(position, nightMapController.camera.zoom);
  }





}
