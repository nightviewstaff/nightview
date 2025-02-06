import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:nightview/helpers/users/misc/location_helper.dart';
import 'package:nightview/models/clubs/club_visit.dart';
import 'package:nightview/providers/night_map_provider.dart';
import 'package:nightview/screens/night_map/night_map.dart';

class ClubDataHelper with ChangeNotifier{
  final _firestore = FirebaseFirestore.instance;
  final _storageRef = FirebaseStorage.instance.ref();

  Map<String, ClubData> clubData = {};
  Map<String, ClubData> clubMarkerData = {};
  final StreamController<ClubData> _initialLoadController = StreamController.broadcast();

  Stream<ClubData> get initialClubStream => _initialLoadController.stream;

  final bool _isLoaded = false; // Prevents multiple loads
  final ValueNotifier<int> remainingNearbyClubsNotifier = ValueNotifier(0);
  final ValueNotifier<int> remainingClubsNotifier = ValueNotifier(0);



  Future<void> loadInitialClubs() async {
    // Step 1: Get user's current location
    Position userPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final snapshot = await _firestore.collection('club_data').get();

    // Step 2: Initialize the total count for remaining clubs
    remainingClubsNotifier.value = snapshot.docs.length;

    // Step 3: Process all clubs concurrently
    final tasks = snapshot.docs.map((doc) async {
      final data = doc.data();
      final lat = data['lat'];
      final lon = data['lon'];

      // Calculate distance once
      final distance = Geolocator.distanceBetween(
          userPosition.latitude, userPosition.longitude, lat, lon);

      // Check if within 50 km
      final isNearby = distance <= 50000;

      final club = await _processClub(doc);
      if (club != null) {
        clubMarkerData[club.id] = club;
        _initialLoadController.add(club);

        // Update counts using notifiers
        remainingClubsNotifier.value--;
        if (isNearby) remainingNearbyClubsNotifier.value--;
      }
    }).toList();

    // Wait for all tasks to complete
    await Future.wait(tasks);
  }


  ClubDataHelper({Callback<Map<String, ClubData>>? onReceive}) {
    _firestore.collection('club_data').snapshots().listen((snap) {
      print("🔄 Firestore updated: Processing only changed clubs...");

      for (var club in snap.docChanges) {
        switch (club.type) {
          case DocumentChangeType.added:
          case DocumentChangeType.modified:
            // _processClub(club.doc); // ✅ Update only the changed club
            break;
          case DocumentChangeType.removed:
            clubData.remove(club.doc.id); // ✅ Remove deleted club
            break;
        }
      }
    });
  }

