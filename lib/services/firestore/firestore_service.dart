// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// class FirestoreService {
//   final _firestore = FirebaseFirestore.instance;
//   final _storageRef = FirebaseStorage.instance.ref();

// //   Future<void> fetchFromFirestore(String collection) async {
// //     // if(already fetched){
// //     //   return already fetched
// //     // else

// //     try {
// //       final snapshotFuture = _firestore.collection(collection).get();

// // }catch}}

//   static Future<List<NightOffer>> getTodaysOffers() async {
//     final querySnapshot = await FirebaseFirestore.instance
//         .collection('night_offers')
//         .where('active', isEqualTo: true)
//         .limit(9)
//         .get();

//     return querySnapshot.docs.map((doc) => Offer.fromMap(doc.data())).toList();
//   }
// }
