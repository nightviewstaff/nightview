import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/generated/l10n.dart';
import 'package:nightview/models/clubs/rating.dart';

class AddRatingButton extends StatefulWidget {
  final String clubId;
  final VoidCallback? onRatingSubmitted;

  const AddRatingButton(
      {super.key, required this.clubId, this.onRatingSubmitted});

  @override
  State<AddRatingButton> createState() => _AddRatingButtonState();
}

class _AddRatingButtonState extends State<AddRatingButton> {
  User? _currentUser;
  bool _canRate = false;
  String clubName = '';
  final TextEditingController _commentController = TextEditingController();
  late final StreamSubscription _ratingListener;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _fetchClubName();
    _listenForRating();
  }

  @override
  void dispose() {
    _ratingListener.cancel();
    _commentController.dispose();
    super.dispose();
  }

  void _getCurrentUser() {
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  Future<void> _fetchClubName() async {
    final doc = await FirebaseFirestore.instance
        .collection('club_data')
        .doc(widget.clubId)
        .get();
    if (doc.exists && doc.data() != null) {
      setState(() {
        clubName = doc['name'];
      });
    }
  }

  void _listenForRating() {
    final userId = _currentUser?.uid;
    if (userId == null) return;

    _ratingListener = FirebaseFirestore.instance
        .collection('club_data')
        .doc(widget.clubId)
        .collection('ratings')
        .where('user_id', isEqualTo: userId)
        .snapshots()
        .listen((snapshot) {
      final doc = snapshot.docs.isNotEmpty ? snapshot.docs.first : null;

      setState(() {
        _canRate = doc == null;
      });
    });
  }

  Future<void> _submitRating(int stars) async {
    if (_currentUser == null) return;

    final rating = Rating(
      userId: _currentUser!.uid,
      clubId: widget.clubId,
      rating: stars,
      timestamp: Timestamp.now(),
      comment: _commentController.text.trim(),
    );

    final clubDoc =
        FirebaseFirestore.instance.collection('club_data').doc(widget.clubId);
    final ratingsCollection = clubDoc.collection('ratings');

    await ratingsCollection.add(rating.toMap());

    final allRatings = await ratingsCollection.get();
    final total = allRatings.docs
        .map((d) => (d['rating'] as num).toInt())
        .reduce((a, b) => a + b);
    final newAvg = (total / allRatings.docs.length).round();

    await clubDoc.update({'rating': newAvg});
  }

  void _showRatingDialog() async {
    if (!_canRate) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${S.of(context).already_rated} $clubName ${S.of(context).recently}',
            style: const TextStyle(color: redAccent),
          ),
          backgroundColor: black,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    int selectedRating = 0;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: black,
            title: Text(
              S.of(context).confirm_rating,
              style: const TextStyle(color: primaryColor),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 6,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() => selectedRating = index + 1);
                      },
                      child: Icon(
                        index < selectedRating ? Icons.star : Icons.star_border,
                        color: primaryColor,
                        size: 28,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _commentController,
                  maxLines: 2,
                  maxLength: 150,
                  style: const TextStyle(color: white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Optional comment',
                    hintStyle: TextStyle(color: white.withOpacity(0.6)),
                    filled: true,
                    fillColor: grey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(S.of(context).undo,
                    style: const TextStyle(color: redAccent)),
              ),
              TextButton(
                onPressed: () async {
                  if (selectedRating > 0) {
                    await _submitRating(selectedRating);
                    Navigator.of(context).pop();
                    setState(() => _canRate = false);
                    widget.onRatingSubmitted?.call();
                  }
                },
                child:
                    Text("Rate", style: const TextStyle(color: primaryColor)),
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _showRatingDialog,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        'Add Rating',
        style: TextStyle(
          color: white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
