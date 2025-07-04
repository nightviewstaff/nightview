import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';

class TestUsersSection extends StatelessWidget {
  const TestUsersSection({super.key});

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
      if (userId == null) continue;
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('test_users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox();

          final docs = snapshot.data!.docs;
          final allUsers = docs.length;
          final isAndroidUser = docs
              .where((doc) =>
                  (doc.data() as Map<String, dynamic>)['platform']
                      ?.toLowerCase() ==
                  'android')
              .length;
          final isIOSUser = docs
              .where((doc) =>
                  (doc.data() as Map<String, dynamic>)['platform']
                      ?.toLowerCase() ==
                  'ios')
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('Test Users',
                              style: kTextStyleH3.copyWith(
                                  color: nightviewOrange)),
                          Text('$allUsers',
                              style: kTextStyleH3.copyWith(
                                  decoration: TextDecoration.underline)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Column(
                                children: [
                                  Text('Female', style: kTextStyleH3ToP1),
                                  Text('$femaleCount',
                                      style: kTextStyleH3ToP1.copyWith(
                                          fontWeight: FontWeight.bold,
                                          decoration:
                                              TextDecoration.underline)),
                                ],
                              ),
                              SizedBox(width: spacing),
                              Column(
                                children: [
                                  Text('Male', style: kTextStyleH3ToP1),
                                  Text('$maleCount',
                                      style: kTextStyleH3ToP1.copyWith(
                                          fontWeight: FontWeight.bold,
                                          decoration:
                                              TextDecoration.underline)),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            height: 30,
                            width: 1,
                            color: nightviewOrange,
                            margin: EdgeInsets.symmetric(horizontal: spacing),
                          ),
                          Row(
                            children: [
                              Column(
                                children: [
                                  Text('Android', style: kTextStyleH3ToP1),
                                  Text('$isAndroidUser',
                                      style: kTextStyleH3ToP1.copyWith(
                                          fontWeight: FontWeight.bold,
                                          decoration:
                                              TextDecoration.underline)),
                                ],
                              ),
                              SizedBox(width: spacing),
                              Column(
                                children: [
                                  Text('iOS', style: kTextStyleH3ToP1),
                                  Text('$isIOSUser',
                                      style: kTextStyleH3ToP1.copyWith(
                                          fontWeight: FontWeight.bold,
                                          decoration:
                                              TextDecoration.underline)),
                                ],
                              ),
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
    );
  }
}
