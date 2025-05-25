import 'dart:typed_data';

import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

abstract class OverlayController<T> {
  final MapboxMap map;
  PointAnnotationManager? manager;

  OverlayController(this.map);

  Future init(Uint8List iconData);
  void setItems(List<T> items);
  void dispose();
}
