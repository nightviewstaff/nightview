import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/app_localization.dart';
import 'package:nightview/constants/button_styles.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/helpers/users/misc/biography_helper.dart';
import 'package:nightview/helpers/users/friends/friend_request_helper.dart';
import 'package:nightview/helpers/users/friends/friends_helper.dart';
import 'package:nightview/models/users/location_data.dart';
import 'package:nightview/helpers/users/misc/profile_picture_helper.dart';
import 'package:nightview/models/users/user_data.dart';
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
  final TextEditingController biographyController = TextEditingController();

  ImageProvider? profilePicture;
  Widget? friendButton;
  String? userId;
  bool isFriend = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      userId =
          Provider.of<GlobalProvider>(context, listen: false).chosenProfile?.id;

      if (userId == null) {
        return;
      }

      biographyController.text =
          await BiographyHelper.getBiography(userId!) ?? '';
      profilePicture = await ProfilePictureHelper.getProfilePicture(userId!)
          .then((url) => url == null ? null : CachedNetworkImageProvider(url));
      setState(() {});

      await checkFriendButton();
    });

    super.initState();
  }

  Future<void> checkFriendButton() async {
    isFriend = await FriendsHelper.isFriend(userId!);
    bool friendRequestSent = await FriendRequestHelper.userHasRequest(userId!);

    setState(() {
      if (isFriend) {
        friendButton = removeFriendButton();
      } else if (!friendRequestSent) {
        friendButton = addFriendButton();
      } else {
        friendButton = null;
      }
    });
  }

  Widget removeFriendButton() => FilledButton(
        onPressed: () async {
          await FriendsHelper.removeFriend(userId!);
          checkFriendButton();
        },
        style: kFilledButtonStyle.copyWith(
          backgroundColor: WidgetStatePropertyAll(Colors.redAccent),
        ),
        child: Padding(
          padding: EdgeInsets.all(kMainPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                // AppLocalizations.of(context)!.removeFriend,
                'Fjern ven',
                style: kTextStyleH4,
              ),
              FaIcon(FontAwesomeIcons.userMinus),
            ],
          ),
        ),
      );

  Widget addFriendButton() => FilledButton(
        onPressed: () async {
          await FriendRequestHelper.sendFriendRequest(userId!);
          checkFriendButton();
        },
        style: kFilledButtonStyle,
        child: Padding(
          padding: EdgeInsets.all(kMainPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                // AppLocalizations.of(context)!.addFriend,
                'Tilføj ven',
                style: kTextStyleH2,
              ),
              FaIcon(FontAwesomeIcons.userPlus),
            ],
          ),
        ),
      );

  AlertDialog getDialog(BuildContext context, LocationData? locationData) {
    final String text;
    if (locationData == null) {
      text =
          // AppLocalizations.of(context)!.noLatestLocation,
          'Kunne ikke finde seneste lokation';
    } else if (locationData.private) {
      text =
          // AppLocalizations.of(context)!.userNotSharingLocation,
          'Denne person deler ikke sin lokation';
    } else {
      // Add check for more than 100 days ago
      String? clubName = Provider.of<GlobalProvider>(context, listen: false)
          .clubDataHelper
          .clubData[locationData.clubId]
          ?.name;
      if (clubName == null) {
        text =
            // AppLocalizations.of(context)!.noLatestLocation,
            'Kunne ikke finde seneste lokation';
      } else {
        text =

            // AppLocalizations.of(context)!.location
            // AppLocalizations.of(context)!.time
            'Lokation: $clubName\nTidspunkt: ${locationData.readableTimestamp}';
      }
    }
    return AlertDialog(
      title: Text(
          // AppLocalizations.of(context)!.latestLocation,
          'Seneste lokation'),
      content: Text(text),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            AppLocalizations.of(context)!.okay,
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
        title: Text(Provider.of<GlobalProvider>(context).chosenProfile == null
            ?
            // AppLocalizations.of(context)!.invalidUser,
            'Ugyldig bruger'
            : '${Provider.of<GlobalProvider>(context).chosenProfile?.firstName} ${Provider.of<GlobalProvider>(context).chosenProfile?.lastName}'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(kMainPadding),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kMainBorderRadius),
                        border: Border.all(
                          color: primaryColor,
                          width: kMainStrokeWidth,
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: kSmallSpacerValue,
                          ),
                          Text(
                            // AppLocalizations.of(context)!.biography,
                            'Biografi',
                            style: kTextStyleH3,
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
                                  hintText:
// AppLocalizations.of(context)!.userHasNoBiography,
                                      'Denne bruger har ikke angivet en biografi'),
                              readOnly: true,
                              maxLines: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: kNormalSpacerValue,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            profilePicture ?? AssetImage('images/user_pb.jpg'),
                        radius: 60.0,
                      ),
                      SizedBox(
                        height: kNormalSpacerValue,
                      ),
                      Visibility(
                        visible: isFriend,
                        child: FilledButton(
                          // Change color
                          onPressed: () async {
                            UserData? user = Provider.of<GlobalProvider>(
                                    context,
                                    listen: false)
                                .chosenProfile;
                            if (user == null) {
                              return;
                            }
                            LocationData? lastLocation =
                                await Provider.of<NightMapProvider>(context,
                                        listen: false)
                                    .locationHelper
                                    .getLastPositionOfUser(user.id);
                            await showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) =>
                                  getDialog(context, lastLocation),
                            );
                          },
                          style: kTransparentButtonStyle,
                          child: Row(
                            children: [
                              Text(
                                // AppLocalizations.of(context)!.find,
                                'Find',
                                style: kTextStyleP1,
                              ),
                              SizedBox(
                                width: kSmallSpacerValue,
                              ),
                              Icon(Icons.pin_drop),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(kMainPadding),
              child: friendButton,
            ),
          ],
        ),
      ),
    );
  }
}
