import 'dart:async';

import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/models/club_data.dart';
import 'package:nightview/models/club_data_helper.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/screens/night_map/custom_marker_layer.dart';
import 'package:nightview/screens/night_map/night_map_main_offer_screen.dart';
import 'package:nightview/widgets/club_header.dart';
import 'package:nightview/widgets/club_marker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/friends_helper.dart';
import '../../models/user_data.dart';

class NightMap extends StatefulWidget {
  const NightMap({super.key});

  @override
  State<NightMap> createState() => _NightMapState();
}

class _NightMapState extends State<NightMap> {
  ClubDataHelper clubDataHelper = ClubDataHelper();
  Map<String, Marker> markers = {};
  Map<String, Marker> friendMarkers = {};
  StreamSubscription? _friendLocationSubscription;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider
          .of<GlobalProvider>(context, listen: false)
          .locationHelper
          .getCurrentPosition()
          .then((position) {
        Provider
            .of<GlobalProvider>(context, listen: false)
            .nightMapController
            .move(LatLng(position.latitude, position.longitude), kFarMapZoom);
      });

      _listenToFriendLocations();
    });
  }

  @override
  void dispose() {
    _friendLocationSubscription?.cancel();
    super.dispose();
  }

  void _listenToFriendLocations() async {
    final _firestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;

    if (_auth.currentUser == null) {
      return;
    }

    String userId = _auth.currentUser!.uid;
    _friendLocationSubscription = _firestore
        .collection('friends')
        .doc(userId)
        .snapshots()
        .listen((snapshot) async {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data()!;
        List<String> friendIds = data.keys.where((k) => data[k] == true)
            .toList();

        List<UserData> friendsData = [];
        for (String friendId in friendIds) {
          DocumentSnapshot<Map<String, dynamic>> friendSnapshot =
          await _firestore.collection('user_data').doc(friendId).get();
          if (friendSnapshot.exists) {
            friendsData.add(UserData.fromMap(friendSnapshot.data()!));
          }
        }

        setState(() {
          friendMarkers = {
            for (var friend in friendsData)
              friend.id: Marker(
                point: LatLng(friend.lastPositionLat, friend.lastPositionLon),
                width: 80.0,
                height: 100.0,
                builder: (context) =>
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(friend.firstName,
                          style: TextStyle(color: secondaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                          ),
                        ),
                        Icon(
                          Icons.person_pin_circle,
                          color: primaryColor,
                          size: 40.0,
                        ),
                      ],
                    ),)
          };
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Provider
        .of<GlobalProvider>(context)
        .clubDataHelper
        .clubData
        .forEach((id, club) {
      markers[id] = Marker(
        point: LatLng(club.lat, club.lon),
        width: 100.0,
        height: 100.0,
        builder: (context) =>
            ClubMarker(
              logo: CachedNetworkImageProvider(club.logo),
              visitors: club.visitors,
              onTap: () {
                Provider.of<GlobalProvider>(context, listen: false)
                    .setChosenClub(club);
                showClubSheet(club: club);
              },
            ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: Provider
          .of<GlobalProvider>(context)
          .nightMapController,
      options: MapOptions(
        center: LatLng(56.15607303880937, 10.208507572938238),
        zoom: kFarMapZoom,
        maxZoom: kMaxMapZoom,
      ),
      nonRotatedChildren: [
        RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () {
                launchUrl(Uri.parse('https://openstreetmap.org/copyright'));
              },
            )
          ],
        ),
      ],
      children: [
        TileLayer(
          urlTemplate: 'https://a.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.nightview.nightview',
        ),
        CurrentLocationLayer(),
        CustomMarkerLayer(
          rotate: true,
          markers: [...markers.values, ...friendMarkers.values],
        ),
      ],
    );
  }

  void showClubSheet({required ClubData club}) {
    showStickyFlexibleBottomSheet(
      context: context,
      initHeight: 0.35,
      // maybe more?
      minHeight: 0,
      maxHeight: 1,
      // club.offerType == OfferType.none ? 0.3 : 1,
      headerHeight: 315,
      isSafeArea: false,
      bottomSheetColor: Colors.transparent,
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      headerBuilder: (context, offset) =>
          ClubHeader(
            club: club,
          ),
      bodyBuilder: (context, offset) =>
          SliverChildListDelegate(
            club.offerType == OfferType.none
                ? []
                : [
              Container(
                alignment: Alignment.topCenter,
                child: Text(
                  'Hovedtilbud',
                  style: kTextStyleH1,
                ),
              ),
              SizedBox(
                height: kNormalSpacerValue,
              ),
              GestureDetector(
                onTap: () {
                  if (club.offerType == OfferType.redeemable) {
                    Navigator.of(context)
                        .pushNamed(NightMapMainOfferScreen.id);
                  }
                },
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(club.mainOfferImg!),
                        fit: BoxFit.cover,
                      ),
                    ),
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.all(kMainPadding),
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
