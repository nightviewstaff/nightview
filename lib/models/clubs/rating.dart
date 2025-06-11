import 'package:cloud_firestore/cloud_firestore.dart';

class Rating {
  final String userId;
  final String clubId;
  final int rating;
  final Timestamp timestamp;
  final String comment;

  Rating({
    required this.userId,
    required this.clubId,
    required this.rating,
    required this.timestamp,
    this.comment = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'club_id': clubId,
      'rating': rating,
      'timestamp': timestamp,
      'comment': comment,
    };
  }
}
