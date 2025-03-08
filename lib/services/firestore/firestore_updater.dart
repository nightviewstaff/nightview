import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUpdater { // TODO write a script that checks all information in the database and report back if mistakes
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
          await _ensureRatingsCollection(clubCollection.doc(clubDocumentId), clubDocumentId);

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

}