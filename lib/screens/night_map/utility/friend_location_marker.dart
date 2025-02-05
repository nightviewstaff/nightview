//
// import 'package:flutter/cupertino.dart';
//
// class FriendLocationMarker extends {
//
//   void _listenToFriendLocations() async { // Not needed for now
//     final firestore = FirebaseFirestore.instance;
//     final auth = FirebaseAuth.instance;
//
//     if (auth.currentUser == null) {
//       return;
//     }
//
//     String userId = auth.currentUser!.uid;
//     _friendLocationSubscription = firestore
//         .collection('friends')
//         .doc(userId)
//         .snapshots()
//         .listen((snapshot) async {
//       if (snapshot.exists) {
//         Map<String, dynamic> data = snapshot.data()!;
//         List<String> friendIds =
//         data.keys.where((k) => data[k] == true).toList();
//
//         List<UserData> friendsData = [];
//         for (String friendId in friendIds) {
//           DocumentSnapshot<Map<String, dynamic>> friendSnapshot =
//           await firestore.collection('user_data').doc(friendId).get();
//           if (friendSnapshot.exists) {
//             friendsData.add(UserData.fromMap(friendSnapshot.data()!));
//           }
//         }
//
//         setState(() {
//           friendMarkers = {
//             for (var friend in friendsData)
//               friend.id: Marker(
//                 point: LatLng(friend.lastPositionLat, friend.lastPositionLon),
//                 width: 80.0,
//                 height: 100.0,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       friend.firstName,
//                       style: TextStyle(
//                         color: secondaryColor,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 12.0,
//                       ),
//                     ),
//                     Icon(
//                       Icons.person_pin_circle,
//                       color: primaryColor,
//                       size: 40.0,
//                     ),
//                   ],
//                 ),
//               )
//           };
//         });
//       }
//     });
//   }
// }