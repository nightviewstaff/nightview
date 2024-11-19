import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math';

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

class _CustomMarkerLayerState extends State<CustomMarkerLayer> {
  @override
  Widget build(BuildContext context) {
    final map = MapOptions.of(context);

    return Stack(
      children: widget.markers.map((marker) {
        final projectedPoint =
        _project(marker.point, map.initialCenter, map.initialZoom);

        final markerWidget = widget.rotate
            ? Transform.rotate(
          angle: 0, // Adjust for rotation
          origin: widget.rotateOrigin,
          alignment: widget.rotateAlignment,
          child: marker.child,
        )
            : marker.child;

        debugPrint('Projected position: $projectedPoint');

        return Positioned(
          key: marker.key,
          width: marker.width,
          height: marker.height,
          left: projectedPoint.dx - (marker.width / 2),
          top: projectedPoint.dy - (marker.height / 2),
          child: markerWidget,
        );
      }).toList(),
    );
  }

  Offset _project(LatLng point, LatLng center, double zoom) {
    const double scale = 256; // Base tile size for Mercator projection
    final double worldSize = scale * (1 << zoom.toInt());

    // Convert LatLng to world coordinates
    final double x = ((point.longitude + 180) / 360) * worldSize;
    final double y = ((1 -
        (log(tan(point.latitude * pi / 180) + 1 / cos(point.latitude * pi / 180)) /
            pi)) /
        2) *
        worldSize;

    // Center offset
    final double centerX = ((center.longitude + 180) / 360) * worldSize;
    final double centerY = ((1 -
        (log(tan(center.latitude * pi / 180) + 1 / cos(center.latitude * pi / 180)) /
            pi)) /
        2) *
        worldSize;

    return Offset(x - centerX + (scale / 2), y - centerY + (scale / 2));
  }
}
