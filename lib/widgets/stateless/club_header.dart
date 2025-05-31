import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:nightview/utilities/club_data/club_name_formatter.dart';
import 'package:nightview/utilities/club_data/club_opening_hours_formatter.dart';
import 'package:nightview/widgets/stateful/favorite_club_button.dart';

class ClubHeader extends StatelessWidget {
  final ClubData club;

  const ClubHeader({
    super.key,
    required this.club,
  });

  @override
  Widget build(BuildContext context) {
    final String formattedClubName = ClubNameFormatter.displayClubName(club);

    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: AssetImage('images/swipe/1.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: SizedBox(
          height: 180,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back Button
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              // Club Name and Icons
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Club Name with Outline Effect
                  Stack(
                    children: [
                      Text(
                        formattedClubName,
                        style: kTextStyleH1.copyWith(
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 0.2
                            ..color = Colors.white,
                        ),
                      ),
                      Text(
                        formattedClubName,
                        style: kTextStyleH1.copyWith(color: primaryColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  // Icons below the name
                  Row(
                    children: [
                      const FavoriteClubButton(),
                      // Placeholder for additional icons if needed
                      // Example: IconButton(icon: Icon(Icons.share), onPressed: () {}),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              // Larger Logo
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ClubOpeningHoursFormatter.isClubOpen(club)
                        ? primaryColor
                        : Colors.redAccent,
                    width: 3.0,
                  ),
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: club.logo,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => CachedNetworkImage(
                      imageUrl: club.typeOfClubImg,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
