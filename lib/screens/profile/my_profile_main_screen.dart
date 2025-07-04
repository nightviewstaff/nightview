import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/constants/icons.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/generated/l10n.dart';
import 'package:nightview/helpers/users/misc/biography_helper.dart';
import 'package:nightview/helpers/users/friends/friends_helper.dart';
import 'package:nightview/helpers/users/misc/profile_picture_helper.dart';
import 'package:nightview/models/users/user_data.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/screens/night_social/find_new_friends_screen.dart';
import 'package:nightview/screens/profile/other_profile_main_screen.dart';
import 'package:nightview/screens/utility/bottom_menu_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nightview/screens/night_social/utility/image_upload_screen.dart';

import 'package:nightview/widgets/stateless/language_switcher.dart';
import 'package:provider/provider.dart';

class MyProfileMainScreen extends StatefulWidget {
  static const id = 'my_profile_main_screen';

  const MyProfileMainScreen({super.key});

  @override
  State<MyProfileMainScreen> createState() => _MyProfileMainScreenState();
}

class _MyProfileMainScreenState extends State<MyProfileMainScreen> {
  final TextEditingController biographyController = TextEditingController();
  late Future<void> _loadFriendsFuture;
  bool showImages = true;

  @override
  void initState() {
    super.initState();
    _loadFriendsFuture = _loadFriendsData();
  }

  Future<void> _loadFriendsData() async {
    // Fetch biography
    String? currentUserId = Provider.of<GlobalProvider>(context, listen: false)
        .userDataHelper
        .currentUserId;
    biographyController.text = currentUserId != null
        ? await BiographyHelper.getBiography(currentUserId) ?? ""
        : "";

    // Fetch and sort friends
    List<String> friendIds = await FriendsHelper.getAllFriendIds();
    List<UserData> friends = [];
    for (String id in friendIds) {
      UserData? friend = Provider.of<GlobalProvider>(context, listen: false)
          .userDataHelper
          .userData[id];
      if (friend != null) {
        friends.add(friend);
      }
    }

    friends.sort((a, b) {
      int priorityA = _getStatusPriority(a.partyStatus);
      int priorityB = _getStatusPriority(b.partyStatus);
      return priorityA.compareTo(priorityB);
    });

    Provider.of<GlobalProvider>(context, listen: false).setFriends(friends);

    // Populate friendPbs in sorted order
    Provider.of<GlobalProvider>(context, listen: false).clearFriendPbs();
    for (UserData friend in friends) {
      String? url = await ProfilePictureHelper.getProfilePicture(friend.id);
      Provider.of<GlobalProvider>(context, listen: false).addFriendPb(url);
    }
  }

  int _getStatusPriority(PartyStatus? status) {
    if (status == null) return 3;
    switch (status) {
      case PartyStatus.yes:
        return 0;
      case PartyStatus.unsure:
        return 1;
      case PartyStatus.no:
        return 2;
      default:
        return 3;
    }
  }

