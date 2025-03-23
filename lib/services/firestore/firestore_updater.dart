import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUpdater {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> updateFavoriteClubs() async {
    try {
      const String adminUserId =
          "Edj2ex3selWyLnUV8qvDanrNH2L2"; // The user to keep is_admin

      // Fetch all users from user_data
      QuerySnapshot userSnapshot =
          await firestore.collection('user_data').get();
      List<QueryDocumentSnapshot> users = userSnapshot.docs;
      int totalUsers = users.length;
      int processedUsers = 0;
      DateTime startTime = DateTime.now();

      print('Starting user_data update for $totalUsers users...');

      // Process all users in batches limited by Firestore's max batch size (500 writes)
      const int maxBatchSize = 500; // Firestore batch write limit
      for (int i = 0; i < totalUsers; i += maxBatchSize) {
        int end =
            (i + maxBatchSize < totalUsers) ? i + maxBatchSize : totalUsers;
        List<QueryDocumentSnapshot> batchUsers = users.sublist(i, end);

        WriteBatch batch = firestore.batch();
        int batchCount = 0;

        // Process each user in the current batch
        for (var userDoc in batchUsers) {
          String userId = userDoc.id;
          bool hasAdmin = userDoc.data() != null &&
              (userDoc.data() as Map<String, dynamic>).containsKey('is_admin');
          bool shouldRemoveAdmin = hasAdmin && userId != adminUserId;

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

          // Prepare update data
          Map<String, dynamic> updateData = {};
          if (!isFavoriteClubsValid) {
            List<Map<String, dynamic>> favoriteClubs = [];
            if (favoriteClubsData is List && favoriteClubsData.isNotEmpty) {
              if (favoriteClubsData.first is! Map) {
                // Old format: assume list of strings
                favoriteClubs = favoriteClubsData
                    .map((clubId) => {
                          'clubId': clubId as String,
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
            QuerySnapshot clubSnapshot = await firestore
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

              // Queue updates for club_data in the batch
              for (String clubId in clubsToRemove) {
                batch.update(firestore.collection('club_data').doc(clubId), {
                  'favorites': FieldValue.arrayRemove([userId]),
                });
                batchCount++;
              }
            }

            updateData['favorite_clubs'] = newFavoriteClubs;
          }

          // Remove is_admin field entirely for all except the specified user
          if (shouldRemoveAdmin) {
            updateData['is_admin'] = FieldValue.delete();
          }

          // If there are updates, add to batch
          if (updateData.isNotEmpty) {
            batch.update(
                firestore.collection('user_data').doc(userId), updateData);
            batchCount++;
            print('Queued update for $userId: $updateData');
          }

          processedUsers++;
        }

        // Commit the batch if there are updates
        if (batchCount > 0) {
          await batch.commit();
          print('Committed batch of $batchCount updates');
        }

        _printProgress(totalUsers, processedUsers, startTime, DateTime.now());
      }

      print('Successfully updated user_data for $totalUsers users');
    } catch (e) {
      print('Error updating user_data: $e');
      rethrow; // Optional: Rethrow to handle errors upstream
    }
  }

  // Progress reporting helper
  void _printProgress(int totalUsers, int processedUsers, DateTime startTime,
      DateTime currentTime) {
    Duration elapsed = currentTime.difference(startTime);
    double progress = totalUsers > 0 ? processedUsers / totalUsers : 0.0;
    Duration estimatedTotalTime = progress > 0
        ? Duration(milliseconds: (elapsed.inMilliseconds / progress).round())
        : elapsed;
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

  // Keeping updateFirestoreData as is for completeness
  Future<void> updateFirestoreData() async {
    try {
      CollectionReference clubCollection = firestore.collection('club_data');
      QuerySnapshot clubSnapshot = await clubCollection.get();
      int totalClubs = clubSnapshot.docs.length;
      int processedClubs = 0;

      print('Starting club_data update for $totalClubs clubs...');

      for (DocumentSnapshot doc in clubSnapshot.docs) {
        String clubDocumentId = doc.id;
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        if (data == null) {
          print('Skipping $clubDocumentId: No data.');
          continue;
        }

        Map<String, dynamic> originalData = Map.from(data);
        _removeUnwantedAttributes(data);
        _updateFields(data);

        Map<String, dynamic> updates = _getChangedFields(originalData, data);
        if (updates.isNotEmpty) {
          await clubCollection.doc(clubDocumentId).update(updates);
          print('Updated $clubDocumentId with: $updates');
        } else {
          print('No changes needed for $clubDocumentId');
        }

        await _ensureRatingsCollection(
            clubCollection.doc(clubDocumentId), clubDocumentId);
        processedClubs++;
        print('Processed $processedClubs/$totalClubs clubs');
      }

      print('Firestore club_data update complete.');
    } catch (e) {
      print('Error updating club_data: $e');
    }
  }

  void _updateFields(Map<String, dynamic> data) {
    void putIfAbsent(Map<String, dynamic> map, String key, dynamic value) {
      if (map[key] == null) map[key] = value;
    }

    putIfAbsent(data, 'age_of_visitors', '');
    putIfAbsent(data, 'age_restriction', 10);
    putIfAbsent(data, 'corners', [
      const GeoPoint(0.0, 0.0),
      const GeoPoint(0.0, 0.0),
      const GeoPoint(0.0, 0.0),
      const GeoPoint(0.0, 0.0)
    ]);
    putIfAbsent(data, 'favorites', ['']);
    putIfAbsent(data, 'first_time_visitors', 0);
    putIfAbsent(data, 'lat', 0.0);
    putIfAbsent(data, 'logo', '');
    putIfAbsent(data, 'lon', 0.0);
    putIfAbsent(data, 'main_offer_img', '');
    putIfAbsent(data, 'name', 'Klub Klub');
    putIfAbsent(data, 'offer_type', '');
    putIfAbsent(data, 'peak_hours', '10:00 - 10:01');
    putIfAbsent(data, 'rating', 0);
    putIfAbsent(data, 'regular_visitors', 0);
    putIfAbsent(data, 'returning_visitors', 0);
    putIfAbsent(data, 'total_possible_amount_of_visitors', 1);
    putIfAbsent(data, 'type_of_club', 'Klub');
    putIfAbsent(data, 'visitors', 0);
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
    data.remove('peakHour');
    data.remove('ageRestriction');
    data.remove('offerType');
    data.remove('totalPossibleAmountOfVisitors');
    data.remove('openingHours');
  }

  Future<void> _ensureRatingsCollection(
      DocumentReference clubRef, String clubDocumentId) async {
    CollectionReference ratingsRef = clubRef.collection('ratings');
    QuerySnapshot ratingsSnapshot = await ratingsRef.get();

    if (ratingsSnapshot.docs.isEmpty) {
      await ratingsRef.add({
        'club_id': clubDocumentId,
        'rating': 3,
        'timestamp': FieldValue.serverTimestamp(),
        'user_id': 'Edj2ex3selWyLnUV8qvDanrNH2L2',
      });
      print('Created ratings subcollection for $clubDocumentId');
    }
  }

  Map<String, dynamic> _getChangedFields(
      Map<String, dynamic> original, Map<String, dynamic> updated) {
    Map<String, dynamic> changes = {};
    updated.forEach((key, value) {
      if (!original.containsKey(key) || original[key] != value) {
        changes[key] = value;
      }
    });
    original.forEach((key, value) {
      if (!updated.containsKey(key)) {
        changes[key] = FieldValue.delete();
      }
    });
    return changes;
  }
}