  Future<ClubData?> _processClub(QueryDocumentSnapshot<Map<String, dynamic>> club) async {
    try {
      final data = club.data();

      // Skip if no meaningful changes
      if (clubData.containsKey(club.id)) {
        final existingClub = clubData[club.id]!;
        bool hasChanged = existingClub.name != data['name'] ||
            existingClub.rating != data['rating'] ||
            existingClub.visitors != data['visitors'] ||
            existingClub.logo != data['logo'];

        if (!hasChanged) {
          print("✅ No changes detected for ${club.id}, skipping update.");
          return null;
        }
      }

      // Parse opening hours
      final openingHours = (data['opening_hours'] as Map<String, dynamic>?)
          ?.map((day, hours) {
        return MapEntry(day, {
          'open': hours?['open']?.toString() ?? '20:00',
          'close': hours?['close']?.toString() ?? '02:00',
          'ageRestriction': hours?['ageRestriction'] ?? data['age_restriction'] ?? 0,
        });
      }) ??
          {};

      // Fetch typeOfClub image URL
      final typeOfClubImageUrl = await _fetchStorageUrl(
        '/nightview_images/club_type_images/${data['type_of_club']}_icon.png',
        fallback: "null",
      );

      // Prepare parallel network requests with fallback for the logo
      final fetchUrls = [
        (data['logo'] != 'default_logo.png')
            ? _fetchStorageUrl(
            'club_logos/${data['logo']}', fallback: typeOfClubImageUrl)
            : Future.value(typeOfClubImageUrl),
        (stringToOfferType(data['offer_type'] ?? '') != OfferType.none)
            ? _fetchStorageUrl('main_offers/${data['main_offer_img']}', fallback: '')
            : Future.value(null),
      ];

      // Fetch all URLs concurrently
      final urls = await Future.wait(fetchUrls);
      final logoUrl = urls[0] as String;
      final mainOfferImgUrl = urls[1] as String?;

      // Parse corners
      final corners = (data['corners'] as List?)
          ?.whereType<GeoPoint>()
          .map((point) => {'latitude': point.latitude, 'longitude': point.longitude})
          .toList() ??
          [];

      // Create and return the ClubData object
      return ClubData(
        id: club.id,
        name: data['name'],
        logo: logoUrl,
        lat: data['lat'],
        lon: data['lon'],
        favorites: List<String>.from(data['favorites'] ?? []),
        corners: corners,
        offerType: stringToOfferType(data['offer_type'] ?? 'OfferType.none') ?? OfferType.none,
        mainOfferImg: mainOfferImgUrl,
        ageRestriction: data['age_restriction'] ?? 0,
        typeOfClubImg: typeOfClubImageUrl,
        typeOfClub: data['type_of_club'] ?? '',
        rating: data['rating'] ?? 0.0,
        openingHours: openingHours,
        visitors: data['visitors'] ?? 0,
        totalPossibleAmountOfVisitors: data['total_possible_amount_of_visitors'] ?? 0,
      );
    } catch (e) {
      print('❌ Error processing club ${club.id}: $e');
      return null;
    }
  }

// Helper function to fetch URLs with a fallback
  Future<String> _fetchStorageUrl(String path, {required String fallback}) async {
    try {
      return await _storageRef.child(path).getDownloadURL();
    } catch (e) {
      print('⚠️ Error fetching storage URL for $path: $e. Returning fallback.');
      return fallback;
    }
  }

  void setFavoriteClub(String clubId, String userId) async {
    DocumentSnapshot<Map<String, dynamic>> clubDocument =
        await _firestore.collection('club_data').doc(clubId).get();
    List<dynamic> favoritesList = clubDocument.data()!['favorites'];

    if (favoritesList.contains(userId)) {
      return;
    }

    favoritesList.add(userId);

    _firestore.collection('club_data').doc(clubId).update({
      'favorites': favoritesList,
    });
  }

  void removeFavoriteClub(String clubId, String userId) async {
    DocumentSnapshot<Map<String, dynamic>> clubDocument =
        await _firestore.collection('club_data').doc(clubId).get();
    List<dynamic> favoritesList = clubDocument.data()!['favorites'];

    if (!favoritesList.contains(userId)) {
      return;
    }

    favoritesList.remove(userId);

    _firestore.collection('club_data').doc(clubId).update({
      'favorites': favoritesList,
    });
  }

  // updates club_visits in Firestore
  Future<void> updateVisitCount(String userId, String clubId) async {
    final clubVisitRef = FirebaseFirestore.instance
        .collection('club_visits')
        .doc('$userId-$clubId');
    final clubVisitDoc = await clubVisitRef.get();

    if (clubVisitDoc.exists) {
      // Document exists, increment the visit count
      final clubVisit = ClubVisit.fromMap(clubVisitDoc.data()!);
      clubVisit.visitCount += 1;
      await clubVisitRef.update({'times_visited': clubVisit.visitCount});
    } else {
      // Document does not exist, create a new one with visit count of 1
      final clubVisit =
          ClubVisit(userId: userId, clubId: clubId, visitCount: 1);
      await clubVisitRef.set(clubVisit.toMap());
    }

    // Check if there is a location_data document with latest: true and timestamp within the last 24 hours
    final now = Timestamp.now();
    final yesterday = Timestamp.fromMillisecondsSinceEpoch(
        now.millisecondsSinceEpoch - 86400000);

    final locationDataQuery = await FirebaseFirestore.instance
        .collection('location_data')
        .where('user_id', isEqualTo: userId)
        .where('club_id', isEqualTo: clubId)
        .where('latest', isEqualTo: true)
        .where('timestamp', isGreaterThanOrEqualTo: yesterday)
        .get();

    //need a for loop here?
    if (locationDataQuery.docs.isNotEmpty) {
      // If there is such a document, update aggregated data in club_data
      await _updateClubData(clubId, userId,
          clubVisitDoc.exists ? clubVisitDoc.data()!['times_visited'] + 1 : 1);
    }
  }

