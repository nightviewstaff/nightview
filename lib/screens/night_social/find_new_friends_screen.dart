import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/input_decorations.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/generated/l10n.dart';
import 'package:nightview/helpers/users/friends/friend_request_helper.dart';
import 'package:nightview/helpers/users/friends/search_friends_helper.dart';
import 'package:nightview/models/users/user_data.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/screens/profile/other_profile_main_screen.dart';
import 'package:provider/provider.dart';

class FindNewFriendsScreen extends StatefulWidget {
  static const id = 'find_new_friends_screen';

  const FindNewFriendsScreen({super.key});

  @override
  State<FindNewFriendsScreen> createState() => _FindNewFriendsScreenState();
}

class _FindNewFriendsScreenState extends State<FindNewFriendsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<SearchFriendsHelper>(context, listen: false).reset();
    });
  }

  ImageProvider getPb(int index) {
    try {
      return Provider.of<SearchFriendsHelper>(context, listen: false)
          .searchedUserPbs[index];
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
              color: black,
              width: double.maxFinite,
              child: Text(
                // AppLocalizations.of(context)!.findNewFriends,
                S.of(context).find_friends,
                style: kTextStyleH1,
                overflow: TextOverflow.ellipsis,
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
                        hintText: S.of(context).enter_name,
                      ),
                      textCapitalization: TextCapitalization.words,
                      cursorColor: primaryColor,
                      onChanged: (String input) {
                        Provider.of<SearchFriendsHelper>(context, listen: false)
                            .updateSearch(context, input);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    UserData user = Provider.of<SearchFriendsHelper>(context)
                        .searchedUsers[index];
                    return ListTile(
                      onTap: () {
                        Provider.of<GlobalProvider>(context, listen: false)
                            .setChosenProfile(user);
                        Navigator.of(context)
                            .pushNamed(OtherProfileMainScreen.id);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(kMainBorderRadius),
                          side: BorderSide(
                            width: kMainStrokeWidth,
                            color: white,
                          )),
                      leading: CircleAvatar(
                        backgroundImage: getPb(index),
                      ),
                      title: Text(
                        '${user.firstName} ${user.lastName}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                        icon: FaIcon(
                          FontAwesomeIcons.userPlus,
                        ),
                        onPressed: () {
                          FriendRequestHelper.sendFriendRequest(user.id);
                          Provider.of<SearchFriendsHelper>(context,
                                  listen: false)
                              .removeFromSearch(index);
                        },
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(
                        height: kSmallSpacerValue,
                      ),
                  itemCount: Provider.of<SearchFriendsHelper>(context)
                      .searchedUsers
                      .length),
            ),
          ],
        ),
      ),
    );
  }
}
