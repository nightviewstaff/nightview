import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/screens/admin/club_favorites_section.dart';
import 'package:nightview/screens/admin/club_likes_section.dart';
import 'package:nightview/screens/admin/party_status_section.dart';
import 'package:nightview/screens/admin/test_users_section.dart';
import 'package:nightview/screens/admin/total_users_section.dart';
import 'package:nightview/screens/admin/user_growth_section.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        title: Text('Admin Panel', style: kTextStyleAdmin),
        backgroundColor: black,
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 6.0, right: 6.0),
        children: [
          const TotalUsersSection(),
          Divider(color: nightviewOrange, thickness: 0.5),
          const TestUsersSection(),
          Divider(color: nightviewOrange, thickness: 0.5),
          const UserGrowthSection(),
          Divider(color: nightviewOrange, thickness: 0.5),
          const PartyStatusSection(),
          Divider(color: nightviewOrange, thickness: 0.5),
          ClubFavoritesSection(),
          Divider(color: nightviewOrange, thickness: 0.5),
          ClubLikesSection(),
          Divider(color: nightviewOrange, thickness: 0.5),
        ],
      ),
    );
  }
}
