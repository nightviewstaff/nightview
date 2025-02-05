import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/helpers/clubs/club_data_helper.dart';
import 'package:nightview/locations/location_service.dart';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/providers/night_map_provider.dart';
import 'package:nightview/screens/clubs/club_bottom_sheet.dart';
import 'package:nightview/screens/night_map/custom_marker_layer.dart';
import 'package:nightview/widgets/icons/bar_type_toggle.dart';
import 'package:nightview/widgets/stateless/club_marker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/users/user_data.dart';

class NightMap extends StatefulWidget {
  const NightMap({super.key});

  @override
  State<NightMap> createState() => NightMapState();
}

class NightMapState extends State<NightMap> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // ✅ Keeps it alive when switching tabs

  ClubDataHelper clubDataHelper = ClubDataHelper();

  // Map<String, Marker> markers = {};
  // Map<String, Marker> friendMarkers = {};

  final ValueNotifier<Map<String, Marker>> _markersNotifier = ValueNotifier({});
  final ValueNotifier<Map<String, Marker>> _friendMarkersNotifier =
      ValueNotifier({});
  StreamSubscription? _friendLocationSubscription; // what is this?

  @override
  void initState() {
    // How often is init called?
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final clubDataHelper =
          Provider.of<NightMapProvider>(context, listen: false).clubDataHelper;
      await clubDataHelper.loadClubsOnce(); // Ensure clubs are loaded first
      _initializeUserLocation();
      _initializeMarkers();
    });
  }

  void _initializeUserLocation() async {
    final position = await Provider.of<NightMapProvider>(context, listen: false)
        .locationHelper
        .getCurrentPosition();

    Provider.of<NightMapProvider>(context, listen: false)
        .nightMapController
        .move(LatLng(position.latitude, position.longitude), kFarMapZoom);
  }

  void _initializeMarkers() {
    final clubDataHelper =
        Provider.of<NightMapProvider>(context, listen: false).clubDataHelper;
    print("${clubDataHelper.clubData.values} + !!!!!");
    _markersNotifier.value = {
      for (var club in clubDataHelper.clubData.values)
        club.id: _buildClubMarker(club)
    };
  }

  void updateMarkers() {
    final toggledStates = BarTypeMapToggle.toggledStates;
    final clubDataHelper =
        Provider.of<NightMapProvider>(context, listen: false).clubDataHelper;
    _markersNotifier.value = {
      for (var club in clubDataHelper.clubData.values)
        if (toggledStates[club.typeOfClub] ?? true)
          club.id: _buildClubMarker(club)
    };
  }

  Marker _buildClubMarker(ClubData club) {
    // TODO find good place for this (other class)
    return Marker(
      point: LatLng(club.lat, club.lon),
      width: 100.0,
      height: 100.0,
      child: ClubMarker(
        logo: CachedNetworkImageProvider(club.logo),
        visitors: club.visitors,
        onTap: () {
          // TODO better visual when clickiung at some point
          ClubBottomSheet.showClubSheet(context: context, club: club);
        },
      ),
    );
  }

  @override
  void dispose() {
    //TODO who calls dispose and what does it do?
    _friendLocationSubscription?.cancel();
    _markersNotifier.dispose();
    _friendMarkersNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAlive
    final nightMapProvider =
        Provider.of<NightMapProvider>(context, listen: false);

    return FlutterMap(
      mapController: nightMapProvider.nightMapController,
      options: MapOptions(
        initialCenter: LatLng(55.6761, 12.5683), // Copenhagen coordinates
        initialZoom: kFarMapZoom, // Adjust the zoom level as needed
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://a.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.nightview.nightview',
          // tileProvider:
        ),
        CurrentLocationLayer(),
        ValueListenableBuilder<Map<String, Marker>>(
          // Updates markers without rebuilding the entire map.
          valueListenable: _markersNotifier,

          builder: (context, markers, child) {
            return CustomMarkerLayer(
              rotate: true,
              markers: [...markers.values],
              // , ..._friendMarkersNotifier.value.values],
            );
          },
        ),
        RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () {
                launchUrl(Uri.parse('https://openstreetmap.org/copyright'));
              },
            ),
          ],
        ),
      ],
    );
  }
}
