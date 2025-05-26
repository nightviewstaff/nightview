// import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
// import 'package:nightview/helpers/clubs/club_data_helper.dart';
// import 'package:nightview/models/clubs/club_data.dart';
// import 'package:nightview/screens/night_map/overlay_manager.dart';

// class ClubOverlayManager extends OverlayManager<ClubData> {
//   final ClubDataHelper helper;

//   ClubOverlayManager(MapboxMap map, this.helper, Function(ClubData) onTap)
//       : super(map, onTap);

//   @override
//   Future<void> init() async {
//     manager = await map.annotations.createPointAnnotationManager();
//     manager?.addOnPointAnnotationClickListener((annotation) {
//       final club = helper.clubDataList.value.firstWhere(
//         (c) => c.id == annotation.id,
//         orElse: () => null,
//       );
//       if (club != null) onTap(club);
//     });
//     helper.clubDataList.addListener(refreshMarkers);
//     await refreshMarkers();
//   }

//   Future<void> refreshMarkers() async {
//     await manager?.deleteAll();
//     for (var club in helper.clubDataList.value) {
//       final key = 'club_${club.id}';
//       if (!loadedIcons.containsKey(key)) {
//         final bytes = await _getIconForClub(club); // Your existing logic
//         await map.style.addImage(key, bytes);
//         loadedIcons[key] = bytes;
//       }
//       await manager?.create(PointAnnotationOptions(
//         id: club.id,
//         geometry: Point(coordinates: Position(club.lon, club.lat)),
//         iconImage: key,
//         iconSize: 0.8,
//         textField: club.name,
//         textOffset: [0, 1.2],
//       ));
//     }
//   }

//   @override
//   Future<void> update(List<ClubData> items) async {
//     helper.clubDataList.value = items;
//     await refreshMarkers();
//   }

//   @override
//   void dispose() {
//     helper.clubDataList.removeListener(refreshMarkers);
//     manager?.deleteAll();
//     manager = null;
//   }
// }
