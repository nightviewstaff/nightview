import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/models/users/friend_request.dart';

class FriendRequestHelper { // Too long class.
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static Future<List<FriendRequest>> getPendingFriendRequests() async {
    final currentUserId = _auth.currentUser!.uid;

    List<FriendRequest> requests = [];
    List<QueryDocumentSnapshot> documents = [];

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('friend_requests')
          .where('to', isEqualTo: currentUserId)
          .where('status',
              isEqualTo: _enumToString(FriendRequestStatus.pending))
          .orderBy('timestamp')
          .get();
      documents = snapshot.docs;
    } catch (e) {
      print(e);
    }

    for (QueryDocumentSnapshot doc in documents) {
      requests.add(
        FriendRequest(
          requestId: doc.id,
          fromId: doc.get('from'),
        ),
      );
    }

    return requests;
  }

  static Future<bool> pendingFriendRequests() async {
    final currentUserId = _auth.currentUser!.uid;

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('friend_requests')
          .where('to', isEqualTo: currentUserId)
          .where('status',
              isEqualTo: _enumToString(FriendRequestStatus.pending))
          .get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<void> sendFriendRequest(String otherId) async {
    final currentUserId = _auth.currentUser!.uid;

    try {
      await _firestore.collection('friend_requests').add({
        'from': currentUserId,
        'to': otherId,
        'status': _enumToString(FriendRequestStatus.pending),
        'timestamp': Timestamp.now(),
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<void> acceptFriendRequest(String requestId) async {
    await _firestore
        .collection('friend_requests')
        .doc(requestId)
        .update({'status': _enumToString(FriendRequestStatus.accepted)});
  }

  static Future<void> rejectFriendRequest(String requestId) async {
    await _firestore
        .collection('friend_requests')
        .doc(requestId)
        .update({'status': _enumToString(FriendRequestStatus.rejected)});
  }

  static Future<bool> userHasRequest(String otherId) async {
    final currentUserId = _auth.currentUser!.uid;

    int count1 = (await _firestore
                .collection('friend_requests')
                .where('from', isEqualTo: otherId)
                .where('to', isEqualTo: currentUserId)
                .where('status',
                    isEqualTo: _enumToString(FriendRequestStatus.pending))
                .count()
                .get())
            .count ??
        0; // Defaults to 0 if null

    int count2 = (await _firestore
                .collection('friend_requests')
                .where('from', isEqualTo: currentUserId)
                .where('to', isEqualTo: otherId)
                .where('status',
                    isEqualTo: _enumToString(FriendRequestStatus.pending))
                .count()
                .get())
            .count ??
        0; // Defaults to 0 if null

    if (count1 + count2 > 0) {
      return true;
    }
    return false;
  }

  static Future<void> deleteDataAssociatedTo(String userId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snap = await _firestore
          .collection('friends_requests')
          .where('from', isEqualTo: userId)
          .get();
      for (DocumentSnapshot doc in snap.docs) {
        _firestore.collection('friend_requests').doc(doc.id).delete();
      }
    } catch (e) {
      print(e);
    }

    try {
      QuerySnapshot<Map<String, dynamic>> snap = await _firestore
          .collection('friends_requests')
          .where('to', isEqualTo: userId)
          .get();
      for (DocumentSnapshot doc in snap.docs) {
        _firestore.collection('friend_requests').doc(doc.id).delete();
      }
    } catch (e) {
      print(e);
    }
  }

  static String _enumToString(FriendRequestStatus status) {
    switch (status) {
      case FriendRequestStatus.pending:
        return 'FriendRequestStatus.pending';
      case FriendRequestStatus.accepted:
        return 'FriendRequestStatus.accepted';
      case FriendRequestStatus.rejected:
        return 'FriendRequestStatus.rejected';
    }
  }

  static FriendRequestStatus _stringToEnum(String status) {
    switch (status) {
      case 'FriendRequestStatus.pending':
        return FriendRequestStatus.pending;
      case 'FriendRequestStatus.accepted':
        return FriendRequestStatus.accepted;
      case 'FriendRequestStatus.rejected':
        return FriendRequestStatus.rejected;
      default:
        return FriendRequestStatus.rejected;
    }
  }
}
