import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/generated/l10n.dart';
import '../../models/clubs/rating.dart';

class RateClub extends StatefulWidget {
  final String clubId;

  const RateClub({super.key, required this.clubId});

  @override
  _RateClubState createState() => _RateClubState();
}

class _RateClubState extends State<RateClub>
    with SingleTickerProviderStateMixin {
  int clubRating = 0;
  String clubName = "";
  User? _currentUser;
  bool _canRate = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _moveAnimation;
  late Animation<Color?> _colorAnimation;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchClubData();
    _getCurrentUser();
    _checkLocationAndRatingPermission();

    // Initialize AnimationController
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);

    // Define scale animation
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.0000001).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Define move animation
    _moveAnimation = Tween<double>(begin: 0.0, end: -10.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Define color animation
    _colorAnimation =
        ColorTween(begin: secondaryColor, end: primaryColor).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _getCurrentUser() {
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  Future<void> _fetchClubData() async {
    DocumentSnapshot clubDoc = await FirebaseFirestore.instance
        .collection('club_data')
        .doc(widget.clubId)
        .get();
    if (clubDoc.exists && clubDoc.data() != null) {
      setState(() {
        clubRating = clubDoc['rating'];
        clubName = clubDoc['name']; // Fetch the club name
      });
    }
  }

  Future<void> _checkLocationAndRatingPermission() async {
    // DocumentSnapshot locationDoc = await FirebaseFirestore.instance
    //     .collection('location_data')        .doc(_currentUser!.uid).get();

    QuerySnapshot ratingQuerySnapshot = await FirebaseFirestore.instance
        .collection('club_data')
        .doc(widget.clubId)
        .collection('ratings')
        .where('user_id', isEqualTo: _currentUser!.uid)
        .get();

    bool canRate = false;

    if (ratingQuerySnapshot.docs.isEmpty) {
      canRate = true;
    }

    // DocumentSnapshot ratingDoc = ratingQuerySnapshot.docs.first;
    // DateTime lastRating = ratingDoc['timestamp'].toDate();
    // if (DateTime.now().difference(lastRating).inDays >= 30) {
    //   canRate = true;
    // }

    // if (locationDoc.exists && locationDoc['latest'].equals(true)) {
    //   DateTime lastVisit = locationDoc['timestamp'].toDate();
    //   if (DateTime.now().difference(lastVisit).inDays <= 100) {
    //     canRate = true;
    //   }
    // }

    // if (ratingDoc.exists) {

    // }
    // else {
    //   canRate = true;
    // }

    setState(() {
      _canRate = canRate;
      // _canRate = true; //TEST

      // RIGHT NOW PEOPLE CAN rate forever if they dont close the club_header. TODO
    });
  }

  void _rateClub(int rating) async {
    if (_currentUser == null) {
      // Handle unauthenticated user case
      return;
    }

    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: black,
          title: Text(S.of(context).confirm_rating,
              style: const TextStyle(color: primaryColor)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${S.of(context).give_rating} $clubName ${S.of(context).rating} $rating${S.of(context).stars}',
                style: const TextStyle(color: white),
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
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(S.of(context).undo,
                  style: const TextStyle(color: redAccent)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(S.of(context).continues,
                  style: const TextStyle(color: primaryColor)),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      Rating ratingObj = Rating(
        userId: _currentUser!.uid,
        clubId: widget.clubId,
        rating: rating,
        timestamp: Timestamp.now(),
        comment: _commentController.text.trim(),
      );
      _commentController.clear();

      await addRating(ratingObj);
      await _fetchClubData(); // Refresh club rating from the database
      setState(() {
        _canRate = false;
      });
    }

    // await showDialog( kun hvis modtaget!
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: const Text('Bedømmelse Modtaget'),
    //       content: const Text('Tak for din bedømmelse!'),
    //       backgroundColor: black,
    //       titleTextStyle: TextStyle(color: primaryColor, fontSize: 20),
    //       contentTextStyle: TextStyle(color: white),
    //       actions: <Widget>[
    //         TextButton(
    //           onPressed: () {
    //             Navigator.of(context).pop(); // Close the dialog
    //             Navigator.of(context).pushReplacementNamed('/night_map'); // Navigate to map screen
    //           },
    //           child: Text('Det var så lidt!', style: TextStyle(color: primaryColor)),
    //         ),
    //       ],
    //     );
    //   },
    // );
  }

  Future<void> addRating(Rating rating) async {
    DocumentReference clubDoc =
        FirebaseFirestore.instance.collection('club_data').doc(widget.clubId);
    CollectionReference ratings = clubDoc.collection('ratings');
    await ratings.add(
        rating.toMap()); // Maybe make the document name the id of the rater.

    // Calculate new average rating
    QuerySnapshot ratingsSnapshot = await ratings.get();
    int totalRating = 0;
    for (var doc in ratingsSnapshot.docs) {
      totalRating += (doc['rating'] as num).toInt();
    }
    int newRating = (totalRating / ratingsSnapshot.docs.length).round();

    // Update club rating
    await clubDoc.update({'rating': newRating});
  }

  Widget _buildStar(int index) {
    bool highlightStar = _canRate;

    return GestureDetector(
      onTap: () {
        if (_canRate) {
          _rateClub(index + 1);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${S.of(context).already_rated} $clubName ${S.of(context).recently}',
                style: TextStyle(color: redAccent),
              ),
              backgroundColor: Colors.black,
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, highlightStar ? _moveAnimation.value : 0),
            child: Transform.scale(
              scale: highlightStar ? _scaleAnimation.value : 1.0,
              child: Stack(
                children: [
                  Icon(
                    Icons.star_border,
                    color: secondaryColor, // Golden outline color
                    size: 20,
                  ),
                  Icon(
                    index < clubRating ? Icons.star : Icons.star_border,
                    color: _canRate
                        ? transparent
                        : (index < clubRating ? secondaryColor : primaryColor),
                    size: 20,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120, // Fixed width to fit smaller section
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 2.0, // Reduced spacing
        children: List.generate(5, (index) {
          return _buildStar(index);
        }),
      ),
    );
  }
}
