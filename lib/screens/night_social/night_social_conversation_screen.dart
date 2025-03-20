import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/input_decorations.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/generated/l10n.dart';
import 'package:nightview/helpers/users/chats/chat_helper.dart';
import 'package:nightview/models/users/chat_message_data.dart';
import 'package:nightview/helpers/users/chats/chat_subscriber.dart';
import 'package:nightview/helpers/users/misc/profile_picture_helper.dart';
import 'package:nightview/models/users/user_data.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:provider/provider.dart';

class NightSocialConversationScreen extends StatefulWidget {
  static const id = 'night_social_conversation_screen';

  const NightSocialConversationScreen({super.key});

  @override
  State<NightSocialConversationScreen> createState() =>
      _NightSocialConversationScreenState();
}

class _NightSocialConversationScreenState
    extends State<NightSocialConversationScreen> {
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? chatSubscription;
  TextEditingController messageController = TextEditingController();
  String _lastMessageTimestamp = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      String? chatId =
          Provider.of<GlobalProvider>(context, listen: false).chosenChatId;

      if (chatId == null) {
        return;
      }
      _lastMessageTimestamp = '';
      chatSubscription = Provider.of<ChatSubscriber>(context, listen: false)
          .subscribeToChat(chatId);
      String? otherId = await ChatHelper.getOtherMember(chatId);
      if (otherId == null) {
        Provider.of<GlobalProvider>(context, listen: false)
            .setChosenChatTitle(null);
        Provider.of<GlobalProvider>(context, listen: false)
            .setChosenChatPicture(null);
      } else {
        UserData? otherUser =
            Provider.of<GlobalProvider>(context, listen: false)
                .userDataHelper
                .userData[otherId];
        Provider.of<GlobalProvider>(context, listen: false).setChosenChatTitle(
            '${otherUser?.firstName} ${otherUser?.lastName}');
        String? otherPbUrl =
            await ProfilePictureHelper.getProfilePicture(otherId);
        Provider.of<GlobalProvider>(context, listen: false)
            .setChosenChatPicture(otherPbUrl);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    if (chatSubscription != null) {
      chatSubscription!.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(kMainPadding),
              child: Container(
                padding: EdgeInsets.all(kMainPadding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kMainBorderRadius),
                  border: Border.all(
                    width: kMainStrokeWidth,
                    color: Colors.white,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: Provider.of<GlobalProvider>(context)
                          .chosenChatPicture,
                    ),
                    SizedBox(
                      width: kSmallSpacerValue,
                    ),
                    Text(
                      Provider.of<GlobalProvider>(context).chosenChatTitle,
                      style: kTextStyleH3,
                      // overflow: TextOverflow.ellipsis, Fix overflow
                      // maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: ListView.separated(
                      reverse: true,
                      padding: EdgeInsets.all(kMainPadding),
                      itemCount:
                          Provider.of<ChatSubscriber>(context).messages.length,
                      itemBuilder: (context, index) {
                        ChatMessageData? message =
                            Provider.of<ChatSubscriber>(context, listen: false)
                                .messages
                                .values
                                .toList()
                                .reversed
                                .toList()[index];

                        bool bySelf = message.sender ==
                            Provider.of<GlobalProvider>(context, listen: false)
                                .userDataHelper
                                .currentUserId;

                        bool showTimestamp = message.getReadableTimestamp() !=
                            _lastMessageTimestamp;
                        _lastMessageTimestamp = message.getReadableTimestamp();

                        return Column(
                          children: [
                            Visibility(
                              visible: showTimestamp,
                              child: Text(
                                message.getReadableTimestamp(),
                                style: kTextStyleP2.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: kSmallSpacerValue,
                            ),
                            Align(
                              alignment: bySelf
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              child: Container(
                                padding: EdgeInsets.all(kMainPadding),
                                constraints: BoxConstraints(
                                  minWidth: 40.0,
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.75,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    kMainBorderRadius,
                                  ),
                                  border: Border.all(
                                    width: kMainStrokeWidth,
                                    color: bySelf ? primaryColor : Colors.white,
                                  ),
                                ),
                                child: Text(
                                  message.message,
                                  softWrap: true,
                                  style: kTextStyleP1.copyWith(
                                    color: bySelf ? primaryColor : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(
                        height: kSmallSpacerValue,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(kMainPadding),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: messageController,
                            decoration: kMainInputDecoration.copyWith(
                              hintText: S.of(context).write_here,
                            ),
                            cursorColor: primaryColor,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            String? chatId = Provider.of<GlobalProvider>(
                                    context,
                                    listen: false)
                                .chosenChatId;
                            String? userId = Provider.of<GlobalProvider>(
                                    context,
                                    listen: false)
                                .userDataHelper
                                .currentUserId;
                            if (chatId == null || userId == null) {
                              return;
                            }
                            ChatMessageData messageData = ChatMessageData(
                              sender: userId,
                              message: messageController.text,
                              timestamp: DateTime.now(),
                            );
                            if (await ChatHelper.sendChatMessage(
                                messageData, chatId)) {
                              messageController.text = "";
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    // AppLocalizations.of(context)!.sendingChatError,
                                    S.of(context).message_send_error,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.black,
                                ),
                              );
                            }
                          },
                          child: FaIcon(
                            FontAwesomeIcons.solidPaperPlane,
                            color: primaryColor,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
