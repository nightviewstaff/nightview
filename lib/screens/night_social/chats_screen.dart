import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/generated/l10n.dart';
import 'package:nightview/helpers/users/chats/chat_subscriber.dart';
import 'package:nightview/helpers/users/friends/friend_request_helper.dart';
import 'package:nightview/models/users/chat_data.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/screens/night_social/find_new_friends_screen.dart';
import 'package:nightview/screens/night_social/friend_requests_screen.dart';
import 'package:nightview/screens/night_social/new_chat_screen.dart';
import 'package:nightview/screens/night_social/night_social_conversation_screen.dart';
import 'package:nightview/widgets/icons/back_button_top_left.dart';
import 'package:provider/provider.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});
  static const id = 'chats_screen';

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? chatsSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatSub = Provider.of<ChatSubscriber>(context, listen: false);
      chatsSubscription = chatSub.subscribeToUsersChats(context);
      checkPending();
    });

    Provider.of<GlobalProvider>(context, listen: false).fetchUserLocation();
  }

  void checkPending() async {
    final pending = await FriendRequestHelper.pendingFriendRequests();
    Provider.of<GlobalProvider>(context, listen: false)
        .setPendingFriendRequests(pending);
  }

  @override
  void dispose() {
    chatsSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final global = Provider.of<GlobalProvider>(context);
    final chatSub = Provider.of<ChatSubscriber>(context);
    final userId = global.userDataHelper.currentUserId;

    return Scaffold(
      backgroundColor: black,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    left: kBigPadding + 35,
                    right: kBigPadding,
                    top: kBigPadding,
                    bottom: kBigPadding,
                  ),
                  color: black,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(S.of(context).chats, style: kTextStyleH1),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(NewChatScreen.id);
                            },
                            icon: const FaIcon(FontAwesomeIcons.penToSquare),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(FindNewFriendsScreen.id);
                            },
                            icon: const FaIcon(FontAwesomeIcons.userPlus,
                                color: primaryColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (global.pendingFriendRequests)
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(FriendRequestsScreen.id);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(kBigPadding),
                      color: black,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(S.of(context).new_friend_requests,
                              style: kTextStyleH3),
                          const FaIcon(FontAwesomeIcons.arrowRight),
                        ],
                      ),
                    ),
                  ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(kMainPadding),
                    itemCount: chatSub.chats.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: kSmallSpacerValue),
                    itemBuilder: (context, index) {
                      final chatData = chatSub.chats.values
                          .toList()
                          .reversed
                          .toList()[index];
                      if (userId == null) return const SizedBox.shrink();

                      return ListTile(
                        onTap: () {
                          global.setChosenChatId(chatData.id);
                          Navigator.of(context)
                              .pushNamed(NightSocialConversationScreen.id);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(kMainBorderRadius),
                          side: const BorderSide(
                              color: white, width: kMainStrokeWidth),
                        ),
                        leading: CircleAvatar(
                          backgroundImage: chatSub.chatImages[chatData.id],
                        ),
                        title: Text(chatData.title ?? '',
                            overflow: TextOverflow.ellipsis),
                        subtitle: Text(
                          '${chatData.getReadableTimestamp()} - ${chatData.lastSenderName ?? ''}: ${chatData.lastMessage}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            BackButtonTopLeft(
              top: 19,
              left: -0.5,
              onPressed: () {
                Navigator.of(context).pop();
              },
              arrowIcon: false,
            ),
          ],
        ),
      ),
    );
  }
}
