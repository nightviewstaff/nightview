import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nightview/models/users/chat_data.dart';
import 'package:nightview/helpers/users/chats/chat_helper.dart';
import 'package:nightview/models/users/chat_message_data.dart';
import 'package:nightview/helpers/users/misc/profile_picture_helper.dart';
import 'package:nightview/models/users/user_data.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:provider/provider.dart';

class ChatSubscriber extends ChangeNotifier { // Needs refac
  final Map<String, ChatMessageData> _messages = {};
  final Map<String, ChatData> _chats = {};
  final Map<String, ImageProvider> _chatImages = {};

  Map<String, ChatMessageData> get messages => _messages;

  Map<String, ChatData> get chats => _chats;

  Map<String, ImageProvider> get chatImages => _chatImages;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>> subscribeToChat(
      String chatId) {
    final firestore = FirebaseFirestore.instance;

    _messages.clear();

    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .listen((snapshot) {
      for (DocumentChange<Map<String, dynamic>> docChange
          in snapshot.docChanges) {
        switch (docChange.type) {
          case DocumentChangeType.added:
            _messages[docChange.doc.id] = ChatMessageData(
              message: docChange.doc.get('message'),
              sender: docChange.doc.get('sender'),
              timestamp: docChange.doc.get('timestamp').toDate(),
            );
            break;
          case DocumentChangeType.modified:
            _messages[docChange.doc.id] = ChatMessageData(
              message: docChange.doc.get('message'),
              sender: docChange.doc.get('sender'),
              timestamp: docChange.doc.get('timestamp').toDate(),
            );
            break;
          case DocumentChangeType.removed:
            _messages.remove(docChange.doc.id);
            break;
        }
      }
      notifyListeners();
    });
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      subscribeToUsersChats(BuildContext context) {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    _chats.clear();

    if (auth.currentUser == null) {
      return null;
    }

    return firestore
        .collection('chats')
        .where('participants', arrayContains: auth.currentUser?.uid)
        .orderBy('last_updated')
        .snapshots()
        .listen((snapshot) {
      for (DocumentChange<Map<String, dynamic>> docChange
          in snapshot.docChanges) {
        switch (docChange.type) {
          case DocumentChangeType.added:
            _chats[docChange.doc.id] = ChatData(
              id: docChange.doc.id,
              lastMessage: docChange.doc.get('last_message'),
              lastSender: docChange.doc.get('last_sender'),
              lastUpdated: docChange.doc.get('last_updated').toDate(),
              participants:
                  List<String>.from(docChange.doc.get('participants')),
            );
            updateValues(context, _chats[docChange.doc.id]!);
            break;
          case DocumentChangeType.modified:
            _chats[docChange.doc.id] = ChatData(
              id: docChange.doc.id,
              lastMessage: docChange.doc.get('last_message'),
              lastSender: docChange.doc.get('last_sender'),
              lastUpdated: docChange.doc.get('last_updated').toDate(),
              participants:
                  List<String>.from(docChange.doc.get('participants')),
            );
            updateValues(context, _chats[docChange.doc.id]!);
            break;
          case DocumentChangeType.removed:
            _chats.remove(docChange.doc.id);
            break;
        }
      }
      notifyListeners();
    });
  }

  void updateValues(BuildContext context, ChatData chatData) async {
    String? otherId = await ChatHelper.getOtherMember(chatData.id);

    if (otherId == null) {
      return;
    }

    UserData? otherUser = Provider.of<GlobalProvider>(context, listen: false)
        .userDataHelper
        .userData[otherId];
    UserData? lastSenderUser =
        Provider.of<GlobalProvider>(context, listen: false)
            .userDataHelper
            .userData[chatData.lastSender];
    UserData? currentUser = Provider.of<GlobalProvider>(context, listen: false)
        .userDataHelper
        .currentUserData;

    _updateChatData(
      chatData.id,
      title: '${otherUser?.firstName} ${otherUser?.lastName}',
      imageUrl: await ProfilePictureHelper.getProfilePicture(otherId),
      lastSenderName:
          lastSenderUser == currentUser ? 'Dig' : lastSenderUser?.firstName,
    );

    ProfilePictureHelper.getProfilePicture(otherId).then((url) {
      _updateChatImage(chatData.id, url: url);
    });
  }

  void _updateChatData(
    String chatId, {
    String? title,
    String? lastSenderName,
    String? imageUrl,
  }) {
    chats[chatId]?.title = title;
    chats[chatId]?.lastSenderName = lastSenderName;
    chats[chatId]?.imageUrl = imageUrl;
    notifyListeners();
  }

  void _updateChatImage(
    String chatId, {
    String? url,
  }) {
    if (url == null) {
      _chatImages[chatId] = AssetImage('images/user_pb.jpg');
    } else {
      _chatImages[chatId] = CachedNetworkImageProvider(url);
    }
    notifyListeners();
  }
}
