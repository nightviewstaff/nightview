import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BiographyHelper {
  static Future<bool> setBiography(String newBiography) async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    if (auth.currentUser == null) {
      return false;
    }

    try {
      await firestore.collection('user_data').doc(auth.currentUser!.uid).set(
        {
          'biography': newBiography,
        },
        SetOptions(merge: true),
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<String?> getBiography(String userId) async {
    final firestore = FirebaseFirestore.instance;

    DocumentSnapshot<Map<String, dynamic>> snap =
        await firestore.collection('user_data').doc(userId).get();

    if (!snap.exists) {
      return null;
    }

    try {
      return snap.get('biography');
    } catch (e) {
      print(e);
      return null;
    }
  }
}
