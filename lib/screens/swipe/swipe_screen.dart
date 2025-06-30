import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:math';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/generated/l10n.dart';
import 'package:nightview/locations/location_service.dart';
import 'package:nightview/main.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/screens/main_screen.dart';
import 'package:nightview/widgets/stateless/icon_with_text.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SwipeScreen extends StatefulWidget {
  static const id = 'swipe_screen';

  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  final AppinioSwiperController controller = AppinioSwiperController();
  String? selectedImagePath; // Nullable, as it’s set asynchronously
  bool isImageLoaded = false;
  double imageOpacity = 1.0;

  Future<List<String>> loadImagePaths() async {
    // Load the AssetManifest.json content
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    // Parse it into a map
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    // Filter keys to get only those starting with 'images/swipe/'
    var imagePaths = manifestMap.keys
        .where((String key) => key.startsWith('images/swipe/'))
        .toList();
    return imagePaths;
  }

  @override
  void initState() {
    super.initState();
    // Load all images and select one randomly
    loadImagePaths().then((imagePaths) {
// TODO Specific images to specific people.
// user.gender == "M" ? imagePaths = manifestMap.keys
//         .where((String key) => key.startsWith('images/swipe/male'))
//         .toList() :  imagePaths = manifestMap.keys
//         .where((String key) => key.startsWith('images/swipe/female'))
//         .toList();

      setState(() {
        selectedImagePath = imagePaths[Random().nextInt(imagePaths.length)];
        isImageLoaded = true;
      });
    });
    // Get one message from SwipeMessages.
    final messages = SwipeMessages.messages();
    selectedMessage = messages[Random().nextInt(messages.length)];
    // shake animation after 0,4 sec.
    Future.delayed(const Duration(milliseconds: 400)).then((_) {
      _shakeCardRight();
    });
    startShakeTimer();
  }

  final int _cardCount = 1;
  late String selectedMessage;
  bool isDragging = false;
  bool isShaking = false;
  Timer? shakeTimer;
  Color backgroundColor = black;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
        backgroundColor: backgroundColor,
        child: Stack(
          children: [
            if (isImageLoaded && selectedImagePath != null)
              Positioned(
                left: 30,
                right: 30,
                bottom: 100,
                top: 130,
                child: AppinioSwiper(
                  invertAngleOnBottomDrag: true,
                  backgroundCardCount: 0,
                  swipeOptions: const SwipeOptions.all(),
                  controller: controller,
                  onCardPositionChanged: (SwiperPosition position) {
                    const double threshold = 20.0;
                    if (position.offset != Offset.zero) {
                      if (isShaking) isShaking = false;
                      isDragging = true;
                      shakeTimer?.cancel();
                      double distance = sqrt(pow(position.offset.dx, 2) +
                          pow(position.offset.dy, 2));
                      setState(() {
                        if (position.offset.dx < -threshold) {
                          // backgroundColor = redAccent;
                        } else if (position.offset.dx > threshold ||
                            position.offset.dy > threshold) {
                          // backgroundColor = primaryColor;
                        } else if (position.offset.dy.abs() > threshold &&
                            position.offset.dy < 0) {
                          // backgroundColor = grey;
                        }
                      });
                    } else if (isDragging) {
                      isDragging = false;
                      setState(() {
                        backgroundColor = black;
                      });
                    }
                  },
                  onSwipeEnd: _swipeEnd,
                  onEnd: _onEnd,
                  cardCount: _cardCount,
                  cardBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        _shakeCardRightSlowly();
                        startShakeTimer();
                      },
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(selectedImagePath!),
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.circular(kMainBorderRadius),
                              border:
                                  Border.all(color: secondaryColor, width: 3),
                            ),
                            width: double.maxFinite,
                          ),
                          Positioned(
                            top: 100, // TODO find good height.
                            left: 20,
                            right: 20,
                            child: Center(
                              child: Stack(
                                children: [
                                  // Stroke
                                  Text(
                                    selectedMessage,
                                    textAlign: TextAlign.center,
                                    style: kTextStyleSwipeH2.copyWith(
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 4
                                        ..color = primaryColor,
                                    ),
                                  ),
                                  // Fill
                                  Text(selectedMessage,
                                      textAlign: TextAlign.center,
                                      style: kTextStyleSwipeH2),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: kSwipeBottomPadding,
                            left: 0,
                            right: 0,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: kNormalSpacerValue),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconWithText(
                                      icon: FontAwesomeIcons.xmark,
                                      text: S.of(context).not_today,
                                      onTap: () => controller.swipeLeft(),
                                    ),
                                    GestureDetector(
                                      onTap: () => controller.swipeRight(),
                                      child: Container(
                                        padding: const EdgeInsets.all(30.0),
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: transparent,
                                        ),
                                        child: IconWithText(
                                          icon: FontAwesomeIcons.solidHeart,
                                          text: '${S.of(context).yes}!',
                                          iconColor: primaryColor,
                                          showCircle: false,
                                          onTap: () {},
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            else
              const Center(child: CircularProgressIndicator()),

            // Overlay text
            // Positioned(
            //   top: 50.0,
            //   left: 0,
            //   right: 0,
            //   child: Center(
            //     child: Text(
            //       'Swipe!',
            //       style: kTextStyleSwipeH1,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  void startShakeTimer({int seconds = 3}) {
    shakeTimer?.cancel();
    shakeTimer = Timer.periodic(
      Duration(seconds: seconds),
      (timer) {
        if (!isDragging && !isShaking) {
          _shakeCardRightSlowly();
        }
      },
    );
  }
  //Todo perfect color. ANYTIME card moves color should indicate the action with opacity. 100% should be when card is out of the screen maybe even furhter.
  //TODO As soon as user touches screen they should have full control and the card should not be moved except by the user.

  Future<void> _shakeCardRight() async {
    if (isShaking || isDragging) return;
    isShaking = true;
    const double distance = 80;

    await controller.animateTo(
      const Offset(distance, -10),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    // backgroundColor = primaryColor.withOpacity(0.6);
    if (isDragging || !isShaking) {
      isShaking = false;
      return;
    }
    await controller.animateTo(
      const Offset(0, 0),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
    backgroundColor = black;
    isShaking = false;
  }

  Future<void> _shakeCardRightSlowly() async {
    if (isShaking || isDragging) return;
    isShaking = true;
    const double distance = 50;

    // Switch image and message here
    final imagePaths = await loadImagePaths();
    setState(() {
      selectedImagePath = imagePaths[Random().nextInt(imagePaths.length)];
      isImageLoaded = true;
    });

    await controller.animateTo(
      const Offset(distance, 0),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeInOut,
    );
    // backgroundColor = primaryColor.withOpacity(0.6);

    if (isDragging || !isShaking) {
      isShaking = false;
      return;
    }
    setState(() {
      imageOpacity = 0.0; // Start fade-out
    });

    await Future.delayed(const Duration(milliseconds: 250));

    String newPath = imagePaths.isNotEmpty
        ? imagePaths[Random().nextInt(imagePaths.length)]
        : 'images/default_swipe_picture.png';

    setState(() {
      selectedImagePath = newPath;
    });

    await Future.delayed(const Duration(milliseconds: 50));

    setState(() {
      imageOpacity = 1.0; // Fade-in new image
    });

    await controller.animateTo(
      const Offset(0, 0),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
    if (isDragging || !isShaking) {
      isShaking = false;
      return;
    }
    await Future.delayed(const Duration(milliseconds: 1500));
    if (isDragging || !isShaking) {
      isShaking = false;
      return;
    }
    setState(() {
      selectedImagePath = imagePaths[Random().nextInt(imagePaths.length)];
      isImageLoaded = true;
    });
    await Future.delayed(const Duration(milliseconds: 1000));
    if (isDragging || !isShaking) {
      isShaking = false;
      return;
    }
    //TODO CAN DO A LOT OF FUN STUFF HERE IN TIME!
    // await controller.animateTo(
    //   const Offset(distance * 4, 0),
    //   duration: const Duration(milliseconds: 1500),
    //   curve: Curves.easeInOut,
    // );
    // if (isDragging || !isShaking) {
    //   isShaking = false;
    //   return;
    // }

    await controller.animateTo(
      const Offset(distance * 10, -20),
      duration: const Duration(milliseconds: 2000),
      curve: Curves.easeInOut,
    );
    // backgroundColor = primaryColor.withOpacity(0.6);

//Default set status to yes if no response. TODO Needs to be done cleaner.
    final globalProvider = Provider.of<GlobalProvider>(context, listen: false);
    globalProvider.setPartyStatusLocal(PartyStatus.yes);
    globalProvider.userDataHelper.setCurrentUsersPartyStatus(
        status: PartyStatus.yes,
        sourceType: PartyStatusSourceType.swipe,
        location: await LocationService.getUserGeoPointOrNull());

    // Navigate to MainScreen
    Navigator.of(context).pushReplacementNamed(MainScreen.id);

    // if (isDragging || !isShaking) {
    //   isShaking = false;
    //   return;
    // }
    // await controller.animateTo(
    //   const Offset(0, 0),
    //   duration: const Duration(milliseconds: 250),
    //   curve: Curves.easeInOut,
    // );
    // backgroundColor = black;

    // isShaking = false;
  }

  void _swipeEnd(
      int previousIndex, int targetIndex, SwiperActivity activity) async {
    // Only handle Swipe activities (ignore Unswipe, CancelSwipe, etc.)
    if (activity is Swipe) {
      final globalProvider =
          Provider.of<GlobalProvider>(context, listen: false);
      switch (activity.direction) {
        case AxisDirection.up: // YES
        case AxisDirection.right: // YES
          globalProvider.setPartyStatusLocal(PartyStatus.yes);
          globalProvider.userDataHelper.setCurrentUsersPartyStatus(
              status: PartyStatus.yes,
              sourceType: PartyStatusSourceType.swipe,
              location: await LocationService.getUserGeoPointOrNull());
          print('Swiped right: PartyStatus set to Yes');
          break;
        case AxisDirection.left: // NO
          globalProvider.setPartyStatusLocal(PartyStatus.no);
          globalProvider.userDataHelper.setCurrentUsersPartyStatus(
              status: PartyStatus.no,
              sourceType: PartyStatusSourceType.swipe,
              location: await LocationService.getUserGeoPointOrNull());
          print('Swiped left: PartyStatus set to No');
          break;

        case AxisDirection.down: // UNSURE
          globalProvider.setPartyStatusLocal(PartyStatus.unsure);
          globalProvider.userDataHelper.setCurrentUsersPartyStatus(
              status: PartyStatus.unsure,
              sourceType: PartyStatusSourceType.swipe,
              location: await LocationService.getUserGeoPointOrNull());
          print('Swiped up/down: PartyStatus set to Unsure');
          break;
      }
      // Navigate to MainScreen after swipe
      Navigator.of(context).pushReplacementNamed(MainScreen.id);
    } else if (activity is CancelSwipe) {
      // User dragged but didn't complete the swipe, so shake the card immediately
      _shakeCardRightSlowly();
      startShakeTimer(); // Restart the periodic timer
    }
  }

  void _onEnd() {
    print('end reached!');
  }

  @override
  void dispose() {
    controller.dispose();
    shakeTimer?.cancel();
    super.dispose();
  }
}

class SwipeMessages {
  static List<String> messages() {
    return [
      S.of(ourNavigatorKey.currentContext!).ready_to_conquer_dancefloor,
      S.of(ourNavigatorKey.currentContext!).plans_for_adventure,
      S.of(ourNavigatorKey.currentContext!).let_make_trouble,
      S.of(ourNavigatorKey.currentContext!).wild_night,
      S.of(ourNavigatorKey.currentContext!).let_loose,
      S.of(ourNavigatorKey.currentContext!).show_best_moves,
      S.of(ourNavigatorKey.currentContext!).make_city_safe,
      S.of(ourNavigatorKey.currentContext!).good_bartender,
      S.of(ourNavigatorKey.currentContext!).be_my_date,
      S.of(ourNavigatorKey.currentContext!).waste_youth,
      S.of(ourNavigatorKey.currentContext!).light_up_dancefloor,
      S.of(ourNavigatorKey.currentContext!).create_memories,
      S.of(ourNavigatorKey.currentContext!).max_gas,
      S.of(ourNavigatorKey.currentContext!).make_night_unforgettable,
      S.of(ourNavigatorKey.currentContext!).take_city_with_style,
      S.of(ourNavigatorKey.currentContext!).night_of_laughter_and_dance,
      S.of(ourNavigatorKey.currentContext!).conquer_city,
      S.of(ourNavigatorKey.currentContext!).make_own_party,
      S.of(ourNavigatorKey.currentContext!).let_go_of_inhibitions,
      S.of(ourNavigatorKey.currentContext!).night_adventure,
      S.of(ourNavigatorKey.currentContext!).make_streets_safe,
      S.of(ourNavigatorKey.currentContext!).create_party_vibe,
      S.of(ourNavigatorKey.currentContext!).make_night_special,
      S.of(ourNavigatorKey.currentContext!).live_life_to_fullest,
      S.of(ourNavigatorKey.currentContext!).party_like_never_before,
      S.of(ourNavigatorKey.currentContext!).take_nightlife_by_storm,
      S.of(ourNavigatorKey.currentContext!).dancefloor_as_stage,
      S.of(ourNavigatorKey.currentContext!).light_up_city,
      S.of(ourNavigatorKey.currentContext!).go_wild_on_dancefloor,
      S.of(ourNavigatorKey.currentContext!).be_center_of_party,
      S.of(ourNavigatorKey.currentContext!).night_full_of_fun,
      S.of(ourNavigatorKey.currentContext!).take_city_by_storm,
      S.of(ourNavigatorKey.currentContext!).create_wild_memories,
      S.of(ourNavigatorKey.currentContext!).party_without_equal,
      S.of(ourNavigatorKey.currentContext!).fire_up_dancefloor,
      S.of(ourNavigatorKey.currentContext!).adventure_in_nightlife,
      S.of(ourNavigatorKey.currentContext!).conquer_nightlife,
      S.of(ourNavigatorKey.currentContext!).play_rockstars,
      S.of(ourNavigatorKey.currentContext!).dance_with_two_left_feet,
      S.of(ourNavigatorKey.currentContext!).epic_snapchat_stories,
      S.of(ourNavigatorKey.currentContext!).crazy_party_animal,
      S.of(ourNavigatorKey.currentContext!).legendary_missteps,
      S.of(ourNavigatorKey.currentContext!).make_new_friends,
      S.of(ourNavigatorKey.currentContext!).trip_to_party_league,
      S.of(ourNavigatorKey.currentContext!).going_out_tonight,
      S.of(ourNavigatorKey.currentContext!).shall_we,
      S.of(ourNavigatorKey.currentContext!).fire_it_up,
      S.of(ourNavigatorKey.currentContext!).drinking,
      S.of(ourNavigatorKey.currentContext!).going_out,
      S.of(ourNavigatorKey.currentContext!).club,
      S.of(ourNavigatorKey.currentContext!).create_ravage,
      S.of(ourNavigatorKey.currentContext!).create_festive_chaos,
      S.of(ourNavigatorKey.currentContext!).shake_up_city,
      S.of(ourNavigatorKey.currentContext!).time_for_trouble,
      S.of(ourNavigatorKey.currentContext!).part_of_nightlife,
      S.of(ourNavigatorKey.currentContext!).plans_for_evening,
      S.of(ourNavigatorKey.currentContext!).ready_for_city_trip,
    ];
  }
}
