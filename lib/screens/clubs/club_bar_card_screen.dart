import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/models/clubs/club_data.dart';

class ClubBarCardScreen extends StatelessWidget {
  static const id = 'club_bar_card';

  final ClubData club;

  const ClubBarCardScreen({Key? key, required this.club}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: white),
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: white, fontSize: 18),
              children: [
                const TextSpan(text: 'Bar Card for '),
                TextSpan(
                  text: club.name,
                  style: const TextStyle(color: primaryColor),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Text('Bar card for ${club.name}',
            style: const TextStyle(color: white)),
      ),
    );
  }
}
