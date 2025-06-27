import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:nightview/utilities/club_data/club_data_location_formatting.dart';
import 'package:nightview/utilities/club_data/club_name_formatter.dart';

class ClubSearchBarWidgetExplore extends StatefulWidget {
  final List<ClubData> clubs;
  final LatLng userLocation;
  final Function(List<ClubData>) onFilteredClubsChanged;

  const ClubSearchBarWidgetExplore({
    Key? key,
    required this.clubs,
    required this.userLocation,
    required this.onFilteredClubsChanged,
  }) : super(key: key);

  @override
  _ClubSearchBarState createState() => _ClubSearchBarState();
}

class _ClubSearchBarState extends State<ClubSearchBarWidgetExplore> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
      _filterClubs();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterClubs() {
    List<ClubData> filteredClubs = widget.clubs.where((club) {
      if (_searchQuery.isEmpty) return true;
      String lowerQuery = _searchQuery.toLowerCase().trim();
      bool matchesName = club.name.toLowerCase().contains(lowerQuery);
      bool matchesType = club.typeOfClub.toLowerCase().contains(lowerQuery);
      String normalizedClubLocation =
          ClubDataLocationFormatting.normalizeLocation(
                  ClubNameFormatter.displayClubLocation(club))
              .toLowerCase();
      String normalizedSearch =
          ClubDataLocationFormatting.normalizeLocation(_searchQuery)
              .toLowerCase();
      bool matchesLocation = normalizedClubLocation.contains(normalizedSearch);
      bool matchesAgeRestriction;
      if (RegExp(r'^\d+\+$').hasMatch(lowerQuery)) {
        matchesAgeRestriction = club.ageRestriction.toString() ==
            lowerQuery.replaceAll("+", "").trim();
      } else {
        matchesAgeRestriction =
            club.ageRestriction.toString().contains(lowerQuery);
      }
      return matchesName ||
          matchesType ||
          matchesLocation ||
          matchesAgeRestriction;
    }).toList();
    widget.onFilteredClubsChanged(filteredClubs);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search clubs',
        hintStyle: TextStyle(color: white.withOpacity(0.6)),
        filled: false,
        fillColor: transparent,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(55),
            borderSide: BorderSide(width: 1, color: transparent)),
        prefixIcon: Icon(
          Icons.search,
          color: primaryColor,
          size: 20,
        ),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear, color: grey),
                onPressed: () {
                  setState(() {
                    _searchQuery = '';
                    _searchController.clear();
                  });
                  _filterClubs();
                },
              )
            : null,
      ),
      onSubmitted: (value) {
        FocusScope.of(context).unfocus();
      },
    );
  }
}
