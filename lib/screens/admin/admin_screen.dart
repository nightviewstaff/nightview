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

  int _daysBack = 4;
  double containerHeight = 100;

  @override
  void dispose() {
    _userIdController.dispose();
    _partyStatusController.dispose();
    _adminStatusController.dispose();
    _friendIdController.dispose();
    super.dispose();
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StreamBuilder<List<QuerySnapshot>>(
                  stream: StreamZip([
                    FirebaseFirestore.instance
                        .collection('user_data')
                        .snapshots(),
                    FirebaseFirestore.instance
                        .collection('test_users')
                        .snapshots(),
                  ]),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox();

                    final allUsers = snapshot.data![0].docs.length;
                    final testUsers = snapshot.data![1].docs.length;

                    return Text(
                        'Test And Total Users      $testUsers/$allUsers',
                        style: kTextStyleH3);
                  },
                )
              ],
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
                          style: TextStyle(color: Colors.white),
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
                                                DateFormat('EEEE').format(
                                                    parsedDate), // weekday
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
                                              const SizedBox(width: 6),
                                              Text(
                                                DateFormat('- dd-MM-yyyy')
                                                    .format(parsedDate), // date
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
                                          child: Row(
                                            children: [
                                              Text('Total: ',
                                                  style: kTextStyleP2.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              Text('${entries.length}',
                                                  style: kTextStyleP1.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: nightviewOrange)),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Row(
                                            children: [
                                              Text('Yes: ',
                                                  style: kTextStyleP2.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              Text('$yesCount',
                                                  style: kTextStyleP1.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: primaryColor)),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Row(
                                            children: [
                                              Text('No: ',
                                                  style: kTextStyleP2.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              Text('$noCount',
                                                  style: kTextStyleP1.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: redAccent)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
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
