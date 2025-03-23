import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/constants/icons.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/generated/l10n.dart';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/providers/night_map_provider.dart';
import 'package:nightview/screens/clubs/club_bottom_sheet.dart';
import 'package:nightview/screens/option_menu/widgets/favorites_section.dart';
import 'package:nightview/screens/profile/my_profile_main_screen.dart';
import 'package:nightview/screens/option_menu/bottom_sheet_status_screen.dart';
import 'package:nightview/utilities/club_data/club_opening_hours_formatter.dart';
import 'package:nightview/widgets/stateless/city_today_section.dart';
import 'package:nightview/widgets/stateless/language_switcher.dart';
import 'package:nightview/widgets/stateless/side_sheet_main_screen_section.dart';
import 'package:provider/provider.dart';

class SideSheetMainScreen extends StatefulWidget {
  const SideSheetMainScreen({super.key});

  @override
  State<SideSheetMainScreen> createState() => _SideSheetMainScreenState();
}

class _SideSheetMainScreenState extends State<SideSheetMainScreen> {
  int favoriteClubMax = 5;
  //TODO WHEN SWIPING LEFT IN HERE YOU SHOULD GO TO THE PROFILE SCREEN When riht this should close.
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      String? currentUserId =
          Provider.of<GlobalProvider>(context, listen: false)
              .userDataHelper
              .currentUserId;
      PartyStatus status = Provider.of<GlobalProvider>(context, listen: false)
              .userDataHelper
              .userData[currentUserId]
              ?.partyStatus ??
          PartyStatus.unsure;
      Provider.of<GlobalProvider>(context, listen: false)
          .setPartyStatusLocal(status);
    });
  }

  ImageProvider getPb(int index) {
    try {
      return Provider.of<GlobalProvider>(context, listen: false)
          .friendPbs[index];
    } catch (e) {
      return const AssetImage('images/user_pb.jpg'); // Fallback image
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: black,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.arrowRight,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  trailing: LanguageSwitcher(
                    radius: 19.0,
                    borderRadius: 25.0,
                  ),
                ),
                ListTile(
                  //TODO NOT WORKING BIGGER SIZE.
                  leading: Container(
                    width:
                        50, // Increase this to expand the hit area to the right
                    alignment:
                        Alignment.centerLeft, // Keep the icon on the left
                    child: GestureDetector(
                      behavior: HitTestBehavior
                          .translucent, // Ensures taps register on empty space
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => BottomSheetStatusScreen(),
                        );
                      },
                      child: FaIcon(
                        FontAwesomeIcons.solidCircleDot,
                        color: Provider.of<GlobalProvider>(context)
                            .partyStatusColor,
                        size: 23.0,
                      ),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            Provider.of<GlobalProvider>(context).profilePicture,
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(MyProfileMainScreen.id);
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: kMainPadding),
                  child: Divider(
                    color: secondaryColor,
                    thickness: kMainStrokeWidth,
                  ),
                ),
                // Favorites Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: kMainPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Center(
                            child: Text(
                              S.of(context).favorites_title,
                              style: TextStyle(
                                color: white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: Consumer<GlobalProvider>(
                              builder: (context, provider, child) {
                                return FutureBuilder<List<ClubData>>(
                                  future: provider.getFavoriteClubs(),
                                  //TODO IF just started app clubs are empty!
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.waiting ||
                                        snapshot.hasError ||
                                        !snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return SizedBox
                                          .shrink(); // Don’t show anything while loading or if no data
                                    }

                                    List<ClubData> favoriteClubs =
                                        snapshot.data!;

                                    return RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '${favoriteClubs.length}',
                                            style: TextStyle(
                                              color: favoriteClubs.length <=
                                                      (favoriteClubMax / 2)
                                                          .floor()
                                                  ? redAccent
                                                  : primaryColor,
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
                                            text: '$favoriteClubMax',
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
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 8.0),

                      SizedBox(
                        height: 50.0, // Height for one row of logos
                        //TODO make singlescrollwiev.
                        child: Consumer<GlobalProvider>(
                          builder: (context, provider, child) {
                            return FutureBuilder<List<ClubData>>(
                              future: provider.getFavoriteClubs(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: secondaryColor,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                      S
                                          .of(context)
                                          .error_fetching_favorite_clubs,
                                      style: TextStyle(color: redAccent),
                                    ),
                                  );
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return Center(
                                    child: Text(
                                      S.of(context).no_favorite_clubs_yet,
                                      style: TextStyle(color: redAccent),
                                    ),
                                  );
                                }

                                // Data is available
                                List<ClubData> favoriteClubs = snapshot.data!;
                                // Sort clubs: open clubs first
                                favoriteClubs.sort((a, b) {
                                  bool aOpen =
                                      ClubOpeningHoursFormatter.isClubOpen(a);
                                  bool bOpen =
                                      ClubOpeningHoursFormatter.isClubOpen(b);
                                  return (bOpen ? 1 : 0) - (aOpen ? 1 : 0);
                                });
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: List.generate(
                                      favoriteClubs.length > 5
                                          ? favoriteClubs.length
                                          : 5,
                                      (index) {
                                        if (index < favoriteClubs.length) {
                                          ClubData club = favoriteClubs[index];
                                          bool isOpen =
                                              ClubOpeningHoursFormatter
                                                  .isClubOpen(club);
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);

                                              Provider.of<NightMapProvider>(
                                                      context,
                                                      listen: false)
                                                  .nightMapController
                                                  .move(
                                                      LatLng(
                                                          club.lat, club.lon),
                                                      kCloseMapZoom);
                                              Provider.of<GlobalProvider>(
                                                      context,
                                                      listen: false)
                                                  .setChosenClub(club);
                                              ClubBottomSheet.showClubSheet(
                                                  context: context, club: club);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: isOpen
                                                        ? primaryColor
                                                        : redAccent,
                                                    width: 2.0,
                                                  ),
                                                ),
                                                child: CircleAvatar(
                                                  backgroundImage:
                                                      NetworkImage(club.logo),
                                                  radius: 19.0,
                                                  backgroundColor:
                                                      secondaryColor, // Fallback color
                                                  onBackgroundImageError:
                                                      (exception, stackTrace) {
                                                    print(
                                                        'Image load error for ${club.logo}: $exception');
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        } else {
                                          // Empty space placeholders (invisible widgets to maintain spacing)
                                          return SizedBox(
                                              width:
                                                  42); // Same width as the avatars
                                        }
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
//favorites TODO
                      // FavoritesSection(favoriteClubMax: favoriteClubMax),

                      Divider(
                          color: secondaryColor, thickness: kThinStrokeWidth),

                      // Friends
                      SideSheetMainScreenSection(), //TODO DONT WORK!

                      Divider(
                        color: secondaryColor,
                        thickness: kMainStrokeWidth,
                      ),

                      // CityTodaySection(),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                // .spaceBetween, // Distribute icons to opposite sides
                children: [
                  // InkWell(
                  //   onTap: () {
                  //     print('Settings icon tapped'); // Placeholder action
                  //   },
                  //   child: Icon(
                  //     FontAwesomeIcons.gear, // Settings icon
                  //     color: nightviewOrange,
                  //     size: 20.0,
                  //   ),
                  // ),
                  InkWell(
                    onTap: () {
                      print('Location icon tapped');
                    },
                    child: Icon(
                      //TODO
                      1 > 0 ? defaultLocationDot : defaultLocationDotLocked,
                      color: 1 > 2 ? primaryColor : grey,
                      size: 20.0,
                    ),
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
