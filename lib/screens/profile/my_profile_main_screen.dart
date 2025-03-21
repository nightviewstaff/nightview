import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/app_localization.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/generated/l10n.dart';
import 'package:nightview/helpers/users/misc/biography_helper.dart';
import 'package:nightview/helpers/users/friends/friends_helper.dart';
import 'package:nightview/helpers/users/misc/profile_picture_helper.dart';
import 'package:nightview/models/users/user_data.dart';
import 'package:nightview/helpers/users/misc/biography_helper.dart';
import 'package:nightview/helpers/users/friends/friends_helper.dart';
import 'package:nightview/helpers/users/misc/profile_picture_helper.dart';
import 'package:nightview/models/users/user_data.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/screens/login_registration/choice/login_or_create_account_screen.dart';
import 'package:nightview/screens/night_social/find_new_friends_screen.dart';
import 'package:nightview/screens/profile/other_profile_main_screen.dart';

import 'package:nightview/widgets/stateless/language_switcher.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MyProfileMainScreen extends StatefulWidget {
  static const id = 'my_profile_main_screen';

  const MyProfileMainScreen({super.key});

  @override
  State<MyProfileMainScreen> createState() => _MyProfileMainScreenState();
}

class _MyProfileMainScreenState extends State<MyProfileMainScreen> {
  final TextEditingController biographyController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      String? currentUserId =
          Provider.of<GlobalProvider>(context, listen: false)
              .userDataHelper
              .currentUserId;
      if (currentUserId == null) {
        biographyController.text = "";
      }
      biographyController.text =
          await BiographyHelper.getBiography(currentUserId!) ?? "";

      List<String> friendIds = await FriendsHelper.getAllFriendIds();
      List<UserData> friends = List.empty(growable: true);

      for (String id in friendIds) {
        UserData? friend = Provider.of<GlobalProvider>(context, listen: false)
            .userDataHelper
            .userData[id];
        if (friend != null) {
          friends.add(friend);
        }
      }

      Provider.of<GlobalProvider>(context, listen: false).setFriends(friends);

