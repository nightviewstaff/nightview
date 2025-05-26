import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/helpers/clubs/club_data_helper.dart';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:provider/provider.dart';

class ClubOverlayController {
  final MapboxMap map;
  final ClubDataHelper clubDataHelper;
  CircleAnnotationManager? _circleMgr;
  PointAnnotationManager? _pointMgr;
  final Map<String, PointAnnotation> annotationMap = {};

  ClubOverlayController(this.map, this.clubDataHelper);

  Future<void> init() async {
    _pointMgr = await map.annotations.createPointAnnotationManager();
    await _addImageAnnotationsForAllClubs();
  }

  Future<void> _addImageAnnotationsForAllClubs() async {
    if (clubDataHelper.clubDataList.value.isEmpty) {
      print("❌ No club data available to show. ❌");
      return;
    }

    // STEP 1: Add local type-based icon markers immediately
    for (final club in clubDataHelper.clubDataList.value) {
      try {
        final assetPath = 'images/club_types/${club.typeOfClub}_icon.png';

        final byteData = await rootBundle.load(assetPath);
        final rawBytes = byteData.buffer.asUint8List();
        final decoded = img.decodeImage(rawBytes);
        if (decoded == null)
          throw Exception("Image decode failed for $assetPath");
        final resized = img.copyResize(decoded, width: 80, height: 80);
        final circular = img.copyCropCircle(resized);
        final imageData = Uint8List.fromList(img.encodePng(circular));

        final annotation = await _pointMgr?.create(PointAnnotationOptions(
          geometry: Point(coordinates: Position(club.lon, club.lat)),
          image: imageData,
          iconSize: 1.0,
          textColor: secondaryColor.value,
          textHaloColor: primaryColor.value,
          textHaloWidth: 1.5,
        ));

        if (annotation != null) {
          annotationMap[club.id] = annotation;
        }
      } catch (e) {
        print("⚠️ Failed to load local asset for club ${club.id}: $e");
      }
    }

    await _unloadRemainingLogos(clubDataHelper.clubDataList.value);
  }

  Future<void> _unloadRemainingLogos(List<ClubData> clubs) async {
    const batchSize = 10;

    for (int i = 0; i < clubs.length; i += batchSize) {
      final batch = clubs.skip(i).take(batchSize);

      await Future.wait(batch.map((club) async {
        if (club.logo.contains('default_logo') ||
            club.logo.contains('club_type_images')) return;

        final existing = annotationMap[club.id];
        if (existing == null) return;

        try {
          final logoData = await fetchNetworkImageBytes(club.logo);

          // Remove existing annotation
          await _pointMgr?.delete(existing);

          // Re-create with updated image
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

    // Resize and circular crop
    final resized = img.copyResize(decodedImage, width: 80, height: 80);
    final circular = img.copyCropCircle(resized);

    return Uint8List.fromList(img.encodePng(circular));
  }

  Future<void> _addCircle() async {
    _circleMgr = await map.annotations.createCircleAnnotationManager();
    await _circleMgr!.create(CircleAnnotationOptions(
      geometry: Point(coordinates: Position(13.5683, 55.6761)), // Copenhagen
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
