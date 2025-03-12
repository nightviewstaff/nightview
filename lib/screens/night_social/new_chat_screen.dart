import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/app_localization.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/input_decorations.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/helpers/users/chats/chat_helper.dart';
import 'package:nightview/helpers/users/friends/friends_helper.dart';
import 'package:nightview/helpers/users/chats/search_new_chat_helper.dart';
import 'package:nightview/models/users/user_data.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/screens/night_social/night_social_conversation_screen.dart';
import 'package:provider/provider.dart';

class NewChatScreen extends StatefulWidget {
  static const id = 'new_chat_screen';

  const NewChatScreen({super.key});

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      List<String> friendIds = await FriendsHelper.getAllFriendIds();
      List<UserData> friends = friendIds
          .map((id) => Provider.of<GlobalProvider>(context, listen: false)
              .userDataHelper
              .userData[id]!)
          .toList();
      Provider.of<SearchNewChatHelper>(context, listen: false)
          .setFriends(friends);
    });
    super.initState();
  }

  ImageProvider getPb(int index) {
    try {
      return Provider.of<SearchNewChatHelper>(context).filteredFriendPbs[index];
    } catch (e) {
      return AssetImage('images/user_pb.jpg');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(kBigPadding),
              width: double.maxFinite,
              child: Text(
                // AppLocalizations.of(context)!.newChat,
                'Ny chat',
                style: kTextStyleH1,
              ),
            ),
            Container(
              padding: EdgeInsets.all(kMainPadding),
              color: black,
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.magnifyingGlass,
                    color: primaryColor,
                    size: 35.0,
                  ),
                  SizedBox(
                    width: kSmallSpacerValue,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: kSearchInputDecoration.copyWith(
                        hintText: 'Hvem vil du chatte med?',
                      ),
                      textCapitalization: TextCapitalization.words,
                      cursorColor: primaryColor,
                      onChanged: (String input) {
                        Provider.of<SearchNewChatHelper>(context, listen: false)
                            .updateSearch(input);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  UserData user =
                      Provider.of<SearchNewChatHelper>(context, listen: false)
                          .filteredFriends[index];

                  return ListTile(
                    onTap: () async {
                      String? newChatId =
                          await ChatHelper.createNewChat(user.id);

                      if (newChatId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              // AppLocalizations.of(context)!.createChatError,
                              'Kunne ikke oprette ny chat',
                              style: TextStyle(color: white),
                            ),
                            backgroundColor: black,
                          ),
                        );
                        return;
                      }
                      Provider.of<GlobalProvider>(context, listen: false)
                          .setChosenChatId(newChatId);
                      Navigator.of(context).pushReplacementNamed(
                          NightSocialConversationScreen.id);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kMainBorderRadius),
                      side: BorderSide(
                        width: kMainStrokeWidth,
                        color: white,
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundImage: getPb(index),
                    ),
                    title: Text(
                      '${user.firstName} ${user.lastName}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(
                  height: kSmallSpacerValue,
                ),
                itemCount: Provider.of<SearchNewChatHelper>(context)
                    .filteredFriends
                    .length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
