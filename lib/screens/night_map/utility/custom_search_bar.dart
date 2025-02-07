import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:latlong2/latlong.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/providers/night_map_provider.dart';
import 'package:nightview/providers/search_provider.dart';
import 'package:nightview/utilities/club_data/club_distance_calculator.dart';
import 'package:nightview/utilities/club_data/club_name_formatter.dart';
import 'package:provider/provider.dart';
import 'package:nightview/models/clubs/club_data.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(LatLng) onClubSelected;

  const CustomSearchBar({required this.onClubSelected, Key? key})
      : super(key: key);

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<NightMapProvider>(
      builder: (context, nightMapProvider, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(),
          child: TypeAheadField<ClubData>(
            textFieldConfiguration: TextFieldConfiguration(
              keyboardType: TextInputType.text,

              controller: _searchController,
              style: kTextStyleP2.copyWith(color: primaryColor, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                fillColor: grey[800],
                hintText:
                    'Søg efter lokationer, områder, aldersgrænser eller andet',
                hintStyle: kTextStyleP3,
                prefixIcon: Icon(Icons.search_sharp, color: primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
              ),
            ),
            suggestionsCallback: (query) async {
              final lastKnownPosition = await nightMapProvider.lastKnownPosition;
              return context.read<SearchProvider>().filterClubs(
                query,
                lastKnownPosition?.toLatLng(),
              );
            },
            itemBuilder: (context, ClubData club) {
              return _ClubSearchResultTile(
                club: club,
                onTap: () {
                  widget.onClubSelected(LatLng(club.lat, club.lon));
                  _searchController.clear();
                },
                userLocation: (nightMapProvider.lastKnownPosition)?.toLatLng() ?? LatLng(0, 0),
              );
            },
            onSuggestionSelected: (ClubData club) {
              widget.onClubSelected(LatLng(club.lat, club.lon));
              _searchController.clear();
            },
            noItemsFoundBuilder: (context) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('No results found', style: kTextStyleP3),
            ),
          ),

        );
      },
    );
  }
}

class _ClubSearchResultTile extends StatelessWidget {
  final ClubData club;
  final VoidCallback onTap;
  final LatLng userLocation;

  const _ClubSearchResultTile({
    required this.club,
    required this.onTap,
    required this.userLocation,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _ClubLogo(club: club),
      title: _buildClubTitle(),
      trailing: _buildDistanceBadge(),
      onTap: onTap,
    );
  }

  Widget _buildClubTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ClubNameFormatter.displayClubName(club),
          style: kTextStyleP3,
        ),
        const SizedBox(height: 2.0),
        Text(
          ClubNameFormatter.displayClubLocation(club),
          style: kTextStyleP3.copyWith(color: primaryColor),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildDistanceBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_pin, size: 14, color: primaryColor),
          const SizedBox(width: 4),
          Text(
            ClubDistanceCalculator.displayDistanceToClub(
              userLat: userLocation.latitude,
              userLon: userLocation.longitude,
              club: club,
            ),
            style: kTextStyleP3.copyWith(color: primaryColor),
          ),
        ],
      ),
    );
  }
}

class _ClubLogo extends StatelessWidget {
  final ClubData club;

  const _ClubLogo({required this.club});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundImage: CachedNetworkImageProvider(club.logo),
    );
  }
}
