import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/l10n/messages_en.dart';
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

  Future<List<String>> loadImagePaths() async {
    // Load the AssetManifest.json content
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    // Parse it into a map
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    // Filter keys to get only those starting with 'images/swipe/'
    final imagePaths = manifestMap.keys
        .where((String key) => key.startsWith('images/swipe/'))
        .toList();
    return imagePaths;
  }

  @override
  void initState() {
    super.initState();
    // Load all images and select one randomly
    loadImagePaths().then((imagePaths) {
      if (imagePaths.isNotEmpty) {
        setState(() {
          selectedImagePath = imagePaths[Random().nextInt(imagePaths.length)];
          isImageLoaded = true;
        });
      } else {
        setState(() {
          isImageLoaded = true; // Proceed even if no images
          selectedImagePath =
              'images/default_swipe_picture.png'; // Fallback picture.
        });
      }
    });
    // Get one message from SwipeMessages.
    selectedMessage =
        SwipeMessages.messages[Random().nextInt(SwipeMessages.messages.length)];
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
  Color backgroundColor = black.withOpacity(0.0);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
        backgroundColor: backgroundColor,
        child: Stack(
          children: [
            Column(
              children: [
                // Swipe card content
                SizedBox(
                  height: MediaQuery.of(context).size.height * 1.0,
                  child: Padding(
                    padding: const EdgeInsets.only(),
                    child: isImageLoaded
                        ? (selectedImagePath != null
                            ? AppinioSwiper(
                                invertAngleOnBottomDrag: true,
                                backgroundCardCount: 0,
                                swipeOptions: const SwipeOptions
                                    .all(), // All 4 directions possible.
                                controller: controller,
                                onCardPositionChanged:
                                    (SwiperPosition position) {
                                  const double threshold =
                                      20.0; // Minimum distance to trigger a color change
                                  if (position.offset != Offset.zero) {
                                    if (isShaking) {
                                      isShaking = false;
                                    }
                                    isDragging = true;
                                    shakeTimer?.cancel();

                                    // Calculate total distance moved
                                    double distance = sqrt(
                                        pow(position.offset.dx, 2) +
                                            pow(position.offset.dy, 2));

                                    if (position.offset.dx < -threshold) {
                                      setState(() {
                                        // backgroundColor =                                            redAccent; // Left for "No"
                                      });
                                    } else if (position.offset.dx > threshold ||
                                        position.offset.dy > threshold) {
                                      setState(() {
                                        // backgroundColor =                                            primaryColor; // Right or Up for "Yes"
                                      });
                                    } else if (position.offset.dy.abs() >
                                            threshold &&
                                        position.offset.dy < 0) {
                                      setState(() {
                                        // backgroundColor =                                            grey; // Down for "Unsure"
                                      });
                                    }
                                  } else if (isDragging) {
                                    isDragging = false;
                                    setState(() {
                                      backgroundColor =
                                          black; // Reset to transparent when back at center
                                    });
                                  }
                                },
                                onSwipeEnd: _swipeEnd,
                                onEnd: _onEnd,
                                cardCount: _cardCount,
                                cardBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      // Trigger shake immediately and restart the timer
                                      _shakeCardRightSlowly();
                                      startShakeTimer();
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                          // The image
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  selectedImagePath!),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                kMainBorderRadius),
                                            border: Border.all(
                                              color: secondaryColor,
                                              width: 5,
                                            ),
                                          ),
                                          width: double.maxFinite,
                                        ),
                                        // Centered text
                                        Positioned(
                                          top: 350.0,
                                          left: 25,
                                          right: 25,
                                          child: Center(
                                            child: Text(
                                              selectedMessage,
                                              style:
                                                  kTextStyleSwipeH2.copyWith(),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        // Bottom controls
                                        Positioned(
                                          bottom: kSwipeBottomPadding,
                                          left: 0,
                                          right: 0,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const SizedBox(
                                                  height: kNormalSpacerValue),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Container(
                                                    child: IconWithText(
                                                      icon: FontAwesomeIcons
                                                          .xmark,
                                                      text: 'Ikke i dag',
                                                      onTap: () {
                                                        controller.swipeLeft();
                                                      },
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      controller.swipeRight();
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .all(
                                                          30.0), // Increases clickable area by ~30px (15px on each side)
                                                      decoration:
                                                          const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors
                                                            .transparent, // Keeps the area invisible
                                                      ),
                                                      child: IconWithText(
                                                        icon: FontAwesomeIcons
                                                            .solidHeart,
                                                        text: 'Ja!',
                                                        iconColor: primaryColor,
                                                        showCircle: false,
                                                        onTap:
                                                            () {}, // Override internal onTap to prevent duplicate handling
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
                              )
                            : Center(child: Text('')))
                        : Center(child: CircularProgressIndicator()),
                  ),
                ),
              ],
            ),
            // Overlay text
            Positioned(
              top: 50.0,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Swipe!',
                  style: kTextStyleSwipeH1,
                ),
              ),
            ),
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
    backgroundColor = primaryColor;
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
    await controller.animateTo(
      const Offset(distance, 0),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeInOut,
    );
    backgroundColor = primaryColor;

    if (isDragging || !isShaking) {
      isShaking = false;
      return;
    }
    await controller.animateTo(
      const Offset(0, 0),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
    if (isDragging || !isShaking) {
      isShaking = false;
      return;
    }
    await Future.delayed(const Duration(milliseconds: 2500));
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
    backgroundColor = primaryColor;

//Default set status to yes if no response. TODO Needs to be done cleaner.
    final globalProvider = Provider.of<GlobalProvider>(context, listen: false);
    globalProvider.setPartyStatusLocal(PartyStatus.yes);
    globalProvider.userDataHelper
        .setCurrentUsersPartyStatus(status: PartyStatus.yes);

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

  void _swipeEnd(int previousIndex, int targetIndex, SwiperActivity activity) {
    // Only handle Swipe activities (ignore Unswipe, CancelSwipe, etc.)
    if (activity is Swipe) {
      final globalProvider =
          Provider.of<GlobalProvider>(context, listen: false);
      switch (activity.direction) {
        case AxisDirection.up: // YES
        case AxisDirection.right: // YES
          globalProvider.setPartyStatusLocal(PartyStatus.yes);
          globalProvider.userDataHelper
              .setCurrentUsersPartyStatus(status: PartyStatus.yes);
          print('Swiped right: PartyStatus set to Yes');
          break;
        case AxisDirection.left: // NO
          globalProvider.setPartyStatusLocal(PartyStatus.no);
          globalProvider.userDataHelper
              .setCurrentUsersPartyStatus(status: PartyStatus.no);
          print('Swiped left: PartyStatus set to No');
          break;

        case AxisDirection.down: // UNSURE
          globalProvider.setPartyStatusLocal(PartyStatus.unsure);
          globalProvider.userDataHelper
              .setCurrentUsersPartyStatus(status: PartyStatus.unsure);
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
  static const List<String> messages = [
    "Er du klar til at erobre dansegulvet i nat?",
    "Har du planer om at tage på eventyr i byen i aften?",
    "Skal vi ud og lave ballade i nat?",
    "Bliver det en af de vilde aftener i byen i aften?",
    "Er det en af de aftener, hvor vi slår os løs?",
    "Skal vi ud og vise vores bedste moves i aften?",
    "Er du på vej ud for at gøre byen usikker i nat?",
    "Specielle drinks hos en god bartender?",
    "Mangler du en date i aften?",
    "Hvad hvis vi spilder ungdommen i aften og ser, hvor det bringer os hen?",
    "Er du klar til at lyse dansegulvet op i aften?",
    "Har du planer om at skabe minder i byen i nat?",
    "Er det en af de aftener, hvor vi giver den max gas?",
    "Skal vi ud og gøre natten vild og uforglemmelig?",
    "Er du parat til at indtage byen med stil?",
    "Bliver det en nat med masser af latter og dans?",
    "Er du klar til at erobre byen og have det sjovt?",
    "Skal vi ud og gøre natten til vores egen fest?",
    "Er det en af de aftener, hvor vi slipper alle hæmninger?",
    "Har du tænkt dig at tage på natteeventyr med os i aften?",
    "Er det i aften, vi gør gaderne usikre?",
    "Skal vi ud og skabe feststemning i nat?",
    "Er du klar til at gøre natten til noget særligt?",
    "Bliver det en af de aftener, hvor vi lever livet fuldt ud?",
    "Skal vi ud og feste som aldrig før i nat?",
    "Er du klar til at indtage nattelivet med os?",
    "Har du tænkt dig at gøre natten vild og uforglemmelig?",
    "Er du klar til at gøre dansegulvet til din scene i aften?",
    "Skal vi ud og få byen til at lyse op i nat?",
    "Er det i aften, vi går amok på dansegulvet?",
    "Har du tænkt dig at være festens midtpunkt i nat?",
    "Er du parat til en nat fyldt med grin og gode vibes?",
    "Er du klar til at tage byen med storm i aften?",
    "Er du klar til at skabe vilde minder i nat?",
    "Er du parat til at gøre natten til en fest uden lige?",
    "Skal vi ud og fyre den af på dansegulvet?",
    "Er du klar til at gøre byen usikker med os i nat?",
    "Har du planer om at tage på eventyr i nattelivet?",
    "Skal vi ud og erobre nattelivet i aften?",
    "Skal vi ud og lege rockstjerner i nat?",
    "Er du klar til at danse, som om vi har to venstre fødder?",
    "Er det i aften, vi laver nogle episke Snapchat-historier?",
    "Er du klar til at være byens skøreste festabe i nat?",
    "Skal vi ud og lave nogle legendariske fejltrin på dansegulvet?",
    "Skal vi ud og se, hvor mange nye venner vi kan få i nat?",
    "Er du klar til at tage en tur i festligaen i nat?",
    "Ud i aften?",
    "Skal vi?",
    "Ud og fyre den af?",
    "Druk?",
    "Skal vi ud?",
    "Klubben?",
    "Er du klar til at skabe ravage i byen i aften?",
    "Skal vi ud og skabe lidt festlig uro i byen?",
    "Skal vi ud og ryste byen op?",
    "Er det tid til at lave noget ballade i nat?",
    "Bliver du en del af nattelivet i dag?",
    "Har du planer om at gå ud i aften?",
    "Er du klar til en bytur i dag?"
  ];
}
