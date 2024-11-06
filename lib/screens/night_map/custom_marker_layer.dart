import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';


// THIS IS COPIED FROM MARKER_LAYER BY FLUTTER_MAP
// ONLY THING DIFFERENT IS, IT DISPLAYS ALL MARKERS, ALSO THOSE NOT ON SCREEN

class CustomMarkerLayer extends StatelessWidget {
  final List<Marker> markers;
  final bool rotate;
  final Offset? rotateOrigin;
  final AlignmentGeometry rotateAlignment;


  CustomMarkerLayer({
    Key? key,
    this.markers = const [],
    this.rotate = false,
    this.rotateOrigin,
    this.rotateAlignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapState = MapCamera.of(context);
    final markerWidgets = <Widget>[];

    for (final marker in markers) {
      final pxPoint = mapState.project(marker.point);

      // Position the marker assuming it's centered
      final pos = pxPoint - mapState.pixelOrigin;
      final left = pos.x - marker.width / 2;
      final top = pos.y - marker.height / 2;

      // This part was originally used for flicker prevention by checking bounds,
      // but it has been disabled here to ensure all markers are displayed.
      // You can uncomment and modify it if you want bounds checking:
      // final sw = CustomPoint(left, top + marker.height);
      // final ne = CustomPoint(left + marker.width, top);
      // if (!map.pixelBounds.containsPartialBounds(Bounds(sw, ne))) {
      //   continue;
      // }

      final markerWidget = (marker.rotate ?? rotate)
      // Counter rotated marker to the map rotation
          ? Transform.rotate(
        angle: -mapState.rotationRad,
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
          left: left,
          top: top,
          child: markerWidget,
        ),
      );
    }

    // Stack all markers
    return Stack(
      children: markerWidgets,
    );
  }
}
