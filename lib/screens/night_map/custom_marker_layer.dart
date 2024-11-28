import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math';

// THIS IS COPIED FROM MARKER_LAYER BY FLUTTER_MAP
// ONLY THING DIFFERENT IS, IT DISPLAYS ALL MARKERS, ALSO THOSE NOT ON SCREEN

class CustomMarkerLayer extends MarkerLayer {
  final List<Marker> markers;
  final bool rotate;
  final Offset? rotateOrigin;
  final AlignmentGeometry rotateAlignment;

  const CustomMarkerLayer({
    Key? key,
    required this.markers,
    this.rotate = false,
    this.rotateAlignment = Alignment.center,
    this.rotateOrigin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final map = MapOptions.of(context);
    final markerWidgets = <Widget>[];

    for (final marker in markers) {
      // Find the position of the point on the screen
      final pxPoint = map.project(marker.point);

      // See if any portion of the Marker rect resides in the map bounds
      // If not, don't spend any resources on build function.
      // This calculation works for any Anchor position whithin the Marker
      // Note that Anchor coordinates of (0,0) are at bottom-right of the Marker
      // unlike the map coordinates.
      final rightPortion = marker.width - marker.anchor.left;
      final leftPortion = marker.anchor.left;
      final bottomPortion = marker.height - marker.anchor.top;
      final topPortion = marker.anchor.top;

        final markerWidget = widget.rotate
            ?? Transform.rotate(
          angle: 0, // Adjust for rotation
          origin: rotateOrigin,
          alignment: rotateAlignment,
          child: marker.child,
        )
            : marker.child;

      markerWidgets.add(
        Positioned(
          key: marker.key,
          width: marker.width,
          height: marker.height,
          left: projectedPoint.dx - (marker.width / 2),
          top: projectedPoint.dy - (marker.height / 2),
          child: markerWidget,
        ),
      );
    }
    return Stack(
      children: markerWidgets.toList()
    );
  }
}
