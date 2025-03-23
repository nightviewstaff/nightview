import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/generated/l10n.dart';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/providers/night_map_provider.dart';
import 'package:nightview/screens/clubs/club_bottom_sheet.dart';
import 'package:nightview/utilities/club_data/club_opening_hours_formatter.dart';
import 'package:provider/provider.dart';

class FavoritesSection extends StatelessWidget {
  final int favoriteClubMax;

  const FavoritesSection({super.key, this.favoriteClubMax = 5});

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting ||
                          snapshot.hasError ||
                          !snapshot.hasData ||
                          snapshot.data!.isEmpty) {
                        return SizedBox.shrink();
                      }

                      List<ClubData> favoriteClubs = snapshot.data!;
                      return RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${favoriteClubs.length}',
                              style: TextStyle(
                                color: favoriteClubs.length <=
                                        (favoriteClubMax / 2).floor()
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
        const SizedBox(height: 8.0),
        SizedBox(
          height: 50.0,
          child: Consumer<GlobalProvider>(
            builder: (context, provider, child) {
              return FutureBuilder<List<ClubData>>(
                future: provider.getFavoriteClubs(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(color: secondaryColor),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        S.of(context).error_fetching_favorite_clubs,
                        style: TextStyle(color: redAccent),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        S.of(context).no_favorite_clubs_yet,
                        style: TextStyle(color: redAccent),
                      ),
                    );
                  }

                  List<ClubData> favoriteClubs = snapshot.data!;
                  favoriteClubs.sort((a, b) {
                    bool aOpen = ClubOpeningHoursFormatter.isClubOpen(a);
                    bool bOpen = ClubOpeningHoursFormatter.isClubOpen(b);
                    return (bOpen ? 1 : 0) - (aOpen ? 1 : 0);
                  });

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        favoriteClubs.length > 5 ? favoriteClubs.length : 5,
                        (index) {
                          if (index < favoriteClubs.length) {
                            ClubData club = favoriteClubs[index];
                            bool isOpen =
                                ClubOpeningHoursFormatter.isClubOpen(club);
                            return GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                Provider.of<NightMapProvider>(context,
                                        listen: false)
                                    .nightMapController
                                    .move(LatLng(club.lat, club.lon),
                                        kCloseMapZoom);
                                Provider.of<GlobalProvider>(context,
                                        listen: false)
                                    .setChosenClub(club);
                                ClubBottomSheet.showClubSheet(
                                    context: context, club: club);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isOpen ? primaryColor : redAccent,
                                      width: 2.0,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(club.logo),
                                    radius: 19.0,
                                    backgroundColor: secondaryColor,
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
                            return const SizedBox(width: 42);
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
      ],
    );
  }
}