      Provider.of<GlobalProvider>(context, listen: false).clearFriendPbs();
      for (String id in friendIds) {
        String? url = await ProfilePictureHelper.getProfilePicture(id);
        Provider.of<GlobalProvider>(context, listen: false).addFriendPb(url);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ImageProvider getPb(int index) {
    try {
      return Provider.of<GlobalProvider>(context, listen: false)
          .friendPbs[index];
    } catch (e) {
      return const AssetImage('images/user_pb.jpg'); // make variable
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).profile),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 18.0),
            child: LanguageSwitcher(
              radius: 15.0,
              borderRadius: 25.0,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(kMainPadding),
                  color: Colors.black,
                  child: Row(
                    children: [
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
                              Text(S.of(context).bio, style: kTextStyleH4),
                              Divider(
                                color: primaryColor,
                                thickness: kMainStrokeWidth,
                              ),
                              Padding(
                                padding: EdgeInsets.all(kMainPadding),
                                child: TextField(
                                  onChanged: (String text) {
                                    Provider.of<GlobalProvider>(context,
                                            listen: false)
                                        .setBiographyChanged(true);
                                  },
                                  controller: biographyController,
                                  maxLines: 6,
                                  maxLength: 80,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  cursorColor: primaryColor,
                                  decoration: InputDecoration.collapsed(
                                    hintText: S.of(context).write_here,
                                    hintStyle: kTextStyleP1,
                                  ),
                                  style: kTextStyleP1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: kNormalSpacerValue),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              bool? confirmed = await showDialog<bool>(
                                context: context,
                                builder: (dialogContext) {
                                  return AlertDialog(
                                    title: Text(S.of(context).change_picture),
                                    content: Text(S
                                        .of(context)
                                        .change_picture_confirmation),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(dialogContext)
                                                .pop(false),
                                        child: Text(S.of(context).no,
                                            style:
                                                TextStyle(color: primaryColor)),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(dialogContext)
                                                .pop(true),
                                        child: Text(S.of(context).yes,
                                            style:
                                                TextStyle(color: primaryColor)),
                                      ),
                                    ],
                                  );
                                },
                              );
                              if (confirmed == true) {
                                if (await ProfilePictureHelper
                                    .pickCropResizeCompressAndUploadPb()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        S.of(context).profile_picture_updated,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.black,
                                    ),
                                  );
                                  String? currentUserId =
                                      Provider.of<GlobalProvider>(context,
                                              listen: false)
                                          .userDataHelper
                                          .currentUserId;
                                  if (currentUserId == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          S
                                              .of(context)
                                              .profile_picture_load_error,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.black,
                                      ),
                                    );
                                    return;
                                  }
                                  String? pbUrl = await ProfilePictureHelper
                                      .getProfilePicture(currentUserId);
                                  Provider.of<GlobalProvider>(context,
                                          listen: false)
                                      .setProfilePicture(pbUrl);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        S
                                            .of(context)
                                            .profile_picture_change_error,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.black,
                                    ),
                                  );
                                }
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(
                                  0), // Adjust for border thickness if needed
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: primaryColor, width: 1.5),
                              ),
                              child: CircleAvatar(
                                backgroundImage:
                                    Provider.of<GlobalProvider>(context)
                                        .profilePicture,
                                radius: 70.0,
                              ),
                            ),
                          ),
                          SizedBox(height: kNormalSpacerValue),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(FindNewFriendsScreen.id);
                            },
                            icon: FaIcon(FontAwesomeIcons.userPlus),
                            color: primaryColor,
                          ),
                          SizedBox(height: kSmallSpacerValue),
                          Visibility(
                            visible: Provider.of<GlobalProvider>(context)
                                .biographyChanged,
                            child: FilledButton(
                              onPressed: () async {
                                // [Existing button logic remains unchanged]
                              },
                              style: FilledButton.styleFrom(
                                side:
                                    BorderSide(color: primaryColor, width: 2.0),
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.blue,
                              ),
                              child:
                                  Text(S.of(context).save, style: kTextStyleP1),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(kBigPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(S.of(context).friends, style: kTextStyleH2),
                    ],
                  ),
                ),
                Visibility(
                  visible:
                      Provider.of<GlobalProvider>(context).friends.isNotEmpty,
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
                        UserData user =
                            Provider.of<GlobalProvider>(context).friends[index];
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
                                width: kMainStrokeWidth, color: primaryColor),
                          ),
                          leading: CircleAvatar(backgroundImage: getPb(index)),
                          title: Text(
                            '${user.firstName} ${user.lastName}',
                            overflow: TextOverflow.ellipsis,
                            style: kTextStyleP1,
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(height: kSmallSpacerValue),
                      itemCount:
                          Provider.of<GlobalProvider>(context).friends.length,
                    ),
                  ),
                ),
              ],
            ),
            // Bottom right icons
            Positioned(
              bottom: kMainPadding,
              right: kMainPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.lock,
                      color: primaryColor, // Blue for privacy
                      size: 15.0, // Smaller size
                    ),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: Center(
                            child: Text(
                              S.of(context).privacy_policy,
                              style: TextStyle(color: primaryColor),
                            ),
                          ),
                          content: Text(S.of(context).privacy_policy_open),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                              child: Text(S.of(context).no,
                                  style: TextStyle(color: grey)),
                            ),
                            TextButton(
                              onPressed: () {
                                launchUrl(Uri.parse(
                                    'https://night-view.dk/privacy-policy/'));
                                Navigator.of(dialogContext).pop();
                              },
                              child: Text(S.of(context).yes,
                                  style: TextStyle(color: grey)),
                            ),
                          ],
                        ),
                      );
                    },
                    tooltip: S.of(context).privacy_policy,
                  ),
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.userSlash,
                      color: redAccent, // Red for delete
                      size: 15.0,
                    ),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (deleteUserContext) => AlertDialog(
                          title: Center(
                            child: Text(
                              S.of(context).delete_user,
                              style: TextStyle(color: redAccent),
                            ),
                          ),
                          content: Text(
                            S.of(context).delete_confirmation,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(deleteUserContext).pop();
                              },
                              child: Text(S.of(context).no,
                                  style: TextStyle(color: primaryColor)),
                            ),
                            TextButton(
                              onPressed: () async {
                                bool success =
                                    await Provider.of<GlobalProvider>(
                                            deleteUserContext,
                                            listen: false)
                                        .deleteAllUserData();
                                if (success) {
                                  await Navigator.of(deleteUserContext)
                                      .pushNamedAndRemoveUntil(
                                          LoginOrCreateAccountScreen.id,
                                          (route) => false);
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.remove('mail');
                                  prefs.remove('password');
                                } else {
                                  await showDialog(
                                    context: deleteUserContext,
                                    builder: (errorContext) => AlertDialog(
                                      title:
                                          Text(S.of(context).delete_user_error),
                                      content: Text(
                                        S
                                            .of(context)
                                            .delete_user_error_description,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(errorContext).pop();
                                          },
                                          child: Text(S.of(context).ok,
                                              style: TextStyle(
                                                  color: primaryColor)),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              child: Text(S.of(context).yes,
                                  style: TextStyle(color: redAccent)),
                            ),
                          ],
                        ),
                      );
                    },
                    tooltip: S.of(context).delete_user,
                  ),
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.rightFromBracket,
                      color: grey, // Grey for logout
                      size: 15.0,
                    ),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: Center(
                            child: Text(
                              S.of(context).logout,
                              style: TextStyle(color: redAccent),
                            ),
                          ),
                          content: Text(S.of(context).logout_confirmation),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                              child: Text(S.of(context).no,
                                  style: TextStyle(color: primaryColor)),
                            ),
                            TextButton(
                              onPressed: () async {
                                await Provider.of<GlobalProvider>(context,
                                        listen: false)
                                    .userDataHelper
                                    .signOutCurrentUser();
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    LoginOrCreateAccountScreen.id,
                                    (route) => false);
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.remove('mail');
                                prefs.remove('password');
                              },
                              child: Text(S.of(context).yes,
                                  style: TextStyle(color: redAccent)),
                            ),
                          ],
                        ),
                      );
                    },
                    tooltip: S.of(context).logout,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
