

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShareCodeHelper {

  static const _characters = 'abcdefghijklmnopgrstuvwxyzABCDEFGHIJLKMNOPQRSTUVWXYZ0123456789';

  static Future<String> generateNewShareCode() async {
    while (true) {
      String code = _generateCode(6);
      bool exists = await codeExists(code);
      if (!exists) {
        return code;
      }
    }
  }

  static Future<bool> codeExists(String code) async {
    final firestore = FirebaseFirestore.instance;

    try {
      // Use `?.count ?? 0` to handle any potential null values safely.
      int count = (await firestore
          .collection('share_codes')
          .where('code', isEqualTo: code)
          .count().get()).count ?? 0;
      return count > 0;
    } catch (e) {
      print(e);
      return true; // Assume code exists if there's an error
    }
  }

  static Future<bool> uploadShareCode({required String code, required String userId}) async {
    final firestore = FirebaseFirestore.instance;

    try {
      await firestore.collection('share_codes').add({
        'code': code,
        'owner': userId,
        'status': 'pending',
        'timestamp': Timestamp.now(),
      });
    } catch (e) {
      print(e);
      return false;
    }

    return true;

  }

  static Future<String?> getStatusOfCode(String code) async {
    final firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot<Map<String, dynamic>> snap = await firestore.collection('share_codes').where('code', isEqualTo: code).limit(1).get();
      return snap.docs.first.get('status');
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<bool> sendShot(String code) async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    String? userId = auth.currentUser?.uid;

    if (userId == null) {
      return false;
    }

    try {
      QuerySnapshot<Map<String, dynamic>> snap = await firestore.collection('share_codes').where('code', isEqualTo: code).get();
      for (DocumentSnapshot doc in snap.docs) {
        if (doc.get('owner') == userId) {
          return false;
        }
        doc.reference.update({
          'status': 'accepted',
        });
      }
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }

  static String getMessageFromCode(String code) {
    return '''
Hej

Du kan give mig et shot, ganske gratis, ved at downloade NightView, trykke på lyn-ikonet i øverste venstre hjørne og indtaste koden:

$code

IOS: https://apps.apple.com/dk/app/nightview/id6458585988
Android: https://play.google.com/store/apps/details?id=com.nightview.nightview

Ha' en go' dag!''';
  }

  static Future<int?> redeemAcceptedCodes() async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    String? userId = auth.currentUser?.uid;
    int count = 0;

    try {
      QuerySnapshot<Map<String, dynamic>> snap = await firestore.collection('share_codes').where('owner', isEqualTo: userId).where('status', isEqualTo: 'accepted').get();
      for (DocumentSnapshot doc in snap.docs) {
        try {
          doc.reference.update({'status': 'redeemed'});
          count++;
        } catch (e) {
          print(e);
        }
      }
    } catch (e) {
      print(e);
      return null;
    }

    return count;

  }

  static String _generateCode(int digits) {

    String code = '';

    for (int i = 0; i < digits; i++) {
      int index = Random().nextInt(_characters.length);
      code += _characters[index];
    }

    return code;

  }

  static Future<void> deleteDataAssociatedTo(String userId) async {
    final firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot<Map<String, dynamic>> snap = await firestore.collection('share_codes').where('owner', isEqualTo: userId).get();
      for (DocumentSnapshot doc in snap.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print(e);
    }

  }

}