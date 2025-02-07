import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/locations/location_service.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/providers/night_map_provider.dart';
import 'package:nightview/utilities/club_data/club_distance_calculator.dart';
import 'package:nightview/utilities/club_data/club_name_formatter.dart';
import 'package:provider/provider.dart';
import 'package:nightview/providers/search_provider.dart';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomSearchBar extends StatefulWidget { //TODO HANDLE WHEN LOADING all clubs!
  //TODO Localization: Consider extracting strings for easier translations later
  //TODO Add search history persistence
  //
  // Implement fuzzy search using algorithms like Levenshtein distance
  //
  // Add tag-based filtering
  //
  // Implement search analytics
  //
  // Add voice search capability
  //
  // Create advanced filter presets
  final Function(LatLng) onClubSelected;

  const CustomSearchBar({required this.onClubSelected, Key? key}) : super(key: key);

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}
class _CustomSearchBarState extends State<CustomSearchBar> {
  late FloatingSearchBarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FloatingSearchBarController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NightMapProvider>(
      builder: (context, nightMapProvider, _) {
        return FloatingSearchBar(
          controller: _controller,
          automaticallyImplyBackButton: false,
          clearQueryOnClose: false,
          transitionDuration: const Duration(milliseconds: 300),
          hint: 'Search clubs...',
          hintStyle: kTextStyleP3,
          border: BorderSide.none,
          margins: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          iconColor: primaryColor,
          debounceDelay: const Duration(milliseconds: 200),
          onQueryChanged: (query) {
            context.read<SearchProvider>().updateSearch(
              query,
              nightMapProvider.lastKnownPosition?.toLatLng(),
            );
          },
          onFocusChanged: (isFocused) {
            if (!isFocused) _controller.close();
          },
          builder: (context, transition) {
            return _buildSearchResults();
          },
          body: FloatingSearchBarScrollNotifier(
            child: Container(), // Empty container since map is behind
          ),
        );
      },
    );
  }

  Widget _buildSearchResults() {
    return Consumer<SearchProvider>(
      builder: (context, searchProvider, _) {
        if (searchProvider.filteredClubs.isEmpty) {
          return const Center(child: Text('No results found'));
        }

        return ListView.separated(
          padding: const EdgeInsets.only(top: 8),
          itemCount: searchProvider.filteredClubs.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final club = searchProvider.filteredClubs[index];
            return _ClubSearchResultTile(
              club: club,
              onTap: () => widget.onClubSelected(
                LatLng(club.lat, club.lon),
              ), userLocation: LatLng(55, 55), //TODO
            );
          },
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
      leading: _ClubLogo(club: club), // TODO naming
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
          ClubNameFormatter.displayClubName(club), // Implement this in your formatter
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
      radius: kBigSizeRadius,
      backgroundImage: CachedNetworkImageProvider(club.logo),
      child: club.logo.isEmpty ? const Icon(FontAwesomeIcons.building) : null,
    );
  }
}

