import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/generated/l10n.dart';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:nightview/utilities/club_data/club_data_location_formatting.dart';
import 'package:nightview/utilities/club_data/club_distance_calculator.dart';
import 'package:nightview/utilities/club_data/club_name_formatter.dart';
import 'package:nightview/utilities/club_data/club_opening_hours_formatter.dart';

class ClubSearchWidget extends StatefulWidget {
  final List<ClubData> clubs;
  final LatLng userLocation;
  final Function(ClubData) onClubSelected;

  const ClubSearchWidget({
    Key? key,
    required this.clubs,
    required this.userLocation,
    required this.onClubSelected,
  }) : super(key: key);

  @override
  State<ClubSearchWidget> createState() => _ClubSearchWidgetState();
}

class _ClubSearchWidgetState extends State<ClubSearchWidget> {
  late final SearchController _searchController;
  final ValueNotifier<bool> _toggleNotifier =
      ValueNotifier(true); // Default: sort by open status

  @override
  void initState() {
    super.initState();
    _searchController = SearchController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _toggleNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      searchController: _searchController,
      viewTrailing: [
        ValueListenableBuilder<bool>(
          valueListenable: _toggleNotifier,
          builder: (context, isToggled, _) {
            return IconButton(
              icon: FaIcon(
                isToggled
                    ? FontAwesomeIcons.doorOpen
                    : FontAwesomeIcons.doorClosed,
                color: isToggled ? primaryColor : redAccent,
              ),
              onPressed: () {
                _toggleNotifier.value = !_toggleNotifier.value;
                _searchController.text = " "; // Refresh suggestions
                _searchController.text = "";
              },
            );
          },
        ),
      ],
      viewBackgroundColor: black,
      isFullScreen: false,
      dividerColor: primaryColor,
      viewElevation: 2,
      viewConstraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 1,
        maxHeight: MediaQuery.of(context).size.height * 0.40,
      ),
      builder: (context, controller) {
        return SearchBar(
          controller: controller,
          leading: const Icon(Icons.search_sharp, color: primaryColor),
          hintText: S.of(context).search_locations, //TODO MAKE MARQUES
          hintStyle: WidgetStateProperty.all(kTextStyleP2),
          backgroundColor: WidgetStateProperty.all(grey),
          shadowColor: WidgetStateProperty.all(secondaryColor),
          elevation: WidgetStateProperty.all(4),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          onChanged: (value) {
            controller.openView();
          },
          onTap: () {
            controller.openView();
          },
          onTapOutside: (event) {
            if (controller.isOpen) {
              controller.closeView("");
            }
            FocusManager.instance.primaryFocus?.unfocus();
          },
        );
      },
      suggestionsBuilder: (context, controller) {
        String userInputLowerCase = controller.text.toLowerCase().trim();

        // Filter clubs
        List<ClubData> filteredClubs = widget.clubs.where((club) {
          bool matchesName =
              club.name.toLowerCase().contains(userInputLowerCase);
          bool matchesType =
              club.typeOfClub.toLowerCase().contains(userInputLowerCase);
          String normalizedClubLocation =
              ClubDataLocationFormatting.normalizeLocation(
                      ClubNameFormatter.displayClubLocation(club))
                  .toLowerCase();
          String normalizedSearch =
              ClubDataLocationFormatting.normalizeLocation(controller.text)
                  .toLowerCase();
          bool matchesLocation =
              normalizedClubLocation.contains(normalizedSearch);
          bool matchesAgeRestriction;
          if (RegExp(r'^\d+\+$').hasMatch(userInputLowerCase)) {
            matchesAgeRestriction = club.ageRestriction.toString() ==
                userInputLowerCase.replaceAll("+", "").trim();
          } else {
            matchesAgeRestriction =
                club.ageRestriction.toString().contains(userInputLowerCase);
          }
          return matchesName ||
              matchesType ||
              matchesLocation ||
              matchesAgeRestriction;
        }).toList();

        // Sort based on toggle state
        if (_toggleNotifier.value) {
          filteredClubs.sort((a, b) {
            bool aOpen = ClubOpeningHoursFormatter.isClubOpen(a);
            bool bOpen = ClubOpeningHoursFormatter.isClubOpen(b);
            if (aOpen && !bOpen) return -1;
            if (!aOpen && bOpen) return 1;
            double distanceA = Geolocator.distanceBetween(
                widget.userLocation.latitude,
                widget.userLocation.longitude,
                a.lat,
                a.lon);
            double distanceB = Geolocator.distanceBetween(
                widget.userLocation.latitude,
                widget.userLocation.longitude,
                b.lat,
                b.lon);
            return distanceA.compareTo(distanceB);
          });
        } else {
          filteredClubs.sort((a, b) {
            double distanceA = Geolocator.distanceBetween(
                widget.userLocation.latitude,
                widget.userLocation.longitude,
                a.lat,
                a.lon);
            double distanceB = Geolocator.distanceBetween(
                widget.userLocation.latitude,
                widget.userLocation.longitude,
                b.lat,
                b.lon);
            return distanceA.compareTo(distanceB);
          });
        }

        // Handle empty results
        if (filteredClubs.isEmpty) {
          return [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  S.of(context).no_locations_found,
                  style: const TextStyle(color: redAccent, fontSize: 14),
                ),
              ),
            ),
          ];
        }

        // Build suggestion tiles
        return filteredClubs.map((club) {
          String formattedClubName =
              ClubNameFormatter.formatClubName(club.name);
          String formattedClubLocation =
              ClubNameFormatter.displayClubLocation(club);
          String formattedDistance =
              ClubDistanceCalculator.displayDistanceToClub(
            club: club,
            userLat: widget.userLocation.latitude,
            userLon: widget.userLocation.longitude,
          );
          bool hasCustomLogo = club.typeOfClubImg.isNotEmpty;

          return ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: ClubOpeningHoursFormatter.isClubOpen(club)
                      ? primaryColor
                      : redAccent,
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
                  cacheManager: CacheManager(Config(
                    "customCacheKey",
                    stalePeriod: const Duration(days: 7),
                    maxNrOfCacheObjects: 100,
                  )),
                ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(formattedClubName, style: kTextStyleP3),
                const SizedBox(height: 2.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        formattedClubLocation,
                        style: kTextStyleP3.copyWith(color: primaryColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      formattedDistance,
                      style: kTextStyleP3.copyWith(color: primaryColor),
                    ),
                  ],
                ),
              ],
            ),
            trailing: hasCustomLogo
                ? CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider(club.typeOfClubImg),
                    radius: 15.0,
                  )
                : const SizedBox(width: 30, height: 30),
            onTap: () {
              Navigator.pop(context);
              widget.onClubSelected(club);
            },
          );
        }).toList();
      },
    );
  }
}
