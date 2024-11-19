import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// THIS IS COPIED FROM MARKER_LAYER BY FLUTTER_MAP
// ONLY THING DIFFERENT IS, IT DISPLAYS ALL MARKERS, ALSO THOSE NOT ON SCREEN

class CustomMarkerLayer extends StatefulWidget {
  final List<Marker> markers;
  final bool rotate;
  final AlignmentGeometry rotateAlignment;
  final Offset? rotateOrigin;

  const CustomMarkerLayer({
    Key? key,
    required this.markers,
    this.rotate = false,
    this.rotateAlignment = Alignment.center,
    this.rotateOrigin,
  }) : super(key: key);

  @override
  _CustomMarkerLayerState createState() => _CustomMarkerLayerState();
  }

  class _CustomMarkerLayerState extends State<CustomMarkerLayer>{
  @override
  Widget build(BuildContext context) {
    final map = MapOptions.of(context);
    // final mapState = FlutterMapState.maybeOf(context)!; Potential fix
    // final markerWidgets = <Widget>[];
    return Stack(
      children: widget.markers.map((marker) {
        final projectedPoint =
            _project(marker.point, map.initialCenter, map.initialZoom);

        final markerWidget = widget.rotate
            ? Transform.rotate(
                angle: 0, // Rotation.
                origin: widget.rotateOrigin,
                alignment: widget.rotateAlignment,
                child: marker.child,
              )
            : marker.child;

        return Positioned(
          key: marker.key,
          width: marker.width,
          height: marker.height,
          left: projectedPoint.dx - (marker.width / 2), // Just for now.
          top: projectedPoint.dy - (marker.height / 2), // :--:
          child: markerWidget,
        );
      }).toList(),
    );
  }

  Offset _project(LatLng point, LatLng center, double zoom) {
    const scale = 256.0;
    final worldSize = scale * (1 << zoom.toInt());
    final x = (point.longitude + 180.0) / 360 * worldSize;
    final y = (1 - (point.latitude + 90.0) / 180.0) * worldSize / 2.0;

    return Offset(x, y);
  }
}
