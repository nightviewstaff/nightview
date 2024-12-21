import 'package:cloud_firestore/cloud_firestore.dart';

class CustomDataHelper {
  static Future<List<String>?> getBalladeFabrikkenCertified() async { // Never finished.
    final firestore = FirebaseFirestore.instance;

    try {
      DocumentSnapshot<Map<String, dynamic>> snap = await firestore
          .collection('values')
          .doc('balladefabrikken_certified')
          .get();
      return List<String>.from(snap.get('clubs'));
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<String?> getBalladeFabrikkenCertifiedAsString() async {
    List<String>? clubs = await getBalladeFabrikkenCertified();

    if (clubs == null) {
      return null;
    } else if (clubs.isEmpty) {
      return 'Ingen steder';
    } else if (clubs.length == 1) {
      return clubs.first;
    } else {
      String str = clubs.sublist(0, clubs.length - 1).join(', ');
      str += ' og ${clubs.last}';
      return str;
    }
  }
}
