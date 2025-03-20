import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/generated/l10n.dart';
import 'package:nightview/models/users/friend_request.dart';
import 'package:nightview/helpers/users/friends/friend_request_helper.dart';
import 'package:nightview/helpers/users/friends/friends_helper.dart';
import 'package:nightview/helpers/users/misc/profile_picture_helper.dart';
import 'package:nightview/models/users/user_data.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/screens/profile/other_profile_main_screen.dart';
import 'package:provider/provider.dart';

class FriendRequestsScreen extends StatefulWidget {
  static const id = 'friend_requests_screen';
  const FriendRequestsScreen({super.key});

  @override
  State<FriendRequestsScreen> createState() => _FriendRequestsScreenState();
}

class _FriendRequestsScreenState extends State<FriendRequestsScreen> {
  List<FriendRequest> friendRequests = [];
  List<ImageProvider> friendRequestPbs = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchRequests();
    });

    super.initState();
  }

  void fetchRequests() {
    Provider.of<GlobalProvider>(context, listen: false)
        .setFriendRequestsLoaded(false);

    FriendRequestHelper.getPendingFriendRequests().then((requests) async {
      friendRequests = requests.reversed.toList();
      friendRequestPbs.clear();
      for (FriendRequest request in friendRequests) {
        String? url =
            await ProfilePictureHelper.getProfilePicture(request.fromId);
        if (url == null) {
          friendRequestPbs.add(const AssetImage('images/user_pb.jpg'));
        } else {
          friendRequestPbs.add(CachedNetworkImageProvider(url));
        }
      }
      Provider.of<GlobalProvider>(context, listen: false)
          .setFriendRequestsLoaded(true);
    });
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
              color: Colors.black,
              width: double.maxFinite,
              child: Text(
                // AppLocalizations.of(context)!.friendRequests,
                S.of(context).friend_requests,
                style: kTextStyleH2,
              ),
            ),
            Visibility(
              visible:
                  Provider.of<GlobalProvider>(context).friendRequestsLoaded,
              replacement: Expanded(
                child: SpinKitPouringHourGlass(
                  color: primaryColor,
                  size: 150.0,
                  strokeWidth: 2.0,
                ),
              ),
              child: Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.all(kMainPadding),
                  itemBuilder: (context, index) {
                    FriendRequest request = friendRequests[index];

                    try {
                      UserData fromUserData =
                          Provider.of<GlobalProvider>(context)
                              .userDataHelper
                              .userData[request.fromId]!;

                      return ListTile(
                        onTap: () {
                          Provider.of<GlobalProvider>(context, listen: false)
                              .setChosenProfile(fromUserData);
                          Navigator.of(context)
                              .pushNamed(OtherProfileMainScreen.id);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(kMainBorderRadius),
                          side: BorderSide(
                            width: kMainStrokeWidth,
                            color: Colors.white,
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundImage: friendRequestPbs[index],
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${fromUserData.firstName} ${fromUserData.lastName}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                FriendRequestHelper.acceptFriendRequest(
                                        request.requestId)
                                    .then((value) => fetchRequests());
                                FriendsHelper.addFriend(request.fromId);
                              },
                              icon: FaIcon(
                                FontAwesomeIcons.check,
                                color: primaryColor,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                FriendRequestHelper.rejectFriendRequest(
                                        request.requestId)
                                    .then((value) => fetchRequests());
                              },
                              icon: FaIcon(
                                FontAwesomeIcons.x,
                                color: Colors.redAccent,
                              ),
                            )
                          ],
                        ),
                      );
                    } catch (e) {
                      return null;
                    }
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: kSmallSpacerValue,
                    );
                  },
                  itemCount: friendRequests.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
