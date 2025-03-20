import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/generated/l10n.dart';
import 'package:nightview/locations/location_service.dart';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:nightview/utilities/club_data/club_distance_calculator.dart';
import 'package:url_launcher/url_launcher.dart';

class DistanceDisplayWidget extends StatelessWidget {
  final ClubData club;

  const DistanceDisplayWidget({
    super.key,
    required this.club,
  });

  @override
  Widget build(BuildContext context) {
    // WIDGET MEANT FOR clubsheet
    return Align(
      alignment: Alignment.topRight, // Position in top-right
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Add padding
        child: FutureBuilder<LatLng?>(
          future: LocationService.getUserLocation(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text(
// AppLocalizations.of(context)!.calculating,

                S.of(context).calculating,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 16.0,
                ),
              );
            } else if (snapshot.hasError || snapshot.data == null) {
              return Text(
                '',
                style: TextStyle(
                  color: redAccent,
                  fontSize: 16.0,
                ),
              );
            } else {
              final userLocation = snapshot.data!;
              return GestureDetector(
                onTap: () async {
                  final Uri appleMapsUri = Uri.parse(
                      'https://maps.apple.com/?daddr=${club.lat},${club.lon}&saddr=${userLocation.latitude},${userLocation.longitude}');
                  final Uri googleMapsUri = Uri.parse(
                      'https://www.google.com/maps/dir/?api=1&destination=${club.lat},${club.lon}&origin=${userLocation.latitude},${userLocation.longitude}');

                  // Attempt to launch Apple Maps first
                  if (await canLaunchUrl(appleMapsUri)) {
                    await launchUrl(appleMapsUri);
                  }
                  // Fallback to Google Maps if Apple Maps is unavailable
                  else if (await canLaunchUrl(googleMapsUri)) {
                    await launchUrl(googleMapsUri);
                  } else {
                    throw 'Could not launch maps';
                  }
                },

                //DISPLAY!
                child: Text(
                  ClubDistanceCalculator.displayDistanceToClub(
                    club: club,
                    userLon: userLocation.longitude,
                    userLat: userLocation.latitude,
                  ),
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    decoration:
                        TextDecoration.underline, // Indicate it's clickable
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
