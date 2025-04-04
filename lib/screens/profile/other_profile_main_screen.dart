import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/generated/l10n.dart';
import 'package:nightview/constants/button_styles.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/helpers/users/misc/biography_helper.dart';
import 'package:nightview/helpers/users/friends/friend_request_helper.dart';
import 'package:nightview/helpers/users/friends/friends_helper.dart';
import 'package:nightview/models/users/location_data.dart';
import 'package:nightview/helpers/users/misc/profile_picture_helper.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/providers/night_map_provider.dart';
import 'package:provider/provider.dart';

class OtherProfileMainScreen extends StatefulWidget {
  static const id = 'other_profile_main_screen';

  const OtherProfileMainScreen({super.key});

  @override
  State<OtherProfileMainScreen> createState() => _OtherProfileMainScreenState();
}

class _OtherProfileMainScreenState extends State<OtherProfileMainScreen> {
  String lastLocationText = '';

  final TextEditingController biographyController = TextEditingController();

  ImageProvider? profilePicture;
  String? userId;
  bool isFriend = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      userId =
          Provider.of<GlobalProvider>(context, listen: false).chosenProfile?.id;
      if (userId == null) return;

      biographyController.text =
          await BiographyHelper.getBiography(userId!) ?? '';
      profilePicture = await ProfilePictureHelper.getProfilePicture(userId!)
          .then((url) => url == null ? null : CachedNetworkImageProvider(url));
      await checkFriendButton();

      // Fetch last location data.
      LocationData? locationData =
          await Provider.of<NightMapProvider>(context, listen: false)
              .locationHelper
              .getLastPositionOfUser(userId!);

