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
import 'package:nightview/screens/clubs/club_cover_image.dart';
import 'package:nightview/screens/clubs/club_info_header_bar.dart';
import 'package:nightview/screens/utility/emoji_priority_helper.dart';
import 'package:nightview/utilities/club_data/club_age_restriction_formatter.dart';
import 'package:nightview/utilities/club_data/club_name_formatter.dart';
import 'package:nightview/utilities/club_data/club_opening_hours_formatter.dart';
import 'package:nightview/widgets/stateful/add_rating_button.dart';
import 'package:nightview/widgets/stateful/favorite_club_button.dart';
import 'package:nightview/widgets/stateful/like_club_button.dart';
import 'package:nightview/widgets/stateful/rate_club.dart';
import 'package:nightview/widgets/stateless/distance_display_widget.dart';
import 'package:nightview/widgets/stateless/misc/custom_popup_menu_button.dart';
import 'package:provider/provider.dart';

class ClubMoreInfoScreen extends StatefulWidget {
  static const id = 'club_more_info';
  final ClubData club;
  final bool initiallyExpandOpeningHours;
  final bool scrollToReviews; //TODO Dont work!

  const ClubMoreInfoScreen({
    super.key,
    required this.club,
    this.initiallyExpandOpeningHours = false,
    this.scrollToReviews = false,
  });

  @override
  State<ClubMoreInfoScreen> createState() => _ClubMoreInfoScreenState();
}

