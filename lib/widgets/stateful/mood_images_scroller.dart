import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/models/clubs/club_data.dart';

class MoodImageScroller extends StatefulWidget {
  final ClubData club;

  const MoodImageScroller({Key? key, required this.club}) : super(key: key);

  @override
  _MoodImageScrollerState createState() => _MoodImageScrollerState();
}

class _MoodImageScrollerState extends State<MoodImageScroller> {
  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0.0;

  final double imageWidth = 200.0;
  final double imageHeight = 400.0;

  late Future<List<dynamic>> imagesFuture;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollPosition = _scrollController.offset;
      });
    });

    imagesFuture = fetchMoodImages();
  }

  Future<List<dynamic>> fetchMoodImages() async {
    final firestore = FirebaseFirestore.instance;
    final now = DateTime.now();
    final clubId = widget.club.id;
    final isAfter23 = now.hour >= 23;

    final moodImagesRef = firestore.collection('mood_images');

    List<QueryDocumentSnapshot> docs = [];
    if (isAfter23) {
      final yesterday = now.subtract(const Duration(hours: 24));
      final recentSnap = await moodImagesRef
          .where('timestamp', isGreaterThan: Timestamp.fromDate(yesterday))
          .orderBy('timestamp', descending: true)
          .get();

      docs = recentSnap.docs;
    } else {
      final lastWeekDate = now.subtract(const Duration(days: 7));
      final startTime = DateTime(
          lastWeekDate.year, lastWeekDate.month, lastWeekDate.day, 0, 0);
      final endTime = startTime.add(const Duration(days: 1, hours: 4));
      final lastWeekSnap = await moodImagesRef
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startTime))
          .where('timestamp', isLessThan: Timestamp.fromDate(endTime))
          .orderBy('timestamp', descending: true)
          .get();

      docs = lastWeekSnap.docs;
    }

    if (docs.length >= 5) {
      return docs;
    }

    // Fallback to stock
    final stockUrls = await fetchStockImages(clubId);
    return stockUrls;
  }

  Future<List<String>> fetchStockImages(String clubId) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('club_images/$clubId/mood_images_stock');

    final result = await ref.listAll();

    return await Future.wait(
      result.items.map((item) => item.getDownloadURL()),
    );
  }

  double _calculateScale(int index, double scrollPosition) {
    final itemPosition = index * imageWidth;
    final centerPosition =
        scrollPosition + (MediaQuery.of(context).size.width / 2);
    final distanceFromCenter = (itemPosition - centerPosition).abs();

    const maxScale = 1.2; // Middle image is 20% larger
    const minScale = 0.8; // Side images are slightly smaller
    final scaleRange = maxScale - minScale;

    // Smooth scale transition based on distance from center
    final normalizedDistance =
        (distanceFromCenter / imageWidth).clamp(0.0, 1.0);
    return maxScale - (scaleRange * normalizedDistance);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: FutureBuilder<List<dynamic>>(
        future: imagesFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!;
          final isFirestoreDocs =
              items.isNotEmpty && items.first is DocumentSnapshot;

          return ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final scale = _calculateScale(index, _scrollPosition);
              String imageUrl;
              String comment = '';
              String rating = '';

              if (isFirestoreDocs) {
                final doc = items[index] as DocumentSnapshot;
                imageUrl = doc['url'];
                comment = doc['comment'] ?? '';
                rating = (doc['rating'] ?? '').toString();
              } else {
                imageUrl = items[index];
              }

              return Container(
                width: imageWidth,
                height: imageHeight,
                alignment: Alignment.center,
                child: Transform.scale(
                  scale: scale,
                  child: Stack(
                    clipBehavior: Clip.none, // Allows overlap
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: imageUrl,
                              width: imageWidth,
                              height: imageHeight,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                width: imageWidth,
                                height: imageHeight,
                                color: Colors.transparent,
                              ),
                              errorWidget: (context, url, error) => Container(),
                            ),
                            if (comment.isNotEmpty || rating.isNotEmpty)
                              Positioned(
                                bottom: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (rating.isNotEmpty)
                                        Row(
                                          children: List.generate(
                                            5,
                                            (i) => Icon(
                                              i < double.parse(rating)
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              size: 14,
                                              color: primaryColor,
                                            ),
                                          ),
                                        ),
                                      if (comment.isNotEmpty)
                                        Builder(
                                          builder: (context) {
                                            final shouldScroll =
                                                comment.length > 20;
                                            final constrainedWidth =
                                                imageWidth * 0.5;

                                            return SizedBox(
                                              width: constrainedWidth,
                                              height: 20,
                                              child: shouldScroll
                                                  ? Marquee(
                                                      text: comment,
                                                      style: const TextStyle(
                                                          color: white,
                                                          fontSize: 10),
                                                      scrollAxis:
                                                          Axis.horizontal,
                                                      blankSpace: 30.0,
                                                      velocity: 30,
                                                      pauseAfterRound:
                                                          const Duration(
                                                              seconds: 1),
                                                      startPadding: 10.0,
                                                      accelerationDuration:
                                                          const Duration(
                                                              seconds: 1),
                                                      accelerationCurve:
                                                          Curves.linear,
                                                      decelerationDuration:
                                                          const Duration(
                                                              milliseconds:
                                                                  500),
                                                      decelerationCurve:
                                                          Curves.easeOut,
                                                    )
                                                  : Text(
                                                      comment,
                                                      style: const TextStyle(
                                                          color: white,
                                                          fontSize: 10),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                            );
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