  ImageProvider getPb(int index) {
    try {
      return Provider.of<GlobalProvider>(context, listen: false)
          .friendPbs[index];
    } catch (e) {
      return const AssetImage('images/user_pb.jpg');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).profile),
        actions: const [
          ProfileMenuDropdown(),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
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
                              padding: EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Provider.of<GlobalProvider>(context)
                                      .partyStatusColor,
                                  width: 1.5,
                                ),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        Provider.of<GlobalProvider>(context)
                                            .profilePicture,
                                    radius: 70.0,
                                  ),
                                  if (Provider.of<GlobalProvider>(context)
                                          .profilePicture is AssetImage &&
                                      (Provider.of<GlobalProvider>(context)
                                                  .profilePicture as AssetImage)
                                              .assetName ==
                                          'images/user_pb.jpg')
                                    Text(
                                      S.of(context).choose_picture, //TODO
                                      style:
                                          kTextStyleP1.copyWith(color: white),
                                      textAlign: TextAlign.center,
                                    ),
                                ],
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showImages = true;
                          });
                        },
                        child: Text(
                          "My Images",
                          style: kTextStyleH2.copyWith(
                            color: showImages ? primaryColor : white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showImages = false;
                          });
                        },
                        child: Text(
                          S.of(context).friends,
                          style: kTextStyleH2.copyWith(
                            color: !showImages ? primaryColor : white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: showImages
                      ? GridView.count(
                          crossAxisCount: 3,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          childAspectRatio: 0.7,
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          children: [
                            //TODO IF LESS THAN 6 IMAGES
                            GestureDetector(
                              onTap: () async {
                                final picker = ImagePicker();

                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: black,
                                  builder: (ctx) => SafeArea(
                                    child: Wrap(
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.camera_alt,
                                              color: primaryColor),
                                          title: const Text('Take a photo',
                                              selectionColor: white),
                                          onTap: () async {
                                            final image =
                                                await picker.pickImage(
                                                    source: ImageSource.camera);
                                            if (image != null &&
                                                context.mounted) {
                                              Navigator.pop(ctx);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      ImageUploadScreen(
                                                          image: image),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(
                                              Icons.photo_library,
                                              color: secondaryColor),
                                          title: const Text(
                                              'Choose from gallery',
                                              selectionColor: white),
                                          onTap: () async {
                                            final image =
                                                await picker.pickImage(
                                                    source:
                                                        ImageSource.gallery);
                                            if (image != null &&
                                                context.mounted) {
                                              Navigator.pop(ctx);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      ImageUploadScreen(
                                                          image: image),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: grey, width: 0.7),
                                    borderRadius: BorderRadius.circular(33),
                                    color: secondaryColor),
                                child: Center(
                                  child: Icon(Icons.add_a_photo_outlined,
                                      color: white, size: 24),
                                ),
                              ),
                            ),
                            ...[
                              "images/swipe/99.png",
                              "images/swipe/12.png",
                              "images/swipe/2.png",
                              "images/swipe/4.png",
                              "images/swipe/13.png",
                              "images/swipe/11.png",
                              "images/swipe/10.png",
                              "images/swipe/8.png"
                            ].map(
                              (path) => GestureDetector(
                                onTap: () {
                                  final screenSize =
                                      MediaQuery.of(context).size;
                                  final dialogWidth = screenSize.width * 0.95;
                                  final dialogHeight = screenSize.height * 0.65;

                                  showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (_) {
                                      return Dialog(
                                        child: SizedBox(
                                          width: dialogWidth,
                                          height: dialogHeight,
                                          child: Column(
                                            children: [
                                              ClipRRect(
                                                borderRadius: const BorderRadius
                                                    .vertical(
                                                    top: Radius.circular(12),
                                                    bottom:
                                                        Radius.circular(12)),
                                                child: Image.asset(
                                                  path,
                                                  width: dialogWidth,
                                                  height: dialogHeight,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                              const Spacer(),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(33),
                                  child: Image.asset(
                                    path,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : FutureBuilder<void>(
                          future: _loadFriendsFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Expanded(
                                child: Center(
                                  child: SpinKitPouringHourGlass(
                                    color: primaryColor,
                                    size: 150.0,
                                    strokeWidth: 2.0,
                                  ),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Expanded(
                                child: Center(
                                  child: Text(
                                    'Error loading friends',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              );
                            }
                            return Expanded(
                              child: ListView.separated(
                                padding: EdgeInsets.fromLTRB(
                                  kMainPadding,
                                  kMainPadding,
                                  kMainPadding,
                                  kMainPadding +
                                      60.0, // Add padding to avoid overlap with menu icons
                                ),
                                itemBuilder: (context, index) {
                                  UserData user =
                                      Provider.of<GlobalProvider>(context)
                                          .friends[index];
                                  return ListTile(
                                    onTap: () {
                                      Provider.of<GlobalProvider>(context,
                                              listen: false)
                                          .setChosenProfile(user);
                                      Navigator.of(context)
                                          .pushNamed(OtherProfileMainScreen.id);
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          kMainBorderRadius),
                                      side: BorderSide(
                                        width: kMainStrokeWidth,
                                        color: getStatusColor(user.partyStatus),
                                      ),
                                    ),
                                    leading: Container(
                                      padding: EdgeInsets.all(0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color:
                                              getStatusColor(user.partyStatus),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        backgroundImage: getPb(index),
                                        radius: 20.0,
                                      ),
                                    ),
                                    title: Text(
                                      '${user.firstName} ${user.lastName}',
                                      overflow: TextOverflow.ellipsis,
                                      style: kTextStyleP1,
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: kSmallSpacerValue),
                                itemCount: Provider.of<GlobalProvider>(context)
                                    .friends
                                    .length,
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
}
