import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';

/// CustomMarkerLayer: Displays all markers, including those off-screen.
class CustomMarkerLayer extends MarkerLayer {
  @override
  final List<Marker> markers;
  @override
  final bool rotate;
  final Offset? rotateOrigin;
  final AlignmentGeometry rotateAlignment;

  const CustomMarkerLayer({
    super.key,
    required this.markers,
    this.rotate = false,
    this.rotateOrigin,
    this.rotateAlignment = Alignment.center,
  }) : super(markers: markers);

  @override
  Widget build(BuildContext context) {
    final mapState = MapCamera.of(context);
    final markerWidgets = <Widget>[];

    for (final marker in markers) {
      final markerWidth = marker.width ?? 1.0;
      final markerHeight = marker.height ?? 1.0;

      // Calculate the projected position of the marker
      final pxPoint = mapState.latLngToScreenPoint(marker.point);

      // Convert Point to Offset
      final pos = Offset(pxPoint.x, pxPoint.y);

      // Skip rotation logic to ensure markers are fixed
      markerWidgets.add(
        Positioned(
          key: marker.key,
          width: markerWidth,
          height: markerHeight,
          left: pos.dx - markerWidth / 2,
          top: pos.dy - markerHeight / 2,
          child: marker.child,
        ),
      );
    }
    return Stack(children: markerWidgets);
  }
}
