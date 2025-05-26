import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:nightview/helpers/clubs/club_data_helper.dart';
import 'package:nightview/helpers/users/misc/location_helper.dart';
import 'package:nightview/locations/location_service.dart';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:nightview/screens/night_map/club_overlay_controller.dart';

class NightMapProvider with ChangeNotifier {
  MapboxMap? mapController;
  ClubOverlayController? _overlayController;
  bool isInitialized = false;

  final ClubDataHelper clubDataHelper = ClubDataHelper();
  final MapController nightMapController = MapController();
  final locationHelper = LocationHelper(onPositionUpdate: (location) async {});
  final List<Marker> _markers = [];

  List<Marker> get markers => _markers;
  Future<LatLng?> _lastKnownPosition = LocationService.getUserLocation();
  get lastKnownPosition => _lastKnownPosition;

  void setLastknownPosition(LatLng pos) {
    _lastKnownPosition = pos as Future<LatLng?>;
  }

  Future<void> initMapbox(MapboxMap map, BuildContext context) async {
    if (isInitialized) return;
    isInitialized = true;

    mapController = map;

    // ✅ Ensure club data is loaded before overlay initialization
    await clubDataHelper.loadInitialClubs();
    _overlayController = ClubOverlayController(map, clubDataHelper, context);
    await _overlayController!.init();
  }

  void setMap(MapboxMap newMap) {
    mapController = newMap;
    notifyListeners();
  }

  void disposeOverlay() {
    _overlayController?.dispose();
    _overlayController = null;
    isInitialized = false; // ✅ Reset for next view lifecycle
  }
}
