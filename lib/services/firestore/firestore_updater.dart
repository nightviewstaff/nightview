import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUpdater {
  // TODO write a script that checks all information in the database and report back if mistakes
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> updateFirestoreData() async {
    // Fetch all documents from the 'club_data' collection
    CollectionReference clubCollection = firestore.collection('club_data');
    QuerySnapshot clubSnapshot = await clubCollection.get();

    for (DocumentSnapshot doc in clubSnapshot.docs) {
      String clubDocumentId = doc.id;

      if (doc.exists) {
        try {
          // Get current data and ensure it's a Map<String, dynamic>
          Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

          if (data == null) {
            // print('Document data is null for $clubDocumentId.');
            continue;
          }

          // print('Original Data: $data'); // Debug: Print original data

          _removeUnwantedAttributes(data);
          _updateFields(data);

          // print('Updated Data: $data'); // Debug: Print updated data

          // Update the document with the new data
          await clubCollection.doc(clubDocumentId).set(data);

          // Ensure the 'ratings' collection exists
          await _ensureRatingsCollection(
              clubCollection.doc(clubDocumentId), clubDocumentId);

          // print('Firestore data update complete for $clubDocumentId.');
        } catch (e) {
          // print('Error processing document $clubDocumentId: $e');
        }
      } else {
        // print('Document $clubDocumentId does not exist.');
      }
    }
  }

  void _updateFields(Map<String, dynamic> data) {
    // Ensure all required attributes are present and correctly updated
    void putIfAbsent(Map<String, dynamic> map, String key, dynamic value) {
      if (map[key] == null) {
        map[key] = value;
      }
    }

    putIfAbsent(data, 'age_of_visitors', ''); // String
    putIfAbsent(data, 'age_restriction', 10); // Number
    putIfAbsent(data, 'corners', [
      const GeoPoint(0.0, 0.0),
      const GeoPoint(0.0, 0.0),
      const GeoPoint(0.0, 0.0),
      const GeoPoint(0.0, 0.0)
    ]); // Array of GeoPoint
    putIfAbsent(data, 'favorites', [
      '',
    ]); // Array of Strings
    putIfAbsent(data, 'first_time_visitors', 0); // Number
    putIfAbsent(data, 'lat', 0.0); // Number (Double)
    putIfAbsent(data, 'logo', ''); // String
    putIfAbsent(data, 'lon', 0.0); // Number (Double)
    putIfAbsent(data, 'main_offer_img', ''); // String
    putIfAbsent(data, 'name', 'Klub Klub'); // String
    putIfAbsent(data, 'offer_type', ''); // String
    putIfAbsent(data, 'peak_hours', '10:00 - 10:01'); // String
    putIfAbsent(data, 'rating', 0); // Number
    putIfAbsent(data, 'regular_visitors', 0); // Number
    putIfAbsent(data, 'returning_visitors', 0); // Number
    putIfAbsent(data, 'total_possible_amount_of_visitors', 1); // Number
    putIfAbsent(data, 'type_of_club', 'Klub'); // String
    putIfAbsent(data, 'visitors', 0); // Number
    putIfAbsent(data, 'opening_hours', {
      'monday': null,
      'tuesday': null,
      'wednesday': {'open': '20:00', 'close': 'luk'},
      'thursday': {'open': '20:00', 'close': 'luk'},
      'friday': {'open': '20:00', 'close': 'luk'},
      'saturday': {'open': '20:00', 'close': 'luk'},
      'sunday': null,
    });
  }

  void _removeUnwantedAttributes(Map<String, dynamic> data) {
    // Remove the unwanted attribute
    data.remove('peakHour');
    data.remove('ageRestriction');
    data.remove('offerType');
    data.remove('totalPossibleAmountOfVisitors');
    data.remove('openingHours');
  }

  Future<void> _ensureRatingsCollection(
      DocumentReference clubRef, String clubDocumentId) async {
    // Ensure the 'ratings' collection exists by adding a document with specified fields
    CollectionReference ratingsRef = clubRef.collection('ratings');
    QuerySnapshot ratingsSnapshot = await ratingsRef.get();

    if (ratingsSnapshot.docs.isEmpty) {
      // Add a document with specified fields to ensure the collection is created
      await ratingsRef.add({
        'club_id': clubDocumentId,
        'rating': 3,
        'timestamp': FieldValue.serverTimestamp(),
        'user_id': 'Edj2ex3selWyLnUV8qvDanrNH2L2',
      });
    }
  }

  Future<void> updateFavoriteClubs() async {
    try {
      final _firestore = FirebaseFirestore.instance;

      // Fetch all users from user_data
      QuerySnapshot userSnapshot =
          await _firestore.collection('user_data').get();
      List<QueryDocumentSnapshot> users = userSnapshot.docs;
      int totalUsers = users.length;
      int processedUsers = 0;
      DateTime startTime = DateTime.now();
      DateTime lastUpdateTime = startTime;

      // Periodic timer for progress updates every 30 seconds
      const Duration updateInterval = Duration(seconds: 30);
      Timer? progressTimer;
      progressTimer = Timer.periodic(updateInterval, (timer) {
        if (processedUsers > 0) {
          _printProgress(totalUsers, processedUsers, startTime, lastUpdateTime);
          lastUpdateTime = DateTime.now();
        }
      });

      // Process users in batches of 500
      const int batchSize = 500;
      for (int i = 0; i < totalUsers; i += batchSize) {
        int end = (i + batchSize < totalUsers) ? i + batchSize : totalUsers;
        List<QueryDocumentSnapshot> batchUsers = users.sublist(i, end);

        // Process each batch concurrently
        await Future.wait(batchUsers.map((userDoc) async {
          //TODO REMOVE ALL Admin
          String userId = userDoc.id;
          bool isAdmin = userDoc['is_admin'] == true;

          // Skip admin users
          if (isAdmin) {
            processedUsers++;
            return;
          }

          dynamic favoriteClubsData = userDoc['favorite_clubs'];

          // Check if favorite_clubs is already valid
          bool isFavoriteClubsValid = false;
          if (favoriteClubsData is List && favoriteClubsData.isNotEmpty) {
            if (favoriteClubsData.first is Map &&
                favoriteClubsData.every((fav) =>
                    fav.containsKey('clubId') &&
                    fav.containsKey('timestamp')) &&
                favoriteClubsData.length <= 5) {
              isFavoriteClubsValid = true;
            }
          } else if (favoriteClubsData is List &&
              favoriteClubsData.length <= 5) {
            isFavoriteClubsValid = true; // Empty or invalid but within limit
          }

          // Skip if already valid
          if (isFavoriteClubsValid) {
            processedUsers++;
            return;
          }

          // Initialize or convert favorite_clubs
          List<Map<String, dynamic>> favoriteClubs = [];
          if (favoriteClubsData is List && favoriteClubsData.isNotEmpty) {
            if (favoriteClubsData.first is! Map) {
              // Old format: assume list of strings
              favoriteClubs = favoriteClubsData
                  .map((clubId) => {
                        'clubId': clubId
                            as String, // Ensure clubId is treated as String
                        'timestamp': Timestamp.now(),
                      })
                  .toList();
            } else {
              // New format: list of maps
              favoriteClubs =
                  List<Map<String, dynamic>>.from(favoriteClubsData);
            }
          }

          // Query club_data for current favorited clubs
          QuerySnapshot clubSnapshot = await _firestore
              .collection('club_data')
              .where('favorites', arrayContains: userId)
              .get();
          List<String> currentFavorites =
              clubSnapshot.docs.map((doc) => doc.id).toList();

          // Build new favorite_clubs list
          Map<String, Map<String, dynamic>> favoriteClubsMap = {
            for (var fav in favoriteClubs) fav['clubId']: fav
          };
          List<Map<String, dynamic>> newFavoriteClubs = [];
          for (String clubId in currentFavorites) {
            newFavoriteClubs.add(favoriteClubsMap[clubId] ??
                {
                  'clubId': clubId,
                  'timestamp': Timestamp.now(),
                });
          }

          // Trim to 5 clubs if necessary
          if (newFavoriteClubs.length > 5) {
            newFavoriteClubs.shuffle(); // Randomize for fairness
            List<String> clubsToRemove = currentFavorites
                .where((clubId) => !newFavoriteClubs
                    .sublist(0, 5)
                    .any((fav) => fav['clubId'] == clubId))
                .toList();
            newFavoriteClubs = newFavoriteClubs.sublist(0, 5);

            // Update club_data for removed clubs
            for (String clubId in clubsToRemove) {
              await _firestore.collection('club_data').doc(clubId).update({
                'favorites': FieldValue.arrayRemove([userId]),
              });
            }
          }

          // Update user_data
          await _firestore.collection('user_data').doc(userId).update({
            'favorite_clubs': newFavoriteClubs,
          });

          processedUsers++;
        }));

        // Print progress after each batch if 30 seconds have passed
        DateTime currentTime = DateTime.now();
        if (currentTime.difference(lastUpdateTime).inSeconds >= 30) {
          _printProgress(totalUsers, processedUsers, startTime, currentTime);
          lastUpdateTime = currentTime;
        }
      }

      // Finalize
      progressTimer?.cancel();
      _printProgress(totalUsers, processedUsers, startTime, DateTime.now());
      print('Successfully updated favorite_clubs for all users');
    } catch (e) {
      print('Error updating favorite_clubs: $e');
    }
  }

// Progress reporting helper
  void _printProgress(int totalUsers, int processedUsers, DateTime startTime,
      DateTime currentTime) {
    Duration elapsed = currentTime.difference(startTime);
    double progress = totalUsers > 0
        ? processedUsers / totalUsers
        : 0.0; // Avoid division by zero
    Duration estimatedTotalTime;
    if (progress <= 0) {
      // If no progress, assume remaining time equals elapsed time
      estimatedTotalTime = elapsed;
    } else {
      // Scale elapsed by 1/progress, convert to integer for ~/ operator
      estimatedTotalTime =
          Duration(milliseconds: (elapsed.inMilliseconds / progress).round());
    }
    Duration timeRemaining = estimatedTotalTime - elapsed;

    String elapsedStr = _formatDuration(elapsed);
    String remainingStr = _formatDuration(timeRemaining);

    print('Progress: $processedUsers/$totalUsers users processed | '
        'Elapsed: $elapsedStr | Estimated Time Remaining: $remainingStr');
  }

// Duration formatting helper
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}';
  }
}
