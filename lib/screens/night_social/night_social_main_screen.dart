import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/models/users/chat_data.dart';
import 'package:nightview/helpers/users/chats/chat_subscriber.dart';
import 'package:nightview/helpers/users/friends/friend_request_helper.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/screens/night_social/find_new_friends_screen.dart';
import 'package:nightview/screens/night_social/friend_requests_screen.dart';
import 'package:nightview/screens/night_social/new_chat_screen.dart';
import 'package:nightview/screens/night_social/night_social_conversation_screen.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';

class NightSocialMainScreen extends StatefulWidget {
  static const id = 'night_social_main_screen';

  const NightSocialMainScreen({super.key});

  @override
  State<NightSocialMainScreen> createState() => _NightSocialMainScreenState();
}

class _NightSocialMainScreenState extends State<NightSocialMainScreen> {
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? chatsSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      chatsSubscription = Provider.of<ChatSubscriber>(context, listen: false)
          .subscribeToUsersChats(context);
      checkPending();
    });
    Provider.of<GlobalProvider>(context, listen: false).fetchUserLocation();
  }

  @override
  void dispose() {
    if (chatsSubscription != null) {
      chatsSubscription!.cancel();
    }
    super.dispose();
  }

  void checkPending() {
    FriendRequestHelper.pendingFriendRequests().then((pending) {
      Provider.of<GlobalProvider>(context, listen: false)
          .setPendingFriendRequests(pending);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(kBigPadding),
          color: black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                // AppLocalizations.of(context)!.chats,
                'Chats',
                style: kTextStyleH1,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(NewChatScreen.id);
                    },
                    icon: FaIcon(
                      FontAwesomeIcons.penToSquare,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(FindNewFriendsScreen.id);
                    },
                    icon: FaIcon(
                      FontAwesomeIcons.userPlus,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Visibility(
          visible: Provider.of<GlobalProvider>(context).pendingFriendRequests,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(FriendRequestsScreen.id);
            },
            child: Container(
              padding: EdgeInsets.all(kBigPadding),
              color: black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    // AppLocalizations.of(context)!.newFriendRequests,
                    'Nye venneanmodninger',
                    style: kTextStyleH3,
                  ),
                  FaIcon(FontAwesomeIcons.arrowRight),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.all(kMainPadding),
            itemCount: Provider.of<ChatSubscriber>(context).chats.length,
            itemBuilder: (context, index) {
              ChatData chatData =
                  Provider.of<ChatSubscriber>(context, listen: false)
                      .chats
                      .values
                      .toList()
                      .reversed
                      .toList()[index];
              String? userId =
                  Provider.of<GlobalProvider>(context, listen: false)
                      .userDataHelper
                      .currentUserId;

              if (userId == null) {
                return null;
              }

              return ListTile(
                onTap: () {
                  Provider.of<GlobalProvider>(context, listen: false)
                      .setChosenChatId(chatData.id);
                  Navigator.of(context)
                      .pushNamed(NightSocialConversationScreen.id);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kMainBorderRadius),
                  side: BorderSide(
                    color: white,
                    width: kMainStrokeWidth,
                  ),
                ),
                leading: CircleAvatar(
                  backgroundImage: Provider.of<ChatSubscriber>(context)
                      .chatImages[chatData.id],
                ),
                title: Text(
                  chatData.title ?? '',
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${chatData.getReadableTimestamp()} - ${chatData.lastSenderName ?? ''}: ${chatData.lastMessage}',
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
            separatorBuilder: (context, index) => SizedBox(
              height: kSmallSpacerValue,
            ),
          ),
        ),
      ],
    );
  }
}
