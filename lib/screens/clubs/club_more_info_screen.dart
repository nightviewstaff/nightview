import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/icons.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/generated/l10n.dart';
import 'package:nightview/helpers/clubs/club_data_helper.dart';
import 'package:nightview/helpers/users/misc/profile_picture_helper.dart';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/screens/utility/emoji_priority_helper.dart';
import 'package:nightview/utilities/club_data/club_age_restriction_formatter.dart';
import 'package:nightview/utilities/club_data/club_opening_hours_formatter.dart';
import 'package:nightview/widgets/stateful/rate_club.dart';
import 'package:nightview/widgets/stateless/distance_display_widget.dart';
import 'package:nightview/widgets/stateless/misc/custom_popup_menu_button.dart';
import 'package:provider/provider.dart';

class ClubMoreInfoScreen extends StatelessWidget {
  static const id = 'club_more_info';
  final ClubData club;

  const ClubMoreInfoScreen({super.key, required this.club});

  @override
  Widget build(BuildContext context) {
    final String openHours =
        ClubOpeningHoursFormatter.displayClubOpeningHoursTodaySimple(club);
    final String ageRestriction =
        ClubAgeRestrictionFormatter.displayClubAgeRestrictionFormatted(club);

    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        backgroundColor: black,
        iconTheme: const IconThemeData(color: white),
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: white, fontSize: 18),
              children: [
                const TextSpan(text: 'Information about '),
                TextSpan(
                  text: club.name,
                  style: const TextStyle(color: primaryColor),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // --- Row: Opening hours + age
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: primaryColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  openHours,
                  style: kTextStyleP1.copyWith(color: white),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: primaryColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  ageRestriction,
                  style: kTextStyleP1.copyWith(color: white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // --- Distance
          Row(
            children: [
              const Icon(Icons.location_on, color: primaryColor),
              const SizedBox(width: 6),
              Text('Find vej:', style: kTextStyleP1.copyWith(color: white)),
              const SizedBox(width: 4),
              DistanceDisplayWidget(club: club),
              const Spacer(),
              CustomPopupMenuButtonOpeningHours(club),
            ],
          ),

          const SizedBox(height: 12),

          // --- Entrance Fee
          buildEntranceFeeRow(club.tags),

          const SizedBox(height: 20),

          // --- Description Button (styled for now)
          if (1 == 3) // TODO WHEN DESCRIPTION
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: white),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Beskrivelse af stedet',
                style: kTextStyleP1.copyWith(color: white),
              ),
            ),
          const SizedBox(height: 24),

