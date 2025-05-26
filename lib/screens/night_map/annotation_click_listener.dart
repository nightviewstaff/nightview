import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:nightview/helpers/clubs/club_data_helper.dart';
import 'package:nightview/screens/clubs/club_bottom_sheet.dart';

class AnnotationClickListener implements OnPointAnnotationClickListener {
  final MapboxMap map;
  final ClubDataHelper clubDataHelper;
  final Map<String, PointAnnotation> annotationMap;
  final BuildContext context;

  AnnotationClickListener(
      this.map, this.clubDataHelper, this.annotationMap, this.context);

  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    try {
      final entry = annotationMap.entries
          .firstWhere((entry) => entry.value.id == annotation.id);
      final clubId = entry.key;
      final club = clubDataHelper.clubData[clubId];

      if (club != null) {
        ClubBottomSheet.showClubSheet(
          context: context,
          club: club,
        );
      }
    } catch (e) {
      print("⚠️ No club found for tapped annotation: ${annotation.id}");
    }
  }
}
