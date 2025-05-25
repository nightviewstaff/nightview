import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:latlong2/latlong.dart';
import 'package:nightview/locations/location_service.dart';
import 'package:nightview/providers/night_map_provider.dart';

class NightMap extends StatefulWidget {
  const NightMap({super.key});
  @override
  State<NightMap> createState() => NightMapState();
}

class NightMapState extends State<NightMap> with AutomaticKeepAliveClientMixin {
  MapboxMap? _map;
  bool _mapCreated = false;
  CameraOptions? _camera;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final latLng = LatLng(55.6761, 12.5683); // Copenhagen
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

    await provider.initMapbox(map, (_) {});

    await map.setBounds(CameraBoundsOptions(minZoom: 1.0));
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
    ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_camera == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return MapWidget(
      key: const ValueKey("mapWidget"),
      styleUri: "mapbox://styles/nightview/cmb0q53y2008l01rk9wqb0jv3",
      cameraOptions: _camera!,
      onMapCreated: _onMapCreated,
      onStyleLoadedListener: _onStyleLoaded,
    );
  }

  @override
  void dispose() {
    context.read<NightMapProvider>().disposeOverlay();
    super.dispose();
  }
}
