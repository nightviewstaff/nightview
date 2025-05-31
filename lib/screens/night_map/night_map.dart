import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/icons.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:latlong2/latlong.dart';
import 'package:nightview/locations/location_service.dart';
import 'package:nightview/providers/night_map_provider.dart';

class NightMap extends StatefulWidget {
  static const id = 'night_map';
  const NightMap({super.key});
  @override
  State<NightMap> createState() => NightMapState();
}
//TODO So many cool things in this class!

class NightMapState extends State<NightMap> with AutomaticKeepAliveClientMixin {
  MapboxMap? _map;
  bool _mapCreated = false;
  CameraOptions? _camera;
  double? _lastZoom;
  bool shouldShowCenterButton = true;
  bool shouldShowNorthButton = true;
  bool shouldShowTopDownButton = true;
  double localPitch = 0;
  double localBearing = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_camera == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      //TODO Long click for buttons possible at some point.
      children: [
        MapWidget(
          key: const ValueKey("mapWidget"),
          styleUri: "mapbox://styles/nightview/cmb0q53y2008l01rk9wqb0jv3",
          cameraOptions: _camera!,
          onMapCreated: _onMapCreated,
          onStyleLoadedListener: _onStyleLoaded,
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Column(
            children: [
              _buildMapButton(
                icon: Icons.my_location,
                tooltip: "Center on user",
                onPressed: _centerOnUser,
              ),
            ],
          ),
        ),
        // if (localBearing != 0)
        Positioned(
          top: 10,
          right: 10,
          child: _buildMapButton(
            icon: defaultCompassIcon,
            tooltip: "Face north",
            onPressed: _faceNorth,
          ),
        ),
        // if (localPitch != 0)
        Positioned(
          top: 60,
          right: 10,
          child: _buildMapButton(
            icon: Icons.rotate_90_degrees_ccw_sharp,
            tooltip: "Top-down",
            onPressed: _topDownView,
          ),
        ),
      ],
    );
  }

  Future<void> _centerOnUser() async {
    final map = _map;
    if (map == null) return;

    final latLng = await LocationService.getUserLocation();
    map.cancelCameraAnimation();
    map.flyTo(
      CameraOptions(
        center: Point(coordinates: Position(latLng.longitude, latLng.latitude)),
        zoom: 12.0,
        pitch: 0,
        bearing: 0,
      ),
      MapAnimationOptions(duration: 1500),
    );
    localBearing = 0;
    localPitch = 0;
  }

  void _faceNorth() {
    final map = _map;
    if (map == null) return;

    map.cancelCameraAnimation();
    map.easeTo(
      CameraOptions(bearing: 0),
      MapAnimationOptions(duration: 500),
    );
    localBearing = 0;
  }

  void _topDownView() {
    final map = _map;
    if (map == null) return;

    map.cancelCameraAnimation();
    map.easeTo(
      CameraOptions(pitch: 0),
      MapAnimationOptions(duration: 500),
    );
    localPitch = 0;
  }

  Future<void> _initializeCamera() async {
    LatLng latLng;

    try {
      final userLoc = await LocationService.getUserLocation();
      latLng = userLoc; // fallback to Copenhagen
    } catch (e) {
      print("⚠️ Failed to get user location, defaulting to Copenhagen");
      latLng = LatLng(55.6761, 12.5683);
    }

    setState(() {
      _camera = CameraOptions(
        center: Point(coordinates: Position(latLng.longitude, latLng.latitude)),
        zoom: 12.0,
      );
    });
  }

  void _onMapCreated(MapboxMap map) async {
    if (_mapCreated) return; // ⛔ avoid duplicate view instantiation
    _mapCreated = true;
    _map = map;

    final status = await Permission.locationWhenInUse.request();
    if (status.isGranted) {
      await map.location.updateSettings(
        LocationComponentSettings(
          enabled: true,
          pulsingEnabled: true,
          showAccuracyRing: true,
        ),
      );
    }

    await map.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    await map.attribution.updateSettings(AttributionSettings(enabled: false));
  }

  Future<void> _onStyleLoaded(StyleLoadedEventData data) async {
    if (_map == null) return;
    final map = _map!;
    final provider = context.read<NightMapProvider>();

    await provider.initMapbox(map, context);

    await map.setBounds(CameraBoundsOptions(minZoom: 5.0));
    await map.attribution.updateSettings(AttributionSettings(
      position: OrnamentPosition.TOP_LEFT,
      marginLeft: 4.0,
      marginTop: 4.0,
      iconColor: 0x00000000,
    ));
    await map.logo.updateSettings(LogoSettings(enabled: false));
    await map.compass.updateSettings(CompassSettings(
      enabled: true,
      position: OrnamentPosition.TOP_RIGHT,
      marginRight: 8.0,
      marginTop: 8.0,
      opacity: 1,
    ));
  }

  @override
  void dispose() {
    context.read<NightMapProvider>().disposeOverlay();
    super.dispose();
  }

  Future<MapboxMap?> getMapboxMap() async {
    return _map;
  }

  Widget _buildMapButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return FloatingActionButton(
      mini: true,
      heroTag: tooltip,
      tooltip: tooltip,
      backgroundColor: black,
      onPressed: onPressed,
      child: Icon(icon, color: secondaryColor),
    );
  }
}
