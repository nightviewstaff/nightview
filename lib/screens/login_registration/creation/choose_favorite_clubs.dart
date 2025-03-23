import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/generated/l10n.dart';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:nightview/screens/location_permission/location_permission_checker_screen.dart';
import 'package:nightview/screens/login_registration/creation/choose_clubbing_types.dart';
import 'package:nightview/utilities/club_data/club_name_formatter.dart';
import 'package:nightview/widgets/stateless/misc/progress_bar.dart';
import 'package:nightview/widgets/icons/back_button_top_left.dart';
import 'package:nightview/widgets/icons/logo_top_right.dart';
import 'package:nightview/widgets/stateless/login_registration_button.dart';
import 'package:provider/provider.dart';
import 'package:nightview/helpers/clubs/club_data_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseFavoriteClubsScreen extends StatefulWidget {
  static const id = 'choose_favorite_clubs';

  const ChooseFavoriteClubsScreen({super.key});

  @override
  State<ChooseFavoriteClubsScreen> createState() =>
      _ChooseFavoriteClubsScreenState();
}

class _ChooseFavoriteClubsScreenState extends State<ChooseFavoriteClubsScreen> {
  late final TextEditingController _searchController;
  late final ClubDataHelper _clubDataHelper;
  final Map<String, bool> _selectedClubs = {};
  List<String> _filteredClubs = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _clubDataHelper = Provider.of<ClubDataHelper>(context, listen: false);
    _clubDataHelper.loadInitialClubs();
    _loadSelections();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Load previously selected clubs from SharedPreferences
  Future<void> _loadSelections() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (var club in _clubDataHelper.clubData.values) {
        _selectedClubs[club.id] = prefs.getBool(club.id) ?? false;
      }
    });
  }

  /// Toggle club selection with a limit of 5
  Future<void> _toggleSelection(String clubId) async {
    final selectedCount =
        _selectedClubs.values.where((selected) => selected).length;
    final isCurrentlySelected = _selectedClubs[clubId] ?? false;

    if (selectedCount >= 5 && !isCurrentlySelected) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(
            S.of(context).max_favorite_clubs_limit,
            style: TextStyle(color: redAccent),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                S.of(context).ok,
                style: TextStyle(color: primaryColor),
              ),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      _selectedClubs[clubId] = !isCurrentlySelected;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(clubId, _selectedClubs[clubId]!);
  }

  /// Filter clubs based on search input
  void _filterClubs(String query) {
    setState(() {
      _filteredClubs = _clubDataHelper.clubData.values
          .where((club) =>
              club.name.toLowerCase().contains(query.toLowerCase().trim()))
          .map((club) => club.id)
          .toList();
    });
  }

  /// Get color for "x" in "x/5" indicator
  Color _getSelectionColor(int selectedCount) {
    if (selectedCount < 3) return Colors.red;
    if (selectedCount >= 3 && selectedCount < 5) return Colors.orange;
    return primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    final selectedCount =
        _selectedClubs.values.where((selected) => selected).length;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Progress bar at the top
            Column(
              children: [
                ProgressBar(currentStep: 3, totalSteps: 3),
                SizedBox(height: 20),
              ],
            ),
            // Back button and logo
            BackButtonTopLeft(
              onPressed: () => Navigator.pushReplacementNamed(
                  context, ChooseClubbingTypesScreen.id),
            ),

            ImageInsertDefaultTopRight(),

            // Main content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 50),
                  Text(
                    S.of(context).choose_favorite_clubs_title,
                    style: kTextStyleH2,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15),
                  // Search bar with selection indicator
                  Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: TextField(
                          controller: _searchController,
                          onChanged: _filterClubs,
                          decoration: InputDecoration(
                            hintText: S.of(context).search_locations,
                            filled: true,
                            fillColor: Colors.grey.shade800,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(Icons.search, color: primaryColor),
                          ),
                          style: kTextStyleP3.copyWith(color: primaryColor),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '$selectedCount',
                                style: TextStyle(
                                  color: _getSelectionColor(selectedCount),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: '/',
                                style: TextStyle(
                                  color: Colors.white, // Only the "/" is white
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: '5',
                                style: TextStyle(
                                  color:
                                      primaryColor, // The "5" remains primaryColor
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Club grid with separate containers
                  Expanded(
                    child: ValueListenableBuilder<List<ClubData>>(
                      valueListenable: _clubDataHelper.clubDataList,
                      builder: (context, clubList, child) {
                        if (clubList.isEmpty) {
                          return Center(
                              child: CircularProgressIndicator(
                                  color: secondaryColor));
                        }
                        final displayClubs = _filteredClubs.isNotEmpty
                            ? _filteredClubs
                                .map((id) => _clubDataHelper.clubData[id]!)
                                .toList()
                            : clubList;

                        final selectedClubs = displayClubs
                            .where((club) => _selectedClubs[club.id] ?? false)
                            .toList();
                        final unselectedClubs = displayClubs
                            .where(
                                (club) => !(_selectedClubs[club.id] ?? false))
                            .toList();

                        // Calculate if 5 clubs fit in one row
                        const itemWidth = 60; // Text width governs
                        const paddingTotal = 40; // 20 on each side
                        const spacingTotal = 8; // 2 * 4 for 5 items
                        final totalWidth =
                            5 * itemWidth + spacingTotal + paddingTotal;
                        final useTwoRows = selectedClubs.length == 5 &&
                            totalWidth > screenWidth;

                        return Column(
                          children: [
                            if (selectedClubs.isNotEmpty) ...[
                              SizedBox(
                                height: 90,
                                child: useTwoRows
                                    ? Wrap(
                                        alignment: WrapAlignment.center,
                                        spacing: 5,
                                        runSpacing: 5,
                                        children: selectedClubs.map((club) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: _buildClubItem(
                                              club.logo,
                                              ClubNameFormatter.displayClubName(
                                                  club),
                                              club.id,
                                            ),
                                          );
                                        }).toList(),
                                      )
                                    : SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: selectedClubs.map((club) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2),
                                              child: _buildClubItem(
                                                club.logo,
                                                ClubNameFormatter
                                                    .displayClubName(club),
                                                club.id,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                              ),
                              Text(
                                S.of(context).favorite_club_message,
                                style: TextStyle(fontSize: 9, color: white),
                              ),
                              Container(
                                height: 2,
                                color: secondaryColor,
                                margin: EdgeInsets.symmetric(vertical: 10),
                              ),
                            ],
                            Expanded(
                              child: Scrollbar(
                                child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 5, // Reduced from 15
                                    mainAxisSpacing: 5, // Reduced from 15
                                  ),
                                  itemCount: unselectedClubs.length,
                                  itemBuilder: (context, index) {
                                    return _buildClubItem(
                                      unselectedClubs[index].logo,
                                      ClubNameFormatter.displayClubName(
                                          unselectedClubs[index]),
                                      unselectedClubs[index].id,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  // Bottom buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 20),
                    child: Row(
                      children: [
                        Expanded(
                          // TODO IMPROVE BUTTONS SOMETIME
                          child: LoginRegistrationButton(
                            height: 45,
                            borderRadius: 15,
                            text: S.of(context).skip_button,
                            type: LoginRegistrationButtonType.transparent,
                            textStyle:
                                kTextStyleH3ToP1.copyWith(color: Colors.white),
                            onPressed: () => Navigator.pushReplacementNamed(
                                context, LocationPermissionCheckerScreen.id),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: LoginRegistrationButton(
                            height: 45,
                            borderRadius: 15,
                            text: S.of(context).save_and_continue_button,
                            type: LoginRegistrationButtonType.transparent,
                            filledColor: primaryColor,
                            onPressed: _selectedClubs.containsValue(true)
                                ? () async {
                                    final userId =
                                        FirebaseAuth.instance.currentUser?.uid;
                                    if (userId != null) {
                                      final selectedIds = _selectedClubs.entries
                                          .where((entry) => entry.value)
                                          .map((entry) => entry.key)
                                          .take(5)
                                          .toList();
                                      for (var clubId in selectedIds) {
                                        await _clubDataHelper.setFavoriteClub(
                                            clubId, userId);
                                      }
                                    }
                                    Navigator.pushReplacementNamed(context,
                                        LocationPermissionCheckerScreen.id);
                                  }
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build individual club item
  Widget _buildClubItem(String logoUrl, String name, String clubId) {
    bool isSelected = _selectedClubs[clubId] ?? false;
    final club = _clubDataHelper.clubData[clubId]!;
    final baseImageSize = 50.0;
    final selectedImageSize = 55.0;

    return GestureDetector(
      onTap: () => _toggleSelection(clubId),
      child: Column(
        children: [
          SizedBox(
            width: 50,
            child: Text(
              name,
              style: kTextStyleP1.copyWith(
                color: isSelected ? primaryColor : Colors.white,
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 5),
          Container(
            width: isSelected ? selectedImageSize : baseImageSize,
            height: isSelected ? selectedImageSize : baseImageSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border:
                  isSelected ? Border.all(color: primaryColor, width: 3) : null,
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: logoUrl.isNotEmpty ? logoUrl : '',
                placeholder: (context, url) => Image.asset(
                  'images/club_types/${club.typeOfClub}_icon.png',
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, url, error) => Image.asset(
                  'images/club_types/${club.typeOfClub}_icon.png',
                  fit: BoxFit.cover,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
