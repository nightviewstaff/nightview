import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nightview/constants/colors.dart';

import 'package:nightview/constants/text_styles.dart';

import 'package:nightview/screens/admin/club_favorites_section.dart';
import 'package:nightview/screens/admin/club_likes_section.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminScreen> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _partyStatusController = TextEditingController();
  final TextEditingController _adminStatusController = TextEditingController();
  final TextEditingController _friendIdController = TextEditingController();

  int _daysBack = 3; // Today + 3 days back
  int _daysBackUserGrowth = 3; // Today + 3 days back

  double containerHeight = 100;
  double containerHeightUserGrowth = 100;

  @override
  void dispose() {
    _userIdController.dispose();
    _partyStatusController.dispose();
    _adminStatusController.dispose();
    _friendIdController.dispose();
    super.dispose();
  }

  Widget buildUserStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: kTextStyleH3ToP1),
        Text(
          value,
          style: kTextStyleH3ToP1.copyWith(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline),
        ),
      ],
    );
  }

  Future<String?> getGenderForUser(String userId) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('user_data')
          .doc(userId)
          .get();

      if (!docSnapshot.exists) {
        debugPrint('user_data doc not found for userId: $userId');
        return null;
      }

      final data = docSnapshot.data();
      if (data == null) {
        debugPrint('user_data for $userId is null');
        return null;
      }

      final gender = data['gender'];
      debugPrint('Fetched gender for $userId: $gender');
      return gender;
    } catch (e) {
      debugPrint('Error fetching gender for $userId: $e');
      return null;
    }
  }

  Future<Map<String, int>> getGenderBreakdownFromUserData(
      List<DocumentSnapshot> testUserDocs) async {
    int femaleCount = 0;
    int maleCount = 0;

    for (final doc in testUserDocs) {
      final data = doc.data() as Map<String, dynamic>;
      final userId = data['user_id'];

      if (userId == null) {
        continue;
      }

      final gender = await getGenderForUser(userId);

      if (gender == null) {
        debugPrint('Gender not found for user_id: $userId');
        continue;
      }

      if (gender == 'F') femaleCount++;
      if (gender == 'M') maleCount++;
    }

    return {'F': femaleCount, 'M': maleCount};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        title: Text(
          'Admin Panel',
          style: kTextStyleAdmin,
        ),
        backgroundColor: black,
      ),
      body: ListView(
          padding: const EdgeInsets.only(left: 6.0, right: 6.0),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('user_data')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const SizedBox();

                      final docs = snapshot.data!.docs;
                      final allUsers = docs.length;

                      final isiOSUser = docs
                          .where((doc) =>
                              (doc.data() as Map<String, dynamic>)['platform']
                                  ?.toLowerCase() ==
                              'ios')
                          .length;

                      final isAndroidUser = docs
                          .where((doc) =>
                              (doc.data() as Map<String, dynamic>)['platform']
                                  ?.toLowerCase() ==
                              'android')
                          .length;

                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final screenWidth = constraints.maxWidth;
                          final spacing =
                              screenWidth * 0.10; // 5% of screen width

                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text('Total Users',
                                      style: kTextStyleH3.copyWith(
                                          color: nightviewOrange)),
                                  Text(
                                    '$allUsers',
                                    style: kTextStyleH3.copyWith(
                                        decoration: TextDecoration.underline),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // GENDER
                                  Row(
                                    children: [
                                      buildUserStat('Female',
                                          '${docs.where((doc) => (doc.data() as Map<String, dynamic>)['gender'] == 'F').length}'),
                                      SizedBox(width: spacing),
                                      buildUserStat('Male',
                                          '${docs.where((doc) => (doc.data() as Map<String, dynamic>)['gender'] == 'M').length}'),
                                    ],
                                  ),

                                  // VERTICAL DIVIDER
                                  Container(
                                    height: 30,
                                    width: 1,
                                    color: nightviewOrange,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: spacing),
                                  ),

                                  // PLATFORM
                                  Row(
                                    children: [
                                      buildUserStat(
                                          'Android', '$isAndroidUser'),
                                      SizedBox(width: spacing),
                                      buildUserStat('iOS', '$isiOSUser'),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            Divider(
              color: nightviewOrange,
              thickness: 0.5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('test_users')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const SizedBox();

                      final docs = snapshot.data!.docs;
                      final allUsers = docs.length;

                      final isiOSUser = docs
                          .where((doc) =>
                              (doc.data() as Map<String, dynamic>)['platform']
                                  ?.toLowerCase() ==
                              'ios')
                          .length;

                      final isAndroidUser = docs
                          .where((doc) =>
                              (doc.data() as Map<String, dynamic>)['platform']
                                  ?.toLowerCase() ==
                              'android')
                          .length;

                      return FutureBuilder<Map<String, int>>(
                        future: getGenderBreakdownFromUserData(docs),
                        builder: (context, genderSnapshot) {
                          if (!genderSnapshot.hasData) return const SizedBox();

                          final genderData = genderSnapshot.data!;
                          final femaleCount = genderData['F'] ?? 0;
                          final maleCount = genderData['M'] ?? 0;

                          return LayoutBuilder(
                            builder: (context, constraints) {
                              final screenWidth = constraints.maxWidth;
                              final spacing = screenWidth * 0.10;

                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text('Test Users',
                                          style: kTextStyleH3.copyWith(
                                              color: nightviewOrange)),
                                      Text(
                                        '$allUsers',
                                        style: kTextStyleH3.copyWith(
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // GENDER
                                      Row(
                                        children: [
                                          buildUserStat(
                                              'Female', '$femaleCount'),
                                          SizedBox(width: spacing),
                                          buildUserStat('Male', '$maleCount'),
                                        ],
                                      ),

                                      // VERTICAL DIVIDER
                                      Container(
                                        height: 30,
                                        width: 1,
                                        color: nightviewOrange,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: spacing),
                                      ),

                                      // PLATFORM
                                      Row(
                                        children: [
                                          buildUserStat(
                                              'Android', '$isAndroidUser'),
                                          SizedBox(width: spacing),
                                          buildUserStat('iOS', '$isiOSUser'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            Divider(
              color: nightviewOrange,
              thickness: 0.5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('User Growth',
                          style: kTextStyleH3.copyWith(color: nightviewOrange)),
                      Text(
                        "(${_daysBackUserGrowth + 1} days back)",
                        style: kTextStyleH3ToP1,
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _daysBackUserGrowth += 30;
                            containerHeight = 200;
                          });
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 0),
                          backgroundColor: nightviewOrange,
                        ),
                        child: Text('Load More', style: kTextStyleP1),
                      ),
                    ],
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: getRecentUserCreationsStream(_daysBackUserGrowth),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError || !snapshot.hasData) {
                        return const Text('Error loading data',
                            style: TextStyle(color: white));
                      }

                      final docs = snapshot.data!.docs;
                      final Map<String, int> newUsersByDate = {};
                      final today = DateTime.now();
                      final displayedDates = List.generate(
                        _daysBackUserGrowth + 1,
                        (i) => DateFormat('yyyy-MM-dd')
                            .format(today.subtract(Duration(days: i))),
                      );

                      for (final doc in docs) {
                        final data = doc.data() as Map<String, dynamic>;
                        final createdAt =
                            (data['created_at'] as Timestamp).toDate();
                        final dateKey =
                            DateFormat('yyyy-MM-dd').format(createdAt);
                        newUsersByDate[dateKey] =
                            (newUsersByDate[dateKey] ?? 0) + 1;
                      }

                      final sortedDates = displayedDates
                          .where((d) => newUsersByDate.containsKey(d))
                          .toList()
                        ..sort((a, b) => b.compareTo(a));

                      int cumulative = 0;
                      final Map<String, int> cumulativeTotals = {};

                      for (final date in sortedDates.reversed) {
                        cumulative += newUsersByDate[date]!;
                        cumulativeTotals[date] = cumulative;
                      }

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 3,
                                    child: Text('Date', style: kTextStyleP1)),
                                Expanded(
                                    flex: 1,
                                    child: Center(
                                        child: Text('Total',
                                            style: kTextStyleP1))),
                                Expanded(
                                    flex: 1,
                                    child: Center(
                                        child:
                                            Text('New', style: kTextStyleP1))),
                                Expanded(
                                    flex: 1,
                                    child: Center(
                                        child: Text('Increase',
                                            style: kTextStyleP1))),
                              ],
                            ),
                          ),
                          ...sortedDates.map((date) {
                            final parsedDate =
                                DateFormat('yyyy-MM-dd').parse(date);
                            final total = cumulativeTotals[date]!;
                            final newUsers = newUsersByDate[date]!;

                            final prevDateKey = DateFormat('yyyy-MM-dd').format(
                                parsedDate.subtract(const Duration(days: 1)));
                            final prevNew = newUsersByDate[prevDateKey] ?? 0;

                            final double incPct = prevNew > 0
                                ? ((newUsers - prevNew) / prevNew * 100)
                                : 0;

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      children: [
                                        Text(
                                          DateFormat('EEEE').format(parsedDate),
                                          style: kTextStyleP1.copyWith(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          DateFormat('- dd-MM-yyyy')
                                              .format(parsedDate),
                                          style: kTextStyleP1.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: white),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: Text('$total',
                                          style: kTextStyleP1.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: nightviewOrange)),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: Text('$newUsers',
                                          style: kTextStyleP1.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: primaryColor)),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: Text(
                                        '${incPct.toStringAsFixed(1)}%',
                                        style: kTextStyleP1.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: incPct > 0
                                              ? primaryColor
                                              : redAccent,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
            Divider(color: nightviewOrange, thickness: 0.5),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Recent Party Status',
                          style: kTextStyleH3.copyWith(color: nightviewOrange)),
                      Text(
                        "(${_daysBack + 1} days back)",
                        style: kTextStyleH3ToP1,
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _daysBack += 30;
                            containerHeight = 200;
                          });
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 0),
                          backgroundColor: nightviewOrange,
                        ),
                        child: Text('Load More', style: kTextStyleP1),
                      ),
                    ],
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: _getRecentPartyStatusStream(daysBack: _daysBack),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError || !snapshot.hasData) {
                        return const Text(
                          'Error loading data',
                          style: TextStyle(color: white),
                        );
                      }

                      final docs = snapshot.data!.docs;
                      final Map<String, List<DocumentSnapshot>> groupedByDate =
                          {};

                      for (final doc in docs) {
                        final docId = doc.id;
                        final dateKey = docId.split('_').first;
                        groupedByDate.putIfAbsent(dateKey, () => []).add(doc);
                      }

                      final sortedKeys = groupedByDate.keys.toList()
                        ..sort((a, b) => b.compareTo(a));

                      return Container(
                        height: containerHeight,
                        padding: const EdgeInsets.only(right: 0.0),
                        child: Scrollbar(
                          thumbVisibility: true,
                          thickness: 1,
                          radius: const Radius.circular(22),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header row with column titles
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child:
                                            Text('Date', style: kTextStyleP1),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Text('Total',
                                              style: kTextStyleP1),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child:
                                              Text('Yes', style: kTextStyleP1),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child:
                                              Text('No', style: kTextStyleP1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ...sortedKeys.map((date) {
                                  final entries = groupedByDate[date]!;
                                  final yesCount = entries
                                      .where((d) => d['party_status'] == 'yes')
                                      .length;
                                  final noCount = entries
                                      .where((d) => d['party_status'] == 'no')
                                      .length;

                                  final parsedDate =
                                      DateFormat('yyyy-MM-dd').parse(date);

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Row(
                                            children: [
                                              Text(
                                                DateFormat('EEEE')
                                                    .format(parsedDate),
                                                style: kTextStyleP1.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: [
                                                    'Thursday',
                                                    'Friday',
                                                    'Saturday'
                                                  ].contains(DateFormat('EEEE')
                                                          .format(parsedDate))
                                                      ? primaryColor
                                                      : white,
                                                ),
                                              ),
                                              Text(
                                                DateFormat('- dd-MM-yyyy')
                                                    .format(parsedDate),
                                                style: kTextStyleP1.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Center(
                                            child: Text(
                                              '${entries.length}',
                                              style: kTextStyleP1.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: nightviewOrange,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Center(
                                            child: Text(
                                              '$yesCount',
                                              style: kTextStyleP1.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Center(
                                            child: Text(
                                              '$noCount',
                                              style: kTextStyleP1.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: redAccent,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Divider(
              color: nightviewOrange,
              thickness: 0.5,
            ),
            ClubFavoritesSection(),
            Divider(color: nightviewOrange, thickness: 0.5),
            ClubLikesSection(),
            Divider(color: nightviewOrange, thickness: 0.5),
          ]),
    );
  }

  Stream<QuerySnapshot> getRecentUserCreationsStream(int daysBack) {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: daysBack));
    final startTimestamp = Timestamp.fromDate(start);

    return FirebaseFirestore.instance
        .collection('user_data')
        .where('created_at', isGreaterThanOrEqualTo: startTimestamp)
        .snapshots();
  }

  Stream<QuerySnapshot> _getRecentPartyStatusStream({int daysBack = 14}) {
    final now = DateTime.now().toUtc().add(const Duration(hours: 4));
    final startDate = now.subtract(Duration(days: daysBack));
    final startKey = DateFormat('yyyy-MM-dd').format(startDate);
    final endKey = DateFormat('yyyy-MM-dd').format(now);

    return FirebaseFirestore.instance
        .collection('party_status')
        .where(FieldPath.documentId, isGreaterThanOrEqualTo: '${startKey}_')
        .where(FieldPath.documentId, isLessThan: '${endKey}_\uf8ff')
        .snapshots();
  }
}
