import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReferralPointsHelper {
  static Future<bool> incrementReferralPoints(int amount) async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    String? userId = auth.currentUser?.uid;

    if (userId == null) {
      return false;
    }

    try {
      DocumentSnapshot doc =
          await firestore.collection('referral_points').doc(userId).get();
      int points = 0;
      if (doc.exists) {
        points = doc.get('points');
      }
      await firestore
          .collection('referral_points')
          .doc(userId)
          .set({'points': points + amount}, SetOptions(merge: true));
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }

  static Future<int?> getPointsOfCurrentUser() async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    String? userId = auth.currentUser?.uid;

    if (userId == null) {
      return null;
    }

    try {
      DocumentSnapshot doc =
          await firestore.collection('referral_points').doc(userId).get();
      if (doc.exists) {
        return doc.get('points');
      } else {
        return 0;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<bool?> getSentStatus() async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    String? userId = auth.currentUser?.uid;

    if (userId == null) {
      return null;
    }

    try {
      DocumentSnapshot<Map<String, dynamic>> snap =
          await firestore.collection('referral_points').doc(userId).get();
      if (!snap.exists) {
        return false;
      }
      try {
        return snap.get('sent_status');
      } catch (e) {
        return false;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<bool> setSentStatus(bool status) async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    String? userId = auth.currentUser?.uid;

    if (userId == null) {
      return false;
    }

    try {
      await firestore
          .collection('referral_points')
          .doc(userId)
          .set({'sent_status': status}, SetOptions(merge: true));
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }

  static Future<void> deleteDataAssociatedTo(String userId) async {
    final firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('referral_points').doc(userId).delete();
    } catch (e) {
      print(e);
    }
  }
}