  // prompts updateVisitCount (club_visits in Firestore) TODO Think about LocationHelper here
  Future<void> evaluateVisitors() async {
    // Fetch all documents from the 'location_data' collection
    QuerySnapshot locationDataSnapshot =
        await _firestore.collection('location_data').get();

    for (var locationDoc in locationDataSnapshot.docs) {
      // Check if the 'processed' field exists, if not, add it and set it to false
      final data = locationDoc.data() as Map<String, dynamic>;
      bool processed = data['processed'] ?? false;

      if (!data.containsKey('processed') || data['processed'] == null) {
        await locationDoc.reference.update({'processed': false});
      }

      // If the document is not processed, process it
      if (!processed) {
        String userId = data['user_id'];
        String clubId = data['club_id'];

        // Check if 'user_id' and 'club_id' fields exist before processing
        // Update the 'club_visits' collection
        await updateVisitCount(userId, clubId);

        // Mark the document as processed
        await locationDoc.reference.update({'processed': true});
            }
    }
  }

  // Updates club_data in Firestore
  Future<void> _updateClubData(
      String clubId, String userId, int visitCount) async {
    final clubDataRef = _firestore.collection('club_data').doc(clubId);
    final clubDataDoc = await clubDataRef.get();

    if (clubDataDoc.exists) {
      final clubData = clubDataDoc.data()!;

      // Ensure the fields exist and initialize them if they don't
      int firstTimeVisitors = clubData.containsKey('first_time_visitors')
          ? clubData['first_time_visitors']
          : 0;
      int returningVisitors = clubData.containsKey('returning_visitors')
          ? clubData['returning_visitors']
          : 0;
      int regularVisitors = clubData.containsKey('regular_Visitors')
          ? clubData['regular_Visitors']
          : 0;
      String ageOfVisitors = clubData.containsKey('age_of_visitors')
          ? clubData['age_of_visitors']
          : "";
      int visitors =
          clubData.containsKey('visitors') ? clubData['visitors'] : 0;

      if (visitCount == 1) {
        firstTimeVisitors += 1;
      } else if (visitCount > 1 && visitCount < 5) {
        returningVisitors += 1;
      } else if (visitCount >= 5) {
        regularVisitors += 1;
      }

      // Append the age of the current user
      final userDoc =
          await _firestore.collection('user_data').doc(userId).get();
      if (userDoc.exists) {
        final userData = userDoc.data()!;
        if (userData['birthday_year'] != null) {
          num age = DateTime.now().year - userData['birthday_year'];

          ageOfVisitors += "$age, ";

          visitors = firstTimeVisitors + returningVisitors + regularVisitors;

          await clubDataRef.update({
            'visitors': visitors,
            'first_time_visitors': firstTimeVisitors,
            'returning_visitors': returningVisitors,
            'regular_visitors': regularVisitors,
            'age_of_visitors': ageOfVisitors,
          });
        }
      }
    }
    // Maybe put in a different method TODO
    await calculateAndUpdatePeakHours(clubId);
  }

  Future<void> resetClubData() async {
    // initializeWorkManager()
    //TODO needs to be done every day
    QuerySnapshot clubDataSnapshot =
        await _firestore.collection('club_data').get();

    for (var clubDoc in clubDataSnapshot.docs) {
      await clubDoc.reference.update({
        'visitors': 0,
        'first_time_visitors': 0,
        'returning_visitors': 0,
        'regular_visitors': 0,
        'age_of_visitors': "",
      });
    }
  }

