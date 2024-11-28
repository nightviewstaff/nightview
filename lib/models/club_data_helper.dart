import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/models/club_data.dart';
import 'package:nightview/models/location_helper.dart';
import 'package:nightview/models/club_visit.dart';
import 'package:nightview/models/rating.dart';

class ClubDataHelper {
  final _firestore = FirebaseFirestore.instance;
  final _storageRef = FirebaseStorage.instance.ref();

  Map<String, ClubData> clubData = {};

  ClubDataHelper({Callback<Map<String, ClubData>>? onReceive}) {
    _firestore.collection('club_data').snapshots().listen((snap) {
      clubData.clear();

      List<Future<void>> futures =
          snap.docs.map((club) => _processClub(club)).toList();
      Future.wait(futures).then((value) {
        if (onReceive != null) {
          onReceive(clubData);
        }
      });
    });
  }

  Future<void> _processClub(
      QueryDocumentSnapshot<Map<String, dynamic>> club) async {
    try {
      final data = club.data();

      String logoUrl;
      try {
        logoUrl = await _storageRef.child('club_logos/${data['logo']}').getDownloadURL();
      } catch (e) {
        print('Error fetching logo URL for ${data['name']}: $e');
        logoUrl = "null";
      }

      String? mainOfferImgUrl;
      try {
        if (stringToOfferType(data['offer_type']) != OfferType.none) {
          mainOfferImgUrl = await _storageRef.child('main_offers/${data['main_offer_img']}').getDownloadURL();
        }
      } catch (e) {
        print('Error fetching main offer image URL for ${data['name']}: $e');
        mainOfferImgUrl = null;
      }

      final corners = (data['corners'] as List).map((geoPoint) {
        final point = geoPoint as GeoPoint;
        return {'latitude': point.latitude, 'longitude': point.longitude};
      }).toList();

      // Handle opening_hours null values properly
      final openingHours =
          (data['opening_hours'] as Map<String, dynamic>).map((day, hours) {
        if (hours == null) {
          return MapEntry(day, <String, String>{});
        } else {
          return MapEntry(day, Map<String, String>.from(hours));
        }
      });

      clubData[club.id] = ClubData(
        id: club.id,
        name: data['name'],
        logo: logoUrl,
        lat: data['lat'],
        lon: data['lon'],
        favorites: List<String>.from(data['favorites']),
        corners: corners,
        offerType: stringToOfferType(data['offer_type'] ?? 'OfferType.none') ??
            OfferType.none,
        mainOfferImg: mainOfferImgUrl,
        ageRestriction: data['age_restriction'],
        typeOfClub: data['type_of_club'],
        rating: data['rating'],
        openingHours: openingHours,
        visitors: data['visitors'],
        totalPossibleAmountOfVisitors:
            data['total_possible_amount_of_visitors'],
      );

      print('Club processed successfully: ${clubData[club.id]}');
    } catch (e) {
      print('Error processing club: $e');
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
  Future<void> evaluateVisitors(
      {required LocationHelper locationHelper}) async {
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
        if (userId != null && clubId != null) {
          // Update the 'club_visits' collection
          await updateVisitCount(userId, clubId);

          // Mark the document as processed
          await locationDoc.reference.update({'processed': true});
        } else {
          print(
              'Error: Missing user_id or club_id in document ${locationDoc.id}');
        }
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
