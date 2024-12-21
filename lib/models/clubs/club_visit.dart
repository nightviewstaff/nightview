class ClubVisit {
  String userId;
  String clubId;
  int visitCount;

  ClubVisit({
    required this.userId,
    required this.clubId,
    required this.visitCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'club_id': clubId,
      'times_visited': visitCount,
    };
  }

  static ClubVisit fromMap(Map<String, dynamic> map) {
    return ClubVisit(
      userId: map['user_id'],
      clubId: map['club_id'],
      visitCount: map['times_visited'],
    );
  }
}
