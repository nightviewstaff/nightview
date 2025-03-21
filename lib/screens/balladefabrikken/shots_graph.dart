import 'package:flutter/material.dart';
import 'package:nightview/app_localization.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/generated/l10n.dart';

class ShotsGraph extends StatelessWidget {
  final int maxPoints = 10;
  final double columnWidth = 75;
  final double sepperatorWidth = 5;

  final int points;

  const ShotsGraph({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: kMainPadding),
              child: Text(
                S.of(context).free_bottle,
                style: kTextStyleH2,
              ),
            ),
          ),
          Container(
            height: sepperatorWidth,
            color: Colors.white,
          ),
          Expanded(
            flex: maxPoints - points,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: columnWidth,
                  color: Colors.grey,
                ),
                Visibility(
                  visible: points <= 5,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: kMainPadding),
                    child: Text(
                      '$points ${S.of(context).free_shots}',
                      style: kTextStyleH2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: points < 10,
            child: Container(
              height: sepperatorWidth,
              color: Colors.white,
            ),
          ),
          Expanded(
            flex: points,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: columnWidth,
                  color: primaryColor,
                ),
                Visibility(
                  visible: points > 5 && points < 10,
                  child: Padding(
                    padding: const EdgeInsets.only(top: kMainPadding),
                    child: Text(
                      '$points ${S.of(context).shots}',
                      style: kTextStyleH2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
