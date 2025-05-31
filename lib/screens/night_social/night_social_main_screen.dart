import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marquee/marquee.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/icons.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/screens/night_social/utility/image_upload_screen.dart';
import 'package:provider/provider.dart';

class NightSocialMainScreen extends StatelessWidget {
  static const id = 'night_social_main_screen';

  const NightSocialMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final usedWidth = screenWidth * 1.7 / 3;
    final usedHeight = usedWidth * (16 / 9);
    final remaingWidth = screenWidth - usedWidth;
    final widthBetweenLeftAndRightSide = 8.0;
    final heightBetweenFeeds = usedHeight / 7;

    return Scaffold(
      backgroundColor: black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kSmallSpacerValue),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: Text left + Icon right
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "For you",
                  style: TextStyle(
                    color: white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('chats_screen');
                  },
                  child: const Icon(Icons.send, color: white),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Scrollable avatars row
            SizedBox(
              height: 60,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 111,
                separatorBuilder: (_, __) => const SizedBox(width: 0),
                itemBuilder: (context, index) {
                  onAvatarTap() {
                    if (index == 0) {
                      final picker = ImagePicker();

                      showModalBottomSheet(
                        context: context,
                        backgroundColor: black,
                        builder: (ctx) => SafeArea(
                          child: Wrap(
                            children: [
                              ListTile(
                                leading: const Icon(
                                  Icons.camera_alt,
                                  color: primaryColor,
                                ),
                                title: const Text(
                                  'Take a photo',
                                  selectionColor: white,
                                ),
                                onTap: () async {
                                  final image = await picker.pickImage(
                                      source: ImageSource.camera);
                                  if (image != null && context.mounted) {
                                    Navigator.pop(ctx);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ImageUploadScreen(image: image),
                                      ),
                                    );
                                  }
                                },
                              ),
                              ListTile(
                                leading: const Icon(
                                  Icons.photo_library,
                                  color: secondaryColor,
                                ),
                                title: const Text(
                                  'Choose from gallery',
                                  selectionColor: white,
                                ),
                                onTap: () async {
                                  final image = await picker.pickImage(
                                      source: ImageSource.gallery);
                                  if (image != null && context.mounted) {
                                    Navigator.pop(ctx);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ImageUploadScreen(image: image),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      print('TOP Avatar $index tapped');
                    }
                  }

                  if (index == 0) {
                    return GestureDetector(
                      onTap: onAvatarTap,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: secondaryColor,
                            child: CircleAvatar(
                              radius: 26,
                              backgroundImage: context
                                  .watch<GlobalProvider>()
                                  .profilePicture,
                            ),
                          ),
                          const Positioned(
                            bottom: 1,
                            right: 5,
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: secondaryColorLight,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  defaultPlusIcon,
                                  size: 14,
                                  color: white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return GestureDetector(
                      onTap: onAvatarTap,
                      child: const CircleAvatar(
                        radius: 35,
                        backgroundColor: secondaryColor,
                        child: CircleAvatar(
                          radius: 26,
                          backgroundImage: AssetImage('images/user_pb.jpg'),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),

            const Divider(
              color: white,
              indent: 6,
              endIndent: 6,
              thickness: 0.5,
            ),
            const SizedBox(height: 30),

            // Main content
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Side
                SizedBox(
                  width: usedWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: usedHeight,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            GestureDetector(
                              onTap: () => _showOfferDialog(
                                  context, 'images/swipe/1.png'),
                              child: Container(
                                height: usedHeight,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(75),
                                  image: const DecorationImage(
                                    image: AssetImage('images/swipe/1.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: -30,
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.purple,
                                    backgroundImage:
                                        AssetImage('images/user_pb.jpg'),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: black.withOpacity(0.6),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          "Poul Magne Skov",
                                          style: TextStyle(
                                            color: white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "L'Aquarium Club Paris.",
                                          style: TextStyle(
                                            color: white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Sammen med:",
                            style: TextStyle(color: white, fontSize: 12),
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: SizedBox(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(21, (index) {
                                    return const Padding(
                                      padding: EdgeInsets.only(right: 4),
                                      child: CircleAvatar(
                                        radius: 9.5,
                                        backgroundImage:
                                            AssetImage('images/user_pb.jpg'),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: const [
                          Icon(Icons.favorite_border,
                              color: redAccent, size: 25),
                          SizedBox(width: 15),
                          Icon(Icons.mode_comment_outlined,
                              color: white, size: 25),
                          SizedBox(width: 15),
                          Icon(Icons.send, color: white, size: 25),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(width: widthBetweenLeftAndRightSide),

                // Right Side
                SizedBox(
                  height: usedHeight
                  //  + 46
                  ,
                  width: remaingWidth - widthBetweenLeftAndRightSide * 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Kommentarer",
                        style: TextStyle(
                          color: white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: const [
                              CommentItem(),
                              Divider(
                                  height: 0.1, thickness: 0.1, color: white),
                              CommentItem(),
                              Divider(
                                  height: 0.1, thickness: 0.1, color: white),
                              CommentItem(),
                              Divider(
                                  height: 0.1, thickness: 0.1, color: white),
                              CommentItem(),
                              Divider(
                                  height: 0.1, thickness: 0.1, color: white),
                              CommentItem(),
                              Divider(
                                  height: 0.1, thickness: 0.1, color: white),
                              CommentItem(),
                              Divider(
                                  height: 0.1, thickness: 0.1, color: white),
                              CommentItem(),
                              Divider(
                                  height: 0.1, thickness: 0.1, color: white),
                              CommentItem(),
                              Divider(
                                  height: 0.1, thickness: 0.1, color: white),
                              CommentItem(),
                              Divider(
                                  height: 0.1, thickness: 0.1, color: white),
                              CommentItem(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Full-width Marquee (independent of columns above)
            SizedBox(
              height: 24,
              width: screenWidth,
              child: Marquee(
                text:
                    "Club is popping like a motherufcking on a rodeo!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!",
                style: const TextStyle(
                  color: white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                scrollAxis: Axis.horizontal,
                blankSpace: 50.0,
                pauseAfterRound: Duration(seconds: 1),
                startPadding: 10.0,
                accelerationDuration: Duration(seconds: 1),
                accelerationCurve: Curves.linear,
                decelerationDuration: Duration(milliseconds: 500),
                decelerationCurve: Curves.easeOut,
              ),
            ),
            SizedBox(
              height: heightBetweenFeeds,
            ),

            // Main content
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Side
                SizedBox(
                  width: usedWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: usedHeight,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: usedHeight,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(75),
                                image: const DecorationImage(
                                  image: AssetImage('images/swipe/1.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: -30,
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.purple,
                                    backgroundImage:
                                        AssetImage('images/user_pb.jpg'),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: black.withOpacity(0.6),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          "Poul Magne Skov",
                                          style: TextStyle(
                                            color: white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "L'Aquarium Club Paris.",
                                          style: TextStyle(
                                            color: white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Sammen med:",
                            style: TextStyle(color: white, fontSize: 12),
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: SizedBox(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(21, (index) {
                                    return const Padding(
                                      padding: EdgeInsets.only(right: 4),
                                      child: CircleAvatar(
                                        radius: 9.5,
                                        backgroundImage:
                                            AssetImage('images/user_pb.jpg'),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: const [
                          Icon(Icons.favorite_border,
                              color: redAccent, size: 25),
                          SizedBox(width: 15),
                          Icon(Icons.mode_comment_outlined,
                              color: white, size: 25),
                          SizedBox(width: 15),
                          Icon(Icons.send, color: white, size: 25),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(width: widthBetweenLeftAndRightSide),

                // Right Side
                SizedBox(
                  height: usedHeight
                  //  + 46
                  ,
                  width: remaingWidth - widthBetweenLeftAndRightSide * 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Kommentarer",
                        style: TextStyle(
                          color: white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: const [
                              CommentItem(),
                              Divider(
                                  height: 0.1, thickness: 0.1, color: white),
                              CommentItem(),
                              Divider(
                                  height: 0.1, thickness: 0.1, color: white),
                              CommentItem(),
                              Divider(
                                  height: 0.1, thickness: 0.1, color: white),
                              CommentItem(),
                              Divider(
                                  height: 0.1, thickness: 0.1, color: white),
                              CommentItem(),
                              Divider(
                                  height: 0.1, thickness: 0.1, color: white),
                              CommentItem(),
                              Divider(
                                  height: 0.1, thickness: 0.1, color: white),
                              CommentItem(),
                              Divider(
                                  height: 0.1, thickness: 0.1, color: white),
                              CommentItem(),
                              Divider(
                                  height: 0.1, thickness: 0.1, color: white),
                              CommentItem(),
                              Divider(
                                  height: 0.1, thickness: 0.1, color: white),
                              CommentItem(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Full-width Marquee (independent of columns above)
            SizedBox(
              height: 24,
              width: screenWidth,
              child: Marquee(
                text:
                    "Club is popping like a motherufcking on a rodeo!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!",
                style: const TextStyle(
                  color: white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                scrollAxis: Axis.horizontal,
                blankSpace: 50.0,
                pauseAfterRound: Duration(seconds: 1),
                startPadding: 10.0,
                accelerationDuration: Duration(seconds: 1),
                accelerationCurve: Curves.linear,
                decelerationDuration: Duration(milliseconds: 500),
                decelerationCurve: Curves.easeOut,
              ),
            ),
            SizedBox(
              height: heightBetweenFeeds,
            ),
            // Main content
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Side
                SizedBox(
                  width: usedWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: usedHeight,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: usedHeight,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(75),
                                image: const DecorationImage(
                                  image: AssetImage('images/swipe/1.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: -30,
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.purple,
                                    backgroundImage:
                                        AssetImage('images/user_pb.jpg'),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: black.withOpacity(0.6),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          "Poul Magne Skov",
                                          style: TextStyle(
                                            color: white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "L'Aquarium Club Paris.",
                                          style: TextStyle(
                                            color: white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Sammen med:",
                            style: TextStyle(color: white, fontSize: 12),
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: SizedBox(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(21, (index) {
                                    return const Padding(
                                      padding: EdgeInsets.only(right: 4),
                                      child: CircleAvatar(
                                        radius: 9.5,
                                        backgroundImage:
                                            AssetImage('images/user_pb.jpg'),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: const [
                          Icon(Icons.favorite_border,
                              color: redAccent, size: 25),
                          SizedBox(width: 15),
                          Icon(Icons.mode_comment_outlined,
                              color: white, size: 25),
                          SizedBox(width: 15),
                          Icon(Icons.send, color: white, size: 25),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(width: widthBetweenLeftAndRightSide),

                // Right Side
                SizedBox(
                  height: usedHeight
                  //  + 46
                  ,
                  width: remaingWidth - widthBetweenLeftAndRightSide * 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Kommentarer",
                        style: TextStyle(
                          color: white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: const [
                              CommentItem(),
                              Divider(
                                  height: 0.1, thickness: 0.1, color: white),
                              CommentItem(),
                              Divider(
                                  height: 0.1, thickness: 0.1, color: white),
                              CommentItem(),
                              Divider(
                                  height: 0.1, thickness: 0.1, color: white),
                              CommentItem(),
                              Divider(
                                  height: 0.1, thickness: 0.1, color: white),
                              CommentItem(),
                              Divider(
                                  height: 0.1, thickness: 0.1, color: white),
                              CommentItem(),
                              Divider(
                                  height: 0.1, thickness: 0.1, color: white),
                              CommentItem(),
                              Divider(
                                  height: 0.1, thickness: 0.1, color: white),
                              CommentItem(),
                              Divider(
                                  height: 0.1, thickness: 0.1, color: white),
                              CommentItem(),
                              Divider(
                                  height: 0.1, thickness: 0.1, color: white),
                              CommentItem(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Full-width Marquee (independent of columns above)
            SizedBox(
              height: 24,
              width: screenWidth,
              child: Marquee(
                text:
                    "Club is popping like a motherufcking on a rodeo!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!",
                style: const TextStyle(
                  color: white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                scrollAxis: Axis.horizontal,
                blankSpace: 50.0,
                pauseAfterRound: Duration(seconds: 1),
                startPadding: 10.0,
                accelerationDuration: Duration(seconds: 1),
                accelerationCurve: Curves.linear,
                decelerationDuration: Duration(milliseconds: 500),
                decelerationCurve: Curves.easeOut,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOfferDialog(BuildContext context, String imagePath) {
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth = screenSize.width * 0.95;
    final dialogHeight = screenSize.height * 0.8;

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
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20), bottom: Radius.circular(20)),
                  child: Image.asset(
                    imagePath,
                    width: double.infinity,
                    height: dialogHeight,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CommentItem extends StatelessWidget {
  const CommentItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0, top: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 15,
            backgroundImage: AssetImage('images/user_pb.jpg'),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Sebastian Skovhauge",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Oy Magne score banats",
                  style: TextStyle(color: white, fontSize: 10),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
