import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';

class UserGrowthSection extends StatefulWidget {
  const UserGrowthSection({super.key});

  @override
  State<UserGrowthSection> createState() => _UserGrowthSectionState();
}

class _UserGrowthSectionState extends State<UserGrowthSection> {
  int _daysBackUserGrowth = 3; // Days back.
  double containerHeightUserGrowth = 100;

  Stream<QuerySnapshot> getRecentUserCreationsStream(int daysBack) {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: daysBack));
    final startTimestamp = Timestamp.fromDate(start);
    return FirebaseFirestore.instance
        .collection('user_data')
        .where('created_at', isGreaterThanOrEqualTo: startTimestamp)
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
                    containerHeightUserGrowth = 200;
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
                final createdAt = (data['created_at'] as Timestamp).toDate();
                final dateKey = DateFormat('yyyy-MM-dd').format(createdAt);
                newUsersByDate[dateKey] = (newUsersByDate[dateKey] ?? 0) + 1;
              }

              // Calculate cumulative totals for all dates
              final allDatesAsc =
                  displayedDates.reversed.toList(); // Ascending order
              int cumulative = 0;
              final Map<String, int> cumulativeTotals = {};
              for (final date in allDatesAsc) {
                final newUsers = newUsersByDate[date] ?? 0;
                cumulative += newUsers;
                cumulativeTotals[date] = cumulative;
              }

              return Container(
                height: containerHeightUserGrowth,
                padding: const EdgeInsets.symmetric(vertical: 0.0),
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: Text('Date', style: kTextStyleP1)),
                            Expanded(
                                flex: 1,
                                child: Center(
                                    child: Text('Total', style: kTextStyleP1))),
                            Expanded(
                                flex: 1,
                                child: Center(
                                    child: Text('New', style: kTextStyleP1))),
                            Expanded(
                                flex: 1,
                                child: Center(
                                    child:
                                        Text('Increase', style: kTextStyleP1))),
                          ],
                        ),
                        ...displayedDates.map((date) {
                          final parsedDate =
                              DateFormat('yyyy-MM-dd').parse(date);
                          final total = cumulativeTotals[date]!;
                          final newUsers = newUsersByDate[date] ?? 0;
                          final prevDateKey = DateFormat('yyyy-MM-dd').format(
                              parsedDate.subtract(const Duration(days: 1)));
                          final prevNew = newUsersByDate[prevDateKey] ?? 0;
                          final double incPct = prevNew > 0
                              ? ((newUsers - prevNew) / prevNew * 100)
                              : 0;

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
                                            fontWeight: FontWeight.w600),
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
