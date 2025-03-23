import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/constants/button_styles.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/generated/l10n.dart';
import 'package:nightview/providers/balladefabrikken_provider.dart';
import 'package:nightview/screens/balladefabrikken/shot_redemption_screen.dart';
import 'package:nightview/screens/balladefabrikken/shots_graph.dart';
import 'package:provider/provider.dart';

class ShotAccumulationScreen extends StatefulWidget {
  static String id = 'shot_accumulation_screen';
  const ShotAccumulationScreen({super.key});

  @override
  State<ShotAccumulationScreen> createState() => _ShotAccumulationScreenState();
}

class _ShotAccumulationScreenState extends State<ShotAccumulationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.all(kMainPadding),
                  child: Text(
                    S.of(context).earned_points,
                    style: kTextStyleH2,
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(kMainPadding),
                      child: Text(
                        Provider.of<BalladefabrikkenProvider>(context)
                            .points
                            .toString(),
                        style: kTextStyleH2,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => AlertDialog(
                            title: Text(S.of(context).redeem_shots),
                            content: Text(S.of(context).points_conversion),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  S.of(context).okay,
                                  style: TextStyle(color: primaryColor),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: FaIcon(Icons.info_outline),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(kMainPadding),
              child: Divider(
                color: Colors.white,
                thickness: kMainStrokeWidth,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(kMainPadding),
                child: ShotsGraph(
                  points: Provider.of<BalladefabrikkenProvider>(context).points,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(kMainPadding),
              child: Slider(
                onChanged: (newValue) {
                  int points = Provider.of<BalladefabrikkenProvider>(context,
                          listen: false)
                      .points;

                  if (newValue > points) {
                    Provider.of<BalladefabrikkenProvider>(context,
                            listen: false)
                        .redemtionCount = points;
                    Provider.of<BalladefabrikkenProvider>(context,
                            listen: false)
                        .redemtionCount = points;
                  } else if (newValue < 1) {
                    Provider.of<BalladefabrikkenProvider>(context,
                            listen: false)
                        .redemtionCount = 1;
                    Provider.of<BalladefabrikkenProvider>(context,
                            listen: false)
                        .redemtionCount = 1;
                  } else {
                    Provider.of<BalladefabrikkenProvider>(context,
                            listen: false)
                        .redemtionCount = newValue.round();
                    Provider.of<BalladefabrikkenProvider>(context,
                            listen: false)
                        .redemtionCount = newValue.round();
                  }
                },
                value: Provider.of<BalladefabrikkenProvider>(context)
                    .redemtionCount
                    .roundToDouble(),
                min: 0,
                max: 10,
                activeColor: primaryColor,
                inactiveColor: Colors.grey,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(kMainPadding),
              child: FilledButton(
                onPressed: Provider.of<BalladefabrikkenProvider>(context)
                            .redemtionCount >
                        0
                    ? () {
                        Navigator.of(context).pushNamed(ShotRedemtionScreen.id);
                      }
                    : null,
                style: kFilledButtonStyle.copyWith(
                  fixedSize: WidgetStatePropertyAll(
                    Size(double.maxFinite, 60.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(kMainPadding),
                  child: Text(
                    '${S.of(context).redeem} ${Provider.of<BalladefabrikkenProvider>(context).redemtionCount < 10 ? '${Provider.of<BalladefabrikkenProvider>(context).redemtionCount} ${Provider.of<BalladefabrikkenProvider>(context).redemtionCount == 1 ? S.of(context).shot : S.of(context).shots}' : '1 ${S.of(context).bottle}'}',
                    style: kTextStyleH2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
