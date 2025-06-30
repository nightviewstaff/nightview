import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/utilities/club_data/club_data_location_formatting.dart';
import 'package:nightview/utility/utility.dart';

class ClubFavoritesSection extends StatefulWidget {
  @override
  _ClubFavoritesSectionState createState() => _ClubFavoritesSectionState();
}

class _ClubFavoritesSectionState extends State<ClubFavoritesSection> {
  int _limit = 5;
  double containerHeight = 100;

  void _loadMore() {
    setState(() {
      _limit += 15;
      containerHeight = 200;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Most Favorited Venues',
              style: kTextStyleH3.copyWith(color: nightviewOrange),
            ),
            Text(
              "(Top ${_limit})",
              style: kTextStyleH3ToP1,
            ),
            TextButton(
              onPressed: _loadMore,
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                backgroundColor: nightviewOrange,
              ),
              child: Text('Load More', style: kTextStyleP1),
            ),
          ],
        ),

        // Clubs Scrollable List
        StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('club_data').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.hasError) {
              return Text(
                'Error loading clubs: ${snapshot.error}',
                style: const TextStyle(color: white),
              );
            }

            final docs = snapshot.data!.docs;
            final sorted = docs.map((doc) {
              final name = Utility.formatString(doc['name']) ?? 'Unnamed';
              final favorites = (doc['favorites'] as List?) ?? [];
              final locationLat = doc['lat'];
              final locationLon = doc['lon'];
              final location =
                  ClubDataLocationFormatting.determineLocationFromCoordinates(
                      locationLat, locationLon);
              return {
                'name': name,
                'followers': favorites.length,
                'location': location,
              };
            }).toList()
              ..sort((a, b) => ((b['followers'] ?? 0) as int)
                  .compareTo((a['followers'] ?? 0) as int));

            final limited = sorted.take(_limit).toList();

            return Container(
              height: containerHeight,
              padding: const EdgeInsets.only(right: 0.0),
              child: Scrollbar(
                thumbVisibility: true,
                thickness: 1,
                radius: const Radius.circular(22),
                child: SingleChildScrollView(
                  child: Column(
                    children: limited.map((club) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                club['name']
                                    .toString(), // Fixed: Use club['name'] instead of name
                                style: kTextStyleP1.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Text(
                                    '${club['followers']}',
                                    style: kTextStyleP1.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: nightviewOrange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  club['location'].toString(),
                                  style: kTextStyleP1.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
