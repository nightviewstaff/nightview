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
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _onSwipe(DragEndDetails details) {
    final globalProvider = Provider.of<GlobalProvider>(context, listen: false);
    if (details.velocity.pixelsPerSecond.dx > 0) {
      // Swiped right
      globalProvider.setPartyStatusLocal(PartyStatus.yes);
      globalProvider.userDataHelper.setCurrentUsersPartyStatus(status: PartyStatus.yes);
    } else if (details.velocity.pixelsPerSecond.dx < 0) {
      // Swiped left
      globalProvider.setPartyStatusLocal(PartyStatus.no);
      globalProvider.userDataHelper.setCurrentUsersPartyStatus(status: PartyStatus.no);
    } else {
      // Swiped up/down or no significant swipe
      globalProvider.setPartyStatusLocal(PartyStatus.unsure);
      globalProvider.userDataHelper.setCurrentUsersPartyStatus(status: PartyStatus.unsure);
    }

    Navigator.of(context).pushReplacementNamed(MainScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: kNormalSpacerValue),
            Text(
              'Tid til at swipe!',
              style: kTextStyleH1,
            ),
            Expanded(
              child: GestureDetector(
                onHorizontalDragEnd: _onSwipe,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return SwipeCardContent(); // Your custom card widget
                  },
                  itemCount: 1, // Only one card for demonstration, adjust as needed
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