class _ClubMoreInfoScreenState extends State<ClubMoreInfoScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _reviewKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.scrollToReviews) {
        Scrollable.ensureVisible(
          _reviewKey.currentContext!,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget buildClubHeader(BuildContext context, ClubData club) {
    final screenWidth = MediaQuery.of(context).size.width;
    final formattedClubName = ClubNameFormatter.displayClubName(club);

    return SizedBox(
      height: 250,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClubCoverImage(clubId: club.id),
          Positioned(
            top: 150,
            left: 16,
            right: 16,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: screenWidth * 0.6,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Stack(
                            children: [
                              Text(
                                formattedClubName,
                                style: kTextStyleH1.copyWith(
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 7.0
                                    ..color = primaryColor,
                                ),
                              ),
                              Text(
                                formattedClubName,
                                style: kTextStyleH1.copyWith(color: white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: const [
                          FavoriteClubButton(),
                          SizedBox(width: 8),
                          LikeClubButton(),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ClubOpeningHoursFormatter.isClubOpen(club)
                          ? primaryColor
                          : redAccent,
                      width: 3,
                    ),
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: club.logo,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String openHours =
        ClubOpeningHoursFormatter.displayClubOpeningHoursTodaySimple(
            widget.club);
    final String ageRestriction =
        ClubAgeRestrictionFormatter.displayClubAgeRestrictionFormatted(
            widget.club);

    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: white, fontSize: 18),
              children: [
                const TextSpan(text: 'Information about '),
                TextSpan(
                  text: widget.club.name,
                  style: const TextStyle(color: primaryColor),
                ),
              ],
            ),
          ),
        ),
      ), // Keep as placeholder, will be overridden by header
      body: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.only(top: 0),
        children: [
          buildClubHeader(context, widget.club),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.mail_outline_outlined,
                                color: primaryColor),
                            Container(
                              margin: const EdgeInsets.only(left: 5),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 9.0, vertical: 3.0),
                              decoration: BoxDecoration(
                                color: black,
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: white),
                              ),
                              child: const Text(
                                'Bookings',
                                style: TextStyle(
                                    color: white, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9.0, vertical: 0),
                          decoration: BoxDecoration(
                            color: grey,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 0),
                                decoration: BoxDecoration(
                                  color: white,
                                  border:
                                      Border.all(color: primaryColor, width: 3),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  widget.club.rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    color: black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Row(
                                textDirection: TextDirection.rtl,
                                children: List.generate(5, (index) {
                                  final rating = widget.club.rating ?? 0.0;
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
                            ],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FutureBuilder<String>(
                            future: fetchRatingCount(widget.club.id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox.shrink();
                              }
                              final ratingText = snapshot.data ?? '';
                              return Text(
                                ratingText,
                                style:
                                    const TextStyle(color: white, fontSize: 10),
                                textAlign: TextAlign.right,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                ClubInfoHeaderBar(
                  club: widget.club,
                  initiallyExpanded: widget.initiallyExpandOpeningHours,
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // LEFT SIDE: entrance or empty space filler
                    ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 100),
                      child: buildEntranceFeeRow(widget.club.tags),
                    ),

                    // RIGHT SIDE: distance + icon always right-aligned
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Baseline(
                          baseline: 26,
                          baselineType: TextBaseline.alphabetic,
                          child: DistanceDisplayWidget(club: widget.club),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.location_on,
                            color: primaryColor, size: 26),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                if (widget.club.description != null)
                  Container(
                    padding: const EdgeInsets.all(5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(widget.club.description.toString(),
                        style: kTextStyleP1),
                  ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Overall Rating',
                          style: kTextStyleH2.copyWith(color: white),
                        ),
                        AddRatingButton(
                          clubId: widget.club.id,
                          onRatingSubmitted: () {
                            Navigator.push;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.club.rating.toStringAsFixed(1),
                              style: kTextStyleH1.copyWith(fontSize: 28),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: List.generate(5, (index) {
                                final rating = widget.club.rating;
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
                              future: fetchRatingCount(widget.club.id),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox.shrink();
                                }
                                final ratingText = snapshot.data ?? '';
                                return Text(
                                  ratingText,
                                  style: const TextStyle(
                                      color: white, fontSize: 10),
                                  textAlign: TextAlign.center,
                                );
                              },
                            ),
                            const SizedBox(height: 15),
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
                                RateClub(clubId: widget.club.id),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('club_data')
                              .doc(widget.club.id)
                              .collection('ratings')
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox.shrink();
                            }
                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return const SizedBox.shrink();
                            }

                            final ratings = snapshot.data!.docs
                                .map((doc) => (doc['rating'] as num).toInt())
                                .toList();

                            final counts = [0, 0, 0, 0, 0];
                            for (var rating in ratings) {
                              if (rating >= 1 && rating <= 5) {
                                counts[5 - rating]++;
                              }
                            }
                            final totalCount = ratings.length;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(5, (index) {
                                final count = counts[index];
                                final ratingValue = 5 - index;
                                final showLabel =
                                    [5, 3, 1].contains(ratingValue);

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 10,
                                        child: showLabel
                                            ? Text(
                                                ratingValue.toString(),
                                                style: const TextStyle(
                                                  color: white,
                                                  fontSize: 12,
                                                ),
                                                textAlign: TextAlign.right,
                                              )
                                            : const SizedBox.shrink(),
                                      ),
                                      const SizedBox(width: 4),
                                      SizedBox(
                                        width: 200,
                                        child: LinearProgressIndicator(
                                          value: totalCount > 0
                                              ? count / totalCount
                                              : 0,
                                          backgroundColor: grey,
                                          color: primaryColor,
                                          minHeight: 8,
                                          borderRadius:
                                              BorderRadius.circular(22),
                                        ),
                                      ),
                                    ],
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
                const Divider(color: white),
                KeyedSubtree(
                  key: _reviewKey,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Reviews",
                        style: const TextStyle(
                            color: white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      AddRatingButton(
                        clubId: widget.club.id,
                        onRatingSubmitted: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('club_data')
                      .doc(widget.club.id)
                      .collection('ratings')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
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

                    return Column(
                      children: reviews.map((reviewDoc) {
                        final review = reviewDoc.data() as Map<String, dynamic>;
                        final userId = review['user_id'] ?? '';
                        final rating = review['rating'] ?? 0;
                        final reviewText = review['comment'] ?? '';
                        final timestamp =
                            (review['timestamp'] as Timestamp).toDate();

                        final timeAgoDays =
                            DateTime.now().difference(timestamp).inDays;
                        final timeAgoText =
                            timeAgoDays > 0 ? '$timeAgoDays days ago' : 'Today';

                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('user_data')
                              .doc(userId)
                              .get(),
                          builder: (context, userSnapshot) {
                            if (!userSnapshot.hasData ||
                                userSnapshot.data?.data() == null) {
                              return const SizedBox.shrink();
                            }
                            final userData = userSnapshot.data!.data()
                                as Map<String, dynamic>;

                            final firstName = userData['first_name'] ?? '';
                            final lastName = userData['last_name'] ?? '';
                            final fullName =
                                '${firstName[0].toUpperCase()}${firstName.substring(1)} ${lastName[0].toUpperCase()}${lastName.substring(1)}';

                            return FutureBuilder<String?>(
                              future: ProfilePictureHelper.getProfilePicture(
                                  userId),
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
                                  imageProvider = CachedNetworkImageProvider(
                                      urlSnapshot.data!);
                                }

                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: CircleAvatar(
                                    backgroundImage: imageProvider,
                                  ),
                                  title: Text(
                                    fullName,
                                    style: kTextStyleP1.copyWith(
                                        color: Colors.white),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                ),
              ],
            ),
          ),
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
    return '($count)';
    // count >= 10 ? '($count)' : '';
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
      const Icon(FontAwesomeIcons.ticket, color: primaryColor, size: 22),
      const SizedBox(width: 10),
      Text(
        hasFreeEntry ? 'Free Entrance' : '', // Simplified
        style: kTextStyleP1.copyWith(color: white),
      ),
    ],
  );
}
