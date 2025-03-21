import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/providers/night_map_provider.dart';
import 'package:nightview/screens/clubs/club_bottom_sheet.dart';
import 'package:nightview/utilities/club_data/club_opening_hours_formatter.dart'; // Add this import
import 'package:provider/provider.dart';

class CityTodaySection extends StatelessWidget {
  const CityTodaySection({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen height
    double screenHeight = MediaQuery.of(context).size.height *
        0.8; //TODO FIND GOOD HEIGHT TO FIT ALL DEVICES.
    // Estimate the height of other widgets in SideSheetMainScreen
    const double topSectionHeight = 120.0; // Approx. for ListTiles
    const double favoritesHeight =
        50.0 + 8.0 + 15.0; // Height + padding + title
    const double friendsHeight = 50.0 + 8.0 + 15.0; // Height + padding + title
    const double dividerHeight =
        kMainStrokeWidth + kThinStrokeWidth + 16.0; // Dividers + bottom padding
    const double titleHeight = 15.0 + 8.0; // Title + padding
    const double bottomPadding = 16.0; // Bottom Row height
    double availableHeight = screenHeight -
        (topSectionHeight +
            favoritesHeight +
            friendsHeight +
            dividerHeight +
            titleHeight +
            bottomPadding);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Byen lige nu',
            style: TextStyle(
              color: white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 8.0),
        FutureBuilder<List<ClubData>>(
          future: Provider.of<GlobalProvider>(context, listen: false)
              .getSortedClubList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(color: secondaryColor));
            }
            if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'Ingen klubber aktive lige nu',
                  style: TextStyle(color: redAccent),
                ),
              );
            }

            List<ClubData> clubs = snapshot.data!;

            return SizedBox(
              height: availableHeight > 100
                  ? availableHeight
                  : 100, // Minimum height
              child: ListView.builder(
                itemCount: clubs.length,
                itemBuilder: (context, index) {
                  ClubData club = clubs[index];
                  bool isOpen = ClubOpeningHoursFormatter.isClubOpen(club);

                  return ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isOpen ? primaryColor : redAccent,
                          width: 2.0,
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(club.logo),
                        radius: 25.0,
                        backgroundColor: secondaryColor,
                        onBackgroundImageError: (exception, stackTrace) {
                          print(
                              'Image load error for ${club.logo}: $exception');
                        },
                      ),
                    ),
                    subtitle: Text(
                      '${club.visitors} gæster',
                      style: TextStyle(color: primaryColor),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Provider.of<NightMapProvider>(context, listen: false)
                          .nightMapController
                          .move(LatLng(club.lat, club.lon), kCloseMapZoom);
                      Provider.of<GlobalProvider>(context, listen: false)
                          .setChosenClub(club);
                      ClubBottomSheet.showClubSheet(
                          context: context, club: club);
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
