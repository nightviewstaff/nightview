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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final searchHelper =
          Provider.of<SearchFriendsHelper>(context, listen: false);
      searchHelper.reset();
      searchHelper.preloadInitialSuggestions(context);
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        Provider.of<SearchFriendsHelper>(context, listen: false)
            .loadMore(context);
      }
    });
  }

  ImageProvider getPb(int index) {
    final searchHelper =
        Provider.of<SearchFriendsHelper>(context, listen: false);
    return index < searchHelper.searchedUserPbs.length
        ? (searchHelper.searchedUserPbs[index] ??
            const AssetImage('images/user_pb.jpg'))
        : const AssetImage('images/user_pb.jpg');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(kBigPadding),
              color: black,
              width: double.maxFinite,
              child: Text(
                S.of(context).find_friends,
                style: kTextStyleH1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(kMainPadding),
              color: black,
              child: Row(
                children: [
                  const FaIcon(FontAwesomeIcons.magnifyingGlass,
                      color: primaryColor, size: 35.0),
                  const SizedBox(width: kSmallSpacerValue),
                  Expanded(
                    child: TextField(
                      decoration: kSearchInputDecoration.copyWith(
                          hintText: S.of(context).enter_name),
                      textCapitalization: TextCapitalization.words,
                      cursorColor: primaryColor,
                      onChanged: (input) {
                        Provider.of<SearchFriendsHelper>(context, listen: false)
                            .updateSearch(context, input);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<SearchFriendsHelper>(
                builder: (context, searchHelper, child) {
                  return ListView.separated(
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      if (index >= searchHelper.searchedUsers.length) {
                        return searchHelper.hasMore
                            ? const Center(child: CircularProgressIndicator())
                            : const SizedBox.shrink();
                      }
                      UserData user = searchHelper.searchedUsers[index];
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
                          side: const BorderSide(
                              width: kMainStrokeWidth, color: white),
                        ),
                        leading: CircleAvatar(
                          backgroundImage: getPb(index),
                          child: searchHelper.searchedUserPbs[index] == null
                              ? const CircularProgressIndicator()
                              : null,
                        ),
                        title: Text(
                          '${user.firstName} ${user.lastName}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          icon: const FaIcon(FontAwesomeIcons.userPlus,
                              color: primaryColor),
                          onPressed: () {
                            FriendRequestHelper.sendFriendRequest(user.id);
                            searchHelper.removeFromSearch(index);
                          },
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: kSmallSpacerValue),
                    itemCount: searchHelper.searchedUsers.length +
                        (searchHelper.hasMore ? 1 : 0),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
