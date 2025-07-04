import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/helpers/clubs/club_data_helper.dart';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:nightview/screens/clubs/club_bottom_sheet.dart';
import 'package:nightview/screens/night_map/annotation_click_listener.dart';
import 'package:nightview/utilities/club_data/club_age_restriction_formatter.dart';
import 'package:nightview/utilities/club_data/club_opening_hours_formatter.dart';

class ClubOverlayController {
  final MapboxMap map;
  final ClubDataHelper clubDataHelper;
  CircleAnnotationManager? _circleMgr;
  PointAnnotationManager? _pointMgr;
  final Map<String, PointAnnotation> annotationMap = {};
  final BuildContext context;
  bool _isBottomSheetOpen = false;

  ClubOverlayController(this.map, this.clubDataHelper, this.context);

  Future<void> init() async {
    _pointMgr = await map.annotations.createPointAnnotationManager();
    _pointMgr?.addOnPointAnnotationClickListener(
      AnnotationClickListener(map, clubDataHelper, annotationMap, context),
    );
    await _addImageAnnotationsForAllClubs();
  }

  bool get isBottomSheetOpen => _isBottomSheetOpen;

  // Method to update the bottom sheet state
  void setBottomSheetOpen(bool isOpen) {
    _isBottomSheetOpen = isOpen;
  }

  Future<void> _addImageAnnotationsForAllClubs() async {
    if (clubDataHelper.clubDataList.value.isEmpty) {
      print("❌ No club data available to show. ❌");
      return;
    }

    for (final club in clubDataHelper.clubDataList.value) {
      try {
        final assetPath = 'images/club_types/${club.typeOfClub}_icon.png';

        final byteData = await rootBundle.load(assetPath);
        final rawBytes = byteData.buffer.asUint8List();
        final decoded = img.decodeImage(rawBytes);
        if (decoded == null)
          throw Exception("Image decode failed for $assetPath");
        final resized = img.copyResize(decoded, width: 100, height: 100);
        final circular = img.copyCropCircle(resized);
        final imageData = Uint8List.fromList(img.encodePng(circular));

        final mainAnnotation = await _pointMgr?.create(PointAnnotationOptions(
          geometry: Point(coordinates: Position(club.lon, club.lat)),
          image: imageData,
          iconSize: 1.0,
          textColor: secondaryColor.value,
          textHaloColor: ClubOpeningHoursFormatter.isClubOpen(club)
              ? primaryColor.value
              : redAccent.value,
          textHaloWidth: 1.0,
          textField:
              "${club.typeOfClubImg}     ${ClubOpeningHoursFormatter.displayClubOpeningHoursTodaySimple(club)}  ${ClubAgeRestrictionFormatter.displayClubAgeRestrictionFormattedShort(club)}",
          textAnchor: TextAnchor.TOP,
          textOffset: [0, 2.0],
        ));

        if (mainAnnotation != null) {
          annotationMap[club.id] = mainAnnotation;
        }

        // 🔥 Add flame icon if crowded
        double ratio = club.totalPossibleAmountOfVisitors == 0
            ? 0
            : club.visitors / club.totalPossibleAmountOfVisitors;

        String? flameAsset;
        if (ratio >= 0.95) {
          flameAsset = 'images/effects/flame_large.png';
        } else if (ratio >= 0.85) {
          flameAsset = 'images/effects/flame_medium.png';
        } else if (ratio >= 0.7) {
          flameAsset = 'images/effects/flame_small.png';
        }

        if (flameAsset != null) {
          final flameData = await rootBundle.load(flameAsset);
          final flameBytes = flameData.buffer.asUint8List();
          final flameDecoded = img.decodeImage(flameBytes);
          if (flameDecoded == null)
            throw Exception("Flame decode failed for $flameAsset");
          final flameResized =
              img.copyResize(flameDecoded, width: 70, height: 70);
          final flamePng = Uint8List.fromList(img.encodePng(flameResized));

          await _pointMgr?.create(PointAnnotationOptions(
            geometry: Point(coordinates: Position(club.lon, club.lat)),
            image: flamePng,
            iconSize: 1.0,
            iconAnchor: IconAnchor.BOTTOM,
            iconOffset: [0, -55], // Position flame above club icon
          ));
        }
      } catch (e) {
        print("⚠️ Failed to process club ${club.id}: $e");
      }
    }

    await _unloadRemainingLogos(clubDataHelper.clubDataList.value);
  }

  Future<void> _unloadRemainingLogos(List<ClubData> clubs) async {
    const batchSize = 20;

    for (int i = 0; i < clubs.length; i += batchSize) {
      final batch = clubs.skip(i).take(batchSize);

      await Future.wait(batch.map((club) async {
        // if (club.logo.contains('default_logo') ||
        //     club.logo.contains('club_type_images')) return;
// TODO check
        final existing = annotationMap[club.id];
        if (existing == null) return;

        try {
          final logoData = await fetchNetworkImageBytes(club.logo);

          await _pointMgr?.delete(existing);

          final newAnnotation = await _pointMgr?.create(PointAnnotationOptions(
            geometry: existing.geometry,
            image: logoData,
            iconSize: existing.iconSize,
            textColor: existing.textColor,
            textHaloColor: existing.textHaloColor,
            textHaloWidth: existing.textHaloWidth,
          ));

          if (newAnnotation != null) {
            annotationMap[club.id] = newAnnotation;
          }
        } catch (e) {
          print("⚠️ Failed to update logo for club ${club.id}: $e");
        }
      }));

      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  Future<Uint8List> fetchNetworkImageBytes(String url) async {
    final response = await NetworkAssetBundle(Uri.parse(url)).load('');
    final originalBytes = response.buffer.asUint8List();

    final decodedImage = img.decodeImage(originalBytes);
    if (decodedImage == null) {
      throw Exception("Failed to decode image");
    }

    final resized = img.copyResize(decodedImage, width: 80, height: 80);
    final circular = img.copyCropCircle(resized);

    return Uint8List.fromList(img.encodePng(circular));
  }

  Future<void> _addCircle() async {
    _circleMgr = await map.annotations.createCircleAnnotationManager();
    await _circleMgr!.create(CircleAnnotationOptions(
      geometry: Point(coordinates: Position(13.5683, 55.6761)),
      circleRadius: 15.0,
      circleColor: secondaryColor.value,
      circleOpacity: 1,
      circleStrokeColor: primaryColor.value,
      circleStrokeWidth: 2.0,
    ));
  }

  void dispose() {
    _circleMgr?.deleteAll();
    _pointMgr?.deleteAll();
    _circleMgr = null;
    _pointMgr = null;
  }
}
