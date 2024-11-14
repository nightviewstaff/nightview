import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/screens/main_screen.dart';
import 'package:nightview/widgets/swipe_card_content.dart';
import 'package:provider/provider.dart';

class SwipeMainScreen extends StatefulWidget {
  static const id = 'swipe_main_screen';

  const SwipeMainScreen({super.key});

  @override
  State<SwipeMainScreen> createState() => _SwipeMainScreenState();
}

class _SwipeMainScreenState extends State<SwipeMainScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: kNormalSpacerValue),
            Text('Tid til at swipe!', style: kTextStyleH1,),
            Expanded(
              child: AppinioSwiper(
                cardCount: 1,
                controller: Provider.of<GlobalProvider>(context).cardController,
                cardBuilder: (context, index) => SwipeCardContent(),
                onSwipeEnd: (index, direction, activity) {
                  print("Swiped direction: $direction");
                  print(activity);
                  if (direction == 1) { // TODO Figure out what direction is and how to do it properly
                    Provider.of<GlobalProvider>(context, listen: false)
                        .setPartyStatusLocal(PartyStatus.yes);
                    Provider.of<GlobalProvider>(context, listen: false)
                        .userDataHelper
                        .setCurrentUsersPartyStatus(status: PartyStatus.yes);
                  } else if (direction == -1) {
                    Provider.of<GlobalProvider>(context, listen: false)
                        .setPartyStatusLocal(PartyStatus.no);
                    Provider.of<GlobalProvider>(context, listen: false)
                        .userDataHelper
                        .setCurrentUsersPartyStatus(status: PartyStatus.no);
                  } else {
                    Provider.of<GlobalProvider>(context, listen: false)
                        .setPartyStatusLocal(PartyStatus.unsure);
                    Provider.of<GlobalProvider>(context, listen: false)
                        .userDataHelper
                        .setCurrentUsersPartyStatus(status: PartyStatus.unsure);
                  }

                  Navigator.of(context).pushReplacementNamed(MainScreen.id);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
