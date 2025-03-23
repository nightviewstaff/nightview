import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/models/users/user_data.dart';

class FriendsHelper {
  static Future<void> addFriend(String otherId) async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    if (auth.currentUser == null) {
      return;
    }

    String userId = auth.currentUser!.uid;

    await Future.wait([
      firestore
          .collection('friends')
          .doc(userId)
          .set({otherId: true}, SetOptions(merge: true)),
      firestore
          .collection('friends')
          .doc(otherId)
          .set({userId: true}, SetOptions(merge: true)),
    ]);
  }

  static Future<void> removeFriend(String otherId) async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    if (auth.currentUser == null) {
      return;
    }

    String userId = auth.currentUser!.uid;

    await Future.wait([
      firestore
          .collection('friends')
          .doc(userId)
          .set({otherId: false}, SetOptions(merge: true)),
      firestore
          .collection('friends')
          .doc(otherId)
          .set({userId: false}, SetOptions(merge: true)),
    ]);
  }

  static Future<List<String>> getAllFriendIds() async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    if (auth.currentUser == null) {
      return [];
    }

    String userId = auth.currentUser!.uid;
    List<String> friendIds = [];

    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await firestore.collection('friends').doc(userId).get();
      Map<String, dynamic>? data = snapshot.data();

      if (data == null || data.isEmpty) {
        print("No friends found for user: $userId");
        return [];
      }

      for (var entry in data.entries) {
        if (entry.value == true) {
          // Ensure it's explicitly 'true'
          friendIds.add(entry.key);
        }
      }
    } catch (e) {
      print("Error fetching friend IDs: $e");
    }

    print("Fetched Friend IDs: $friendIds");
    return friendIds;
  }

  static Future<bool> isFriend(String otherId) async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    if (auth.currentUser == null) {
      return false;
    }

    String userId = auth.currentUser!.uid;

    DocumentSnapshot<Map<String, dynamic>> snap =
        await firestore.collection('friends').doc(userId).get();

    if (!snap.exists) {
      return false;
    }

    if (!snap.data()!.containsKey(otherId)) {
      return false;
    }

    return snap.get(otherId);
  }

  static Future<List<UserData>> filterFriends(List<UserData> users,
      {FriendFilterType filterType = FriendFilterType.exclude}) async {
    final auth = FirebaseAuth.instance;

    if (auth.currentUser == null) {
      return [];
    }

    List<UserData> filteredUsers = [];

    for (UserData user in users) {
      if (user.id == auth.currentUser!.uid) {
        continue;
      }

      bool friend = await isFriend(user.id);
      bool filterFriend =
          (filterType == FriendFilterType.include) ? friend : !friend;

      if (filterFriend) {
        filteredUsers.add(user);
      }
    }

    return filteredUsers;
  }

  static Future<void> deleteDataAssociatedTo(String userId) async {
    final firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot<Map<String, dynamic>> snap = await firestore
          .collection('friends')
          .where(userId, isEqualTo: true)
          .get();
      for (DocumentSnapshot doc in snap.docs) {
        firestore.collection('friends').doc(doc.id).set({userId: false});
      }
    } catch (e) {
      // print(e);
    }

    try {
      await firestore.collection('friends').doc(userId).delete();
    } catch (e) {
      // print(e);
    }
  }

  static Future<List<UserData>> getFriendsData() async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    if (auth.currentUser == null) {
      return [];
    }

    List<UserData> friendsData = [];
    List<String> friendIds = await getAllFriendIds();

    for (String friendId in friendIds) {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await firestore.collection('user_data').doc(friendId).get();
      if (snapshot.exists) {
        friendsData.add(UserData.fromMap(snapshot.data()!));
      }
    }

    return friendsData;
  }

  static Future<List<UserData>> getFriendsOut() async {
    List<String> friendIds = await getAllFriendIds();
    List<UserData> friends = await _fetchUserDataForIds(friendIds);
    return friends
        .where((friend) => friend.partyStatus == PartyStatus.yes)
        .toList();
  }

  static Future<List<UserData>> _fetchUserDataForIds(
      List<String> friendIds) async {
    final firestore = FirebaseFirestore.instance;
    List<UserData> friendsData = [];

    for (String friendId in friendIds) {
      try {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await firestore.collection('user_data').doc(friendId).get();
        if (snapshot.exists) {
          friendsData.add(UserData.fromMap(snapshot.data()!));
        }
      } catch (e) {
        print("Error fetching user data for $friendId: $e");
      }
    }

    return friendsData;
  }
}
