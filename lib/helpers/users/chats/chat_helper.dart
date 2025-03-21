import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:nightview/models/users/chat_message_data.dart';

class ChatHelper {
  static Future<String?> createNewChat(String otherId) async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    if (auth.currentUser == null) {
      return null;
    }

    List<String> participants = [
      auth.currentUser!.uid,
      otherId,
    ]..sort();

    String? chatId = await getChatIdWithParticipants(participants);

    if (chatId != null) {
      return chatId;
    }

    try {
      DocumentReference<Map<String, dynamic>> ref =
          await firestore.collection('chats').add({
        'participants': participants,
        'last_message': '',
        'last_sender': '',
        'last_updated': Timestamp.now(),
      });
      return ref.id;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  static Future<String?> getChatIdWithParticipants(
      List<String> participants) async {
    final firestore = FirebaseFirestore.instance;

    QuerySnapshot chatsAlikeSnap = await firestore
        .collection('chats')
        .where('participants', isEqualTo: participants)
        .get();

    if (chatsAlikeSnap.size <= 0) {
      return null;
    }

    return chatsAlikeSnap.docs.first.id;
  }

  static Future<bool> sendChatMessage(
      ChatMessageData messageData, String chatId) async {
    final firestore = FirebaseFirestore.instance;

    try {
      await firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        'message': messageData.message,
        'sender': messageData.sender,
        'timestamp': Timestamp.fromDate(messageData.timestamp),
      });
      await firestore.collection('chats').doc(chatId).set({
        'last_message': messageData.message,
        'last_sender': messageData.sender,
        'last_updated': Timestamp.now(),
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  static Future<String?> getOtherMember(String chatId) async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    try {
      DocumentSnapshot<Map<String, dynamic>> snap =
          await firestore.collection('chats').doc(chatId).get();
      List<String> participants = List<String>.from(snap.get('participants'));
      participants.removeWhere((id) => id == auth.currentUser!.uid);
      return participants.first;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  // SKAL OVERHAULES, NÅR GRUPPECHATS BLIVER INTRODUCERET!!!
  static Future<void> deleteDataAssociatedTo(String userId) async {
    final firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot<Map<String, dynamic>> snap = await firestore
          .collection('chats')
          .where('participants', arrayContains: userId)
          .get();
      for (DocumentSnapshot doc in snap.docs) {
        await firestore.collection('chats').doc(doc.id).delete();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
