import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';

class PartyStatusSection extends StatefulWidget {
  const PartyStatusSection({super.key});

  @override
  State<PartyStatusSection> createState() => _PartyStatusSectionState();
}

class _PartyStatusSectionState extends State<PartyStatusSection> {
  int _daysBack = 3;
  double containerHeight = 100;

  Stream<QuerySnapshot> getRecentPartyStatusStream({required int daysBack}) {
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Party Status',
                  style: kTextStyleH3.copyWith(color: nightviewOrange)),
              Text("(${_daysBack + 1} days back)", style: kTextStyleH3ToP1),
              TextButton(
                onPressed: () {
                  setState(() {
                    _daysBack += 30;
                    containerHeight = 200;
                  });
                },
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                  backgroundColor: nightviewOrange,
                ),
                child: Text('Load More', style: kTextStyleP1),
              ),
            ],
          ),
          StreamBuilder<QuerySnapshot>(
            stream: getRecentPartyStatusStream(daysBack: _daysBack),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return const Text('Error loading data',
                    style: TextStyle(color: white));
              }

              final docs = snapshot.data!.docs;
              final Map<String, List<DocumentSnapshot>> groupedByDate = {};
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
                                      child:
                                          Text('Total', style: kTextStyleP1))),
                              Expanded(
                                  flex: 1,
                                  child: Center(
                                      child: Text('Yes', style: kTextStyleP1))),
                              Expanded(
                                  flex: 1,
                                  child: Center(
                                      child: Text('No', style: kTextStyleP1))),
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
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: [
                                      Text(
                                        DateFormat('EEEE').format(parsedDate),
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
                                        DateFormat(' - dd-MM-yyyy')
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
                                    child: Text(
                                      '${entries.length}',
                                      style: kTextStyleP1.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: nightviewOrange),
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
                                          color: primaryColor),
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
                                          color: redAccent),
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
    );
  }
}
