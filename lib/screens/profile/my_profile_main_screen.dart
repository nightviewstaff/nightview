import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/helpers/users/misc/biography_helper.dart';
import 'package:nightview/helpers/users/friends/friends_helper.dart';
import 'package:nightview/helpers/users/misc/profile_picture_helper.dart';
import 'package:nightview/models/users/user_data.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/screens/night_social/find_new_friends_screen.dart';
import 'package:nightview/screens/profile/other_profile_main_screen.dart';
import 'package:provider/provider.dart';

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
        title: const Text('Profil'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 18.0),
            // Todo figure out the diff and make some sort of variable / system
            child: GestureDetector(
              onTap: () {
                // TODO: Handle profile picture click
              },
              child: CircleAvatar(
                backgroundImage: const AssetImage('images/flags/dk.png'),
                radius: 15.0,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(kMainPadding),
              color: Colors.black,
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
                          Text('Biografi', style: kTextStyleH4),
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
                              textCapitalization: TextCapitalization.sentences,
                              cursorColor: primaryColor,
                              decoration: InputDecoration.collapsed(
                                  hintText: 'Skriv her',
                                  hintStyle: kTextStyleP1),
                              style: kTextStyleP1,
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
                            Provider.of<GlobalProvider>(context).profilePicture,
                        radius: 70.0,
                      ),
                      SizedBox(
                        height: kNormalSpacerValue,
                      ),
                      FilledButton(
                        onPressed: () async {
                          if (await ProfilePictureHelper
                              .pickCropResizeCompressAndUploadPb()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Profilbillede opdateret',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.black,
                              ),
                            );
                            String? currentUserId = Provider.of<GlobalProvider>(
                                    context,
                                    listen: false)
                                .userDataHelper
                                .currentUserId;
                            if (currentUserId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Der skete en fejl under indlæsning af profilbillede',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.black,
                                ),
                              );
                              return;
                            }
                            String? pbUrl =
                                await ProfilePictureHelper.getProfilePicture(
                                    currentUserId);
                            Provider.of<GlobalProvider>(context, listen: false)
                                .setProfilePicture(pbUrl);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Der skete en fejl under ændring af profilbillede',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.black,
                              ),
                            );
                          }
                        },
                        style: FilledButton.styleFrom(
                          side: BorderSide(color: primaryColor, width: 2.0),
                          // Outline color and width
                          backgroundColor: Colors.transparent,
                          // Transparent background
                          foregroundColor: primaryColor, // Text and icon color
                        ),
                        child: Text(
                          'Skift billede',
                          style: kTextStyleP1,
                        ),
                      ),
                      SizedBox(
                        height: kSmallSpacerValue,
                      ),
                      Visibility(
                        visible: Provider.of<GlobalProvider>(context)
                            .biographyChanged,
                        child: FilledButton(
                          onPressed: () async {
                            if (await BiographyHelper.setBiography(
                                biographyController.text)) {
                              Provider.of<GlobalProvider>(context,
                                      listen: false)
                                  .setBiographyChanged(false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Biografi opdateret',
                                    style: kTextStyleP1,
                                  ),
                                  backgroundColor: Colors.black,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Der skete en fejl under opdatering af biografi',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.black,
                                ),
                              );
                            }
                          },
                          style: FilledButton.styleFrom(
                            side: BorderSide(color: primaryColor, width: 2.0),
                            // Outline color and width
                            backgroundColor: Colors.transparent,
                            // Transparent background
                            foregroundColor: Colors.blue, // Text and icon color
                          ),
                          child: Text(
                            'Gem',
                            style: kTextStyleP1,
                          ),
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
                  Text(
                    'Venner',
                    style: kTextStyleH2,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(FindNewFriendsScreen.id);
                    },
                    icon: FaIcon(FontAwesomeIcons.userPlus),
                    color: primaryColor,
                  ),
                ],
              ),
            ),
            Visibility(
              visible: Provider.of<GlobalProvider>(context).friends.isNotEmpty,
              replacement: Expanded(
                child: SpinKitPouringHourGlass(
                  // TODO Make variable
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
                            width: kMainStrokeWidth,
                            color: primaryColor,
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundImage: getPb(index),
                        ),
                        title: Text(
                          '${user.firstName} ${user.lastName}',
                          overflow: TextOverflow.ellipsis,
                          style: kTextStyleP1,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                          height: kSmallSpacerValue,
                        ),
                    itemCount:
                        Provider.of<GlobalProvider>(context).friends.length),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