          // --- Ratings Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First Row: "Overall Rating" and "Add Rating"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Overall Rating',
                    style: kTextStyleH2.copyWith(color: white),
                  ),
                  TextButton(
                    onPressed: () {
                      // Add your rating functionality here
                    },
                    child: Text(
                      'Add Rating',
                      style: kTextStyleP1.copyWith(color: white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Second Row: Left and Right Columns
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column: Score, Stars, Rating Count, and RateClub
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        club.rating.toStringAsFixed(1),
                        style:
                            kTextStyleH1.copyWith(color: white, fontSize: 28),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: List.generate(5, (index) {
                          final rating = club.rating;
                          if (rating >= index + 1) {
                            return const Icon(Icons.star,
                                color: primaryColor, size: 14);
                          } else if (rating > index) {
                            return const Icon(Icons.star_half,
                                color: primaryColor, size: 14);
                          } else {
                            return const Icon(Icons.star_border,
                                color: primaryColor, size: 14);
                          }
                        }),
                      ),
                      const SizedBox(height: 4),
                      FutureBuilder<String>(
                        future: fetchRatingCount(club.id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox.shrink();
                          }
                          final ratingText = snapshot.data ?? '';
                          return Text(
                            ratingText,
                            style: const TextStyle(color: white, fontSize: 10),
                            textAlign: TextAlign.center,
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: secondaryColor,
                            child: CircleAvatar(
                              radius: 13,
                              backgroundImage: context
                                  .watch<GlobalProvider>()
                                  .profilePicture,
                            ),
                          ),
                          const SizedBox(width: 8),
                          RateClub(clubId: club.id), // Moved here from Expanded
                        ],
                      ),
                    ],
                  ),
                  const Spacer(), // Pushes the right column to the end

                  // Right Column: Rating Distribution Lines
                  FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('club_data')
                        .doc(club.id)
                        .collection('ratings')
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox.shrink();
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      final ratings = snapshot.data!.docs
                          .map((doc) => (doc['rating'] as num).toInt())
                          .toList();

                      final counts = [
                        0,
                        0,
                        0,
                        0,
                        0
                      ]; // index 0 = 5 stars, 4 = 1 star
                      for (var rating in ratings) {
                        if (rating >= 1 && rating <= 5) {
                          counts[5 - rating]++;
                        }
                      }
                      final totalCount = ratings.length;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(5, (index) {
                          final count = counts[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: SizedBox(
                              width: 200,
                              child: LinearProgressIndicator(
                                value: totalCount > 0 ? count / totalCount : 0,
                                backgroundColor: grey,
                                color: primaryColor,
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),
          const Divider(color: white),
          const SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Reviews",
                style: const TextStyle(
                    color: white, fontSize: 16, fontWeight: FontWeight.w600),
              ),
              // Text("Add Rating")
            ],
          ),
          const SizedBox(height: 5),
          // --- Reviews
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('club_data')
                .doc(club.id)
                .collection('ratings')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
                //TODO DONT SHOW REVIEWS FROM "Edj2ex3selWyLnUV8qvDanrNH2L2"
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text(
                  '',
                  style: TextStyle(color: Colors.white),
                );
              }

              final reviews = snapshot.data!.docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return data['user_id'] != 'Edj2ex3selWyLnUV8qvDanrNH2L2';
              }).toList();
              // final reviews = snapshot.data!.docs; //TEST0

              return Column(
                children: reviews.map((reviewDoc) {
                  final review = reviewDoc.data() as Map<String, dynamic>;
                  final userId = review['user_id'] ?? '';
                  final rating = review['rating'] ?? 0;
                  final reviewText = review['comment'] ?? '';
                  final timestamp = (review['timestamp'] as Timestamp).toDate();

                  final timeAgoDays =
                      DateTime.now().difference(timestamp).inDays;
                  final timeAgoText =
                      timeAgoDays > 0 ? '$timeAgoDays days ago' : 'Today';

                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('user_data') // Your user data collection
                        .doc(userId)
                        .get(),
                    builder: (context, userSnapshot) {
                      if (!userSnapshot.hasData ||
                          userSnapshot.data?.data() == null) {
                        return const SizedBox.shrink(); // or a fallback tile
                      }
                      final userData =
                          userSnapshot.data!.data() as Map<String, dynamic>;

                      final firstName = userData['first_name'] ?? '';
                      final lastName = userData['last_name'] ?? '';
                      final fullName =
                          '${firstName[0].toUpperCase()}${firstName.substring(1)} ${lastName[0].toUpperCase()}${lastName.substring(1)}';

                      return FutureBuilder<String?>(
                        future: ProfilePictureHelper.getProfilePicture(userId),
                        builder: (context, urlSnapshot) {
                          ImageProvider imageProvider;

                          if (urlSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            imageProvider =
                                const AssetImage('images/user_pb.jpg');
                          } else if (urlSnapshot.hasError ||
                              !urlSnapshot.hasData ||
                              urlSnapshot.data == null) {
                            imageProvider =
                                const AssetImage('images/user_pb.jpg');
                          } else {
                            imageProvider =
                                CachedNetworkImageProvider(urlSnapshot.data!);
                          }

                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundImage: imageProvider,
                            ),
                            title: Text(
                              fullName,
                              style: kTextStyleP1.copyWith(color: Colors.white),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Row(
                                  children: List.generate(
                                    5,
                                    (index) => Icon(
                                      index < rating
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: primaryColor,
                                      size: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  reviewText,
                                  style: kTextStyleP2.copyWith(
                                      color: white, fontSize: 12),
                                ),
                              ],
                            ),
                            trailing: Text(
                              timeAgoText,
                              style: kTextStyleP2.copyWith(
                                  color: Colors.white.withOpacity(0.5)),
                            ),
                          );
                        },
                      );
                    },
                  );
                }).toList(),
              );
            },
          )
        ],
      ),
    );
  }
}

Future<String> fetchRatingCount(String clubId) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('club_data')
        .doc(clubId)
        .collection('ratings')
        .get();

    final count = snapshot.docs.length;
    return count >= 10 ? '($count)' : '';
  } catch (e) {
    return '';
  }
}

Widget buildEntranceFeeRow(List<String>? tags) {
  if (tags == null || tags.isEmpty) return const SizedBox.shrink();

  final hasFreeEntry = tags.any(
    (tag) => EmojiPriorityHelper.freeEmojis.contains(
      ClubDataHelper.tagEmojiMap[tag],
    ),
  );

  final hasMoneyTag = tags.any(
    (tag) => EmojiPriorityHelper.moneyEmojis.contains(
      ClubDataHelper.tagEmojiMap[tag],
    ),
  );

  if (!hasFreeEntry && !hasMoneyTag) return const SizedBox.shrink();

  return Row(
    children: [
      const Icon(FontAwesomeIcons.ticket, color: primaryColor, size: 18),
      const SizedBox(width: 6),
      Text(
        hasFreeEntry ? 'Free entrance' : 'Entrance fee applies', // Simplified
        style: kTextStyleP1.copyWith(color: white),
      ),
    ],
  );
}
