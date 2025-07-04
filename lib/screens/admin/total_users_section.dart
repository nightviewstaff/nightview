import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';

class TotalUsersSection extends StatelessWidget {
  const TotalUsersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('user_data').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox();

          final docs = snapshot.data!.docs;
          final allUsers = docs.length;
          final femaleCount = docs
              .where((doc) =>
                  (doc.data() as Map<String, dynamic>)['gender'] == 'F')
              .length;
          final maleCount = docs
              .where((doc) =>
                  (doc.data() as Map<String, dynamic>)['gender'] == 'M')
              .length;
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

          return LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final spacing = screenWidth * 0.10;

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Total Users',
                          style: kTextStyleH3.copyWith(color: nightviewOrange)),
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
                                      decoration: TextDecoration.underline)),
                            ],
                          ),
                          SizedBox(width: spacing),
                          Column(
                            children: [
                              Text('Male', style: kTextStyleH3ToP1),
                              Text('$maleCount',
                                  style: kTextStyleH3ToP1.copyWith(
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline)),
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
                                      decoration: TextDecoration.underline)),
                            ],
                          ),
                          SizedBox(width: spacing),
                          Column(
                            children: [
                              Text('iOS', style: kTextStyleH3ToP1),
                              Text('$isIOSUser',
                                  style: kTextStyleH3ToP1.copyWith(
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline)),
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
      ),
    );
  }
}
