import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class ClubOverlayController {
  final MapboxMap map;
  CircleAnnotationManager? _circleMgr;
  PolylineAnnotationManager? _polylineMgr;
  PolygonAnnotationManager? _polygonMgr;
  PointAnnotationManager? _pointMgr;

  ClubOverlayController(this.map, dynamic _, dynamic __);

  Future<void> init() async {
    // await _addCircle();
    // await _addImageAnnotation();
    // await _addPolyline();
    // await _addPolygon();
  }

  Future<void> _addImageAnnotation() async {
    _pointMgr = await map.annotations.createPointAnnotationManager();

    final bytes = await rootBundle.load('assets/images/logo_text.png');
    final imageData = bytes.buffer.asUint8List();

    PointAnnotationOptions pointAnnotationOptions = PointAnnotationOptions(
      geometry: Point(coordinates: Position(12.5683, 55.6761)),
      image: imageData,
      iconSize: 10.0,
      // textField: 'Copenhagen',
      // textOffset: [0, 2],
    );

    _pointMgr?.create(pointAnnotationOptions);
  }

  // Future<void> _addCircle() async {
  //   _circleMgr = await map.annotations.createCircleAnnotationManager();
  //   await _circleMgr!.create(CircleAnnotationOptions(
  //     geometry: Point(coordinates: Position(12.5683, 55.6761)), // Copenhagen
  //     circleRadius: 15.0,
  //     circleColor: secondaryColor.value,
  //     circleOpacity: 1,
  //     circleStrokeColor: primaryColor.value,
  //     circleStrokeWidth: 2.0,
  //   ));
  // }

  // Future<void> _addPolyline() async {
  //   _polylineMgr = await map.annotations.createPolylineAnnotationManager();
  //   await _polylineMgr!.create(PolylineAnnotationOptions(
  //     lineColor: primaryColor.value,
  //     lineWidth: 4.0,
  //     geometry: LineString(coordinates: [
  //       Position(12.6660, 55.6750),
  //       Position(12.6683, 55.6761),
  //       Position(12.6706, 55.6750),
  //     ]),
  //   ));
  // }

  // Future<void> _addPolygon() async {
  //   _polygonMgr = await map.annotations.createPolygonAnnotationManager();
  //   await _polygonMgr!.create(PolygonAnnotationOptions(
  //     fillColor: primaryColor.value,
  //     fillOutlineColor: primaryColor.value,
  //     geometry: Polygon(coordinates: [
  //       [
  //         Position(12.5660, 55.6780),
  //         Position(12.5706, 55.6780),
  //         Position(12.5683, 55.6800),
  //         Position(12.5660, 55.6780),
  //       ]
  //     ]),
  //   ));
  // }

  void dispose() {
    _circleMgr?.deleteAll();
    _polylineMgr?.deleteAll();
    _polygonMgr?.deleteAll();
    _pointMgr?.deleteAll();
    _circleMgr = null;
    _polylineMgr = null;
    _polygonMgr = null;
    _pointMgr = null;
  }
}