      if (locationData == null) {
        lastLocationText = '';
      } else if (locationData.private) {
        lastLocationText = '';
      } else {
        String? clubName = Provider.of<GlobalProvider>(context, listen: false)
            .clubDataHelper
            .clubData[locationData.clubId]
            ?.name;
        if (clubName == null) {
          lastLocationText = '';
        }
        final now = DateTime.now();
        final sixMonthsAgo =
            now.subtract(const Duration(days: 182)); // Approx. 6 months
        final isOlderThanSixMonths =
            locationData.timestampAsDateTime.isBefore(sixMonthsAgo);

        if (isOlderThanSixMonths) {
          lastLocationText = '';
        } else {
          lastLocationText =
              '$clubName\nTidspunkt: ${locationData.readableTimestamp}';
        }

        setState(() {});
      }
    });
  }

  Future<void> checkFriendButton() async {
    isFriend = await FriendsHelper.isFriend(userId!);
    bool friendRequestSent = await FriendRequestHelper.userHasRequest(userId!);
    setState(() {
      // No extra widget; the friend button will be conditionally rendered.
      // If not a friend and no request sent, we'll show the add friend button.
    });
  }

  Widget removeFriendButton(BuildContext context) => IconButton(
        icon: FaIcon(
          FontAwesomeIcons.userMinus,
          color: Colors.redAccent,
          size: 15.0,
        ),
        tooltip: S.of(context).remove_friend,
        onPressed: () async {
          final confirmed = await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: Text(
                  S.of(context).remove_friend,
                  style: TextStyle(color: Colors.redAccent),
                ),
                content: Text(S.of(context).remove_friend_confirmation),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    child: Text(S.of(context).no,
                        style: TextStyle(color: primaryColor)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(true),
                    child: Text(S.of(context).yes,
                        style: TextStyle(color: Colors.redAccent)),
                  ),
                ],
              );
            },
          );

          if (confirmed == true) {
            await FriendsHelper.removeFriend(userId!);
            await checkFriendButton();
          }
        },
      );

  Widget addFriendButton() => FilledButton(
        onPressed: () async {
          await FriendRequestHelper.sendFriendRequest(userId!);
          await checkFriendButton();
        },
        style: kFilledButtonStyle,
        child: Padding(
          padding: EdgeInsets.all(kMainPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).add_friend,
                style: kTextStyleP2,
              ),
              FaIcon(FontAwesomeIcons.userPlus),
            ],
          ),
        ),
      );

  AlertDialog getDialog(BuildContext context, LocationData? locationData) {
    final String text;
    if (locationData == null) {
      text = '';
      // 'Kunne ikke finde seneste lokation';
    } else if (locationData.private) {
      text =

          // 'Denne person deler ikke sin lokation';
          '';
    } else {
      String? clubName = Provider.of<GlobalProvider>(context, listen: false)
          .clubDataHelper
          .clubData[locationData.clubId]
          ?.name;
      if (clubName == null) {
        text = S.of(context).latest_location;
      } else {
        text =
            '${S.of(context).location}: $clubName\n${S.of(context).time}: ${locationData.readableTimestamp}';
      }
    }
    return AlertDialog(
      title: Text(S.of(context).latest_location),
      content: Text(text),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            S.of(context).ok,
            style: TextStyle(color: primaryColor),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Provider.of<GlobalProvider>(context).chosenProfile == null
              ? S.of(context).invalid_user
              : '${Provider.of<GlobalProvider>(context).chosenProfile?.firstName} ${Provider.of<GlobalProvider>(context).chosenProfile?.lastName}',
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(color: primaryColor),
        ),
        actions: [
          if (isFriend) removeFriendButton(context),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Main content mimicking MyProfileMainScreen layout.
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(kMainPadding),
                  color: Colors.black,
                  child: Row(
                    children: [
                      // Left: Biography container.
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(kMainBorderRadius),
                            border: Border.all(
                              color: primaryColor,
                              width: kMainStrokeWidth,
                            ),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: kSmallSpacerValue),
                              Text(
                                S.of(context).bio,
                                style: kTextStyleH4,
                              ),
                              Divider(
                                color: primaryColor,
                                thickness: kMainStrokeWidth,
                              ),
                              Padding(
                                padding: EdgeInsets.all(kMainPadding),
                                child: TextField(
                                  controller: biographyController,
                                  decoration: InputDecoration.collapsed(
                                      hintText: S.of(context).no_bio),
                                  readOnly: true,
                                  maxLines: 8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: kNormalSpacerValue),
                      // Right: Profile picture and friend actions.
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundImage: profilePicture ??
                                AssetImage('images/user_pb.jpg'),
                            radius: 70.0,
                          ),
                          SizedBox(height: kNormalSpacerValue),
                          // Render either the remove or add friend button.

                          if (isFriend)
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: kSmallSpacerValue),
                              child: Row(
                                children: [
                                  Text(
                                    lastLocationText,
                                    style: kTextStyleP1,
                                  ),
                                  SizedBox(width: kSmallSpacerValue),
                                  // Icon(Icons.pin_drop),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                // You can add further content here if needed.

                // Add this inside your Column (as a sibling to your profile info container)

//TODO Add the favorite clubs of this user here.

// Todo add chaat here.
// Expanded(
//   child: Container(
//     decoration: BoxDecoration(
//       border: Border(
//         top: BorderSide(color: primaryColor, width: kMainStrokeWidth),
//       ),
//     ),
//     child: Column(
//       children: [
//         // Chat header
//         Padding(
//           padding: EdgeInsets.all(kMainPadding),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 backgroundImage: Provider.of<GlobalProvider>(context).chosenChatPicture,
//               ),
//               SizedBox(width: kSmallSpacerValue),
//               Expanded(
//                 child: Text(
//                   Provider.of<GlobalProvider>(context).chosenChatTitle,
//                   style: kTextStyleH3,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         // Chat messages list
//         Expanded(
//           child: ListView.separated(
//             reverse: true,
//             padding: EdgeInsets.all(kMainPadding),
//             itemCount: Provider.of<ChatSubscriber>(context).messages.length,
//             itemBuilder: (context, index) {
//               // Build your message widget here.
//               return Text("Message placeholder");
//             },
//             separatorBuilder: (context, index) => SizedBox(height: kSmallSpacerValue),
//           ),
//         ),
//         // Message input field
//         Padding(
//           padding: EdgeInsets.all(kMainPadding),
//           child: Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   decoration: kMainInputDecoration.copyWith(hintText: 'Aa'),
//                   cursorColor: primaryColor,
//                   textCapitalization: TextCapitalization.sentences,
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {
//                   // Send message logic goes here.
//                 },
//                 child: FaIcon(
//                   FontAwesomeIcons.solidPaperPlane,
//                   color: primaryColor,
//                 ),
//               )
//             ],
//           ),
//         ),
//       ],
//     ),
//   ),
// ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