  Future<void> calculateAndUpdatePeakHours(String clubId) async {
    // Maybe only do a couple of times a week?
    // Fetch all documents from the 'location_data' collection for the specific club
    QuerySnapshot locationDataSnapshot = await _firestore
        .collection('location_data')
        .where('club_id', isEqualTo: clubId)
        .get();

    // Map to track hourly visits for the club
    Map<int, int> hourlyVisits = {};

    for (var locationDoc in locationDataSnapshot.docs) {
      DateTime timestamp = (locationDoc['timestamp'] as Timestamp).toDate();
      int hour = timestamp.hour;

      // Increment the visitor count for the current hour
      hourlyVisits[hour] = (hourlyVisits[hour] ?? 0) + 1;
    }

    // Identify and store the peak hour for the club
    int peakHours =
        hourlyVisits.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    final clubDataRef = _firestore.collection('club_data').doc(clubId);
    await clubDataRef.update({
      'peak_hours': peakHours,
    });
  }

//TODO upgrade calculatePeakHours:
//   Future<void> calculateAndUpdatePeakHours(String clubId) async {
//     Fetch all documents from the 'location_data' collection for the specific club
  // QuerySnapshot locationDataSnapshot = await FirebaseFirestore.instance
  //     .collection('location_data')
  //     .where('club_id', isEqualTo: clubId)
  //     .get();
  //
  // Map to track hourly visits for the club
  // Map<int, int> hourlyVisits = {};

  // for (var locationDoc in locationDataSnapshot.docs) {
  //   DateTime timestamp = (locationDoc['timestamp'] as Timestamp).toDate();
  //   int hour = timestamp.hour;
  //
  //   Increment the visitor count for the current hour
  // hourlyVisits[hour] = (hourlyVisits[hour] ?? 0) + 1;
  // }
  //
  // Identify and store the top 3 peak hours for the club
  // List<int> top3Hours = hourlyVisits.entries
  //     .toList()
  //     .sort((a, b) => b.value.compareTo(a.value))  // Sort by number of visits, descending
  //     .take(3)  // Take the top 3 hours
  //     .map((entry) => entry.key)
  //     .toList();
  //
  // Format the top 3 peak hours as HH-HH
  // String formattedPeakHours = top3Hours.map((hour) => hour.toString().padLeft(2, '0')).join('-');
  //
  // Update Firestore with the formatted peak hours
  // final clubDataRef = FirebaseFirestore.instance.collection('club_data').doc(clubId);
  // await clubDataRef.update({
  //   'peakHours': formattedPeakHours,
  // });
  // }

  // Not needed for now
  // final DateTime timeTreshhold = DateTime.now().subtract(Duration(hours: 1));
  //
  // clubData.forEach((clubId, clubData) async {
  // AggregateQuerySnapshot snap = await _firestore
  //     .collection('location_data')
  //     .where('club_id', isEqualTo: clubId)
  //     .where('latest', isEqualTo: true)
  //     .where('timestamp', isGreaterThan: Timestamp.fromDate(timeTreshhold))
  //     .count()
  //     .get();
  // clubData.visitors = snap.count;
  // });

  OfferType? stringToOfferType(String str) {
    switch (str) {
      case 'OfferType.none':
        return OfferType.none;
      case 'OfferType.alwaysActive':
        return OfferType.alwaysActive;
      case 'OfferType.redeemable':
        return OfferType.redeemable;
      default:
        return null;
    }
  }

  Future<void> deleteDataAssociatedTo(String userId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('club_data').get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> club in snapshot.docs) {
      final String clubId = club.id;
      final favoritesData = club.get('favorites');

      if (!favoritesData.contains(userId)) {
        continue;
      }

      favoritesData.remove(userId);

      _firestore.collection('club_data').doc(clubId).update({
        'favorites': favoritesData,
      });
    }
  }

  Future<double> getAverageRating(String clubId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('ratings')
        .where('clubId', isEqualTo: clubId)
        .get();

    if (snapshot.docs.isEmpty) {
      return 0;
    }

    double total = 0;
    for (var doc in snapshot.docs) {
      total += doc['rating'];
    }

    return total = total / snapshot.docs.length;
  }




}
