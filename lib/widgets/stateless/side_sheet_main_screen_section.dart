import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/generated/l10n.dart';
// Add this for kMainPadding
import 'package:nightview/helpers/users/friends/friends_helper.dart';
import 'package:nightview/helpers/users/misc/profile_picture_helper.dart';
import 'package:nightview/models/users/user_data.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/screens/profile/other_profile_main_screen.dart';
import 'package:provider/provider.dart';

class SideSheetMainScreenSection extends StatelessWidget {
  const SideSheetMainScreenSection({super.key});

  /// Fetches friends who are out along with their profile picture URLs using GlobalProvider's cached data.
  Future<List<Map<String, dynamic>>> _getFriendsWithPbs(
      BuildContext context) async {
    // Get all friend IDs
    List<String> friendIds = await FriendsHelper.getAllFriendIds();
    print("Fetched friend IDs: $friendIds");

    // Get GlobalProvider
    final globalProvider = Provider.of<GlobalProvider>(context, listen: false);

    // Fetch friends from GlobalProvider's userData map (cached)
    List<UserData> friendsOut = [];
    for (String id in friendIds) {
      UserData? friend = globalProvider.userDataHelper.userData[id];
      if (friend != null && friend.partyStatus == PartyStatus.yes) {
        friendsOut.add(friend);
      }
    }

    print("Number of friends out: ${friendsOut.length}");
    for (var friend in friendsOut) {
      print("Friend ${friend.id}: partyStatus = ${friend.partyStatus}");
    }

    // Fetch profile pictures for friends who are out
    List<Map<String, dynamic>> friendsWithPbs = [];
    for (var friend in friendsOut) {
      String? pbUrl = await ProfilePictureHelper.getProfilePicture(friend.id);
      friendsWithPbs.add({
        'user': friend,
        'pbUrl': pbUrl,
      });
    }

    return friendsWithPbs;
  }

  /// Returns the border color based on the friend's party status.
  Color getStatusColor(PartyStatus? status) {
    if (status == null) return grey;
    switch (status) {
      case PartyStatus.yes:
        return primaryColor;
      case PartyStatus.no:
        return redAccent;
      case PartyStatus.unsure:
        return grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            Center(
              child: Text(
                S.of(context).friends_in_town_title,
                style: TextStyle(
                  color: white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: FutureBuilder(
                // Combine the two futures into a single Future
                future: Future.wait([
                  FriendsHelper.getAllFriendIds(),
                  _getFriendsWithPbs(context),
                ]),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.hasError ||
                      !snapshot.hasData) {
                    return SizedBox
                        .shrink(); // Match SideSheetMainScreen's behavior
                  }

                  // Extract data from the combined futures
                  List<String> friendIds = snapshot.data![0] as List<String>;
                  List<Map<String, dynamic>> friendsWithPbs =
                      snapshot.data![1] as List<Map<String, dynamic>>;

                  int totalFriends = friendIds.length;
                  int friendsOutCount = friendsWithPbs.length;

                  // Calculate if more than 50% of friends are out
                  bool moreThanHalfOut = totalFriends > 0
                      ? (friendsOutCount / totalFriends) >= 0.5
                      : false;

                  // Determine the color for friendsOutCount
                  Color friendsOutColor =
                      moreThanHalfOut ? primaryColor : redAccent;

                  return Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '$friendsOutCount',
                          style: TextStyle(
                            color: friendsOutColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: '/',
                          style: TextStyle(
                            color: white,
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          text: '$totalFriends',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 8.0), // Match SideSheetMainScreen
        SizedBox(
          height: 50.0, // Match SideSheetMainScreen
          width: 240.0, // Match SideSheetMainScreen for 5 icons
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _getFriendsWithPbs(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: secondaryColor),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    S.of(context).error_fetching_friends,
                    style: TextStyle(color: redAccent),
                  ),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    S.of(context).no_friends_in_town,
                    style: TextStyle(color: redAccent),
                  ),
                );
              }

              List<Map<String, dynamic>> friendsWithPbs = snapshot.data!;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(
                    friendsWithPbs.length,
                    (index) {
                      UserData user = friendsWithPbs[index]['user'];
                      String? pbUrl = friendsWithPbs[index]['pbUrl'];
                      return GestureDetector(
                        onTap: () {
                          Provider.of<GlobalProvider>(context, listen: false)
                              .setChosenProfile(user);
                          Navigator.of(context)
                              .pushNamed(OtherProfileMainScreen.id);
                          // Add navigation or action if needed, similar to SideSheetMainScreen
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: getStatusColor(user.partyStatus),
                                width: 2.0, // Match SideSheetMainScreen
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundImage: pbUrl != null
                                  ? NetworkImage(pbUrl)
                                  : const AssetImage('images/user_pb.jpg')
                                      as ImageProvider,
                              radius: 19.0, // Match SideSheetMainScreen
                              backgroundColor: secondaryColor,
                              onBackgroundImageError: (exception, stackTrace) {
                                print(
                                    'Image load error for ${user.id}: $exception');
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
