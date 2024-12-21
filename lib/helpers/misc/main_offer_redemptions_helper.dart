import 'package:cloud_firestore/cloud_firestore.dart';

class MainOfferRedemptionsHelper {
  final _firestore = FirebaseFirestore.instance;

  Future<DateTime> getLastRedemption(
      {required String userId, required String clubId}) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('main_offer_redemptions')
          .where('user_id', isEqualTo: userId)
          .where('club_id', isEqualTo: clubId)
          .orderBy('timestamp')
          .get();
      QueryDocumentSnapshot document = snapshot.docs.last;

      return document.get('timestamp').toDate();
    } catch (e) {
      print(e);
      return DateTime(2000);
    }
  }

  Future<bool> uploadRedemption(
      {required String userId, required String clubId}) async {
    try {
      _firestore.collection('main_offer_redemptions').add({
        'user_id': userId,
        'club_id': clubId,
        'timestamp': Timestamp.now(),
      });
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }

  deleteDataAssociatedTo(String userId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('main_offer_redemptions').get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> redemption
        in snapshot.docs) {
      String redemptionId = redemption.id;

      String redemptionUserId = redemption.get('user_id').toString();

      if (redemptionUserId == userId) {
        _firestore
            .collection('main_offer_redemptions')
            .doc(redemptionId)
            .delete();
      }
    }
  }
}
