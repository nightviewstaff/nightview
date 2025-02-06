import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/providers/main_navigation_provider.dart';
import 'package:nightview/providers/night_map_provider.dart';
import 'package:nightview/utilities/messages/custom_modal_message.dart';
import 'package:nightview/widgets/icons/loading_indicator_with_tick.dart';
import 'package:provider/provider.dart';

class MainBottomNavigationBar extends StatelessWidget {
  const MainBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final clubDataHelper = Provider
        .of<NightMapProvider>(context, listen: false)
        .clubDataHelper;

    return Stack(
      alignment: Alignment.center,
      children: [
        BottomNavigationBar(
          selectedItemColor: primaryColor,
          unselectedItemColor: secondaryColor,
          currentIndex: Provider
              .of<MainNavigationProvider>(context)
              .currentScreenIndex,
          items: [
            BottomNavigationBarItem(
              icon: Stack(
                alignment: Alignment.topRight,
                children: [
                  const Icon(Icons.pin_drop), // Base icon
                  ValueListenableBuilder<int>(
                    valueListenable: clubDataHelper.remainingNearbyClubsNotifier,
                    builder: (context, remainingNearby, child) {
                      if (remainingNearby < 1) return const SizedBox(); // ✅ Hide when done

                      // ✅ Make the red counter clickable to show a message
                      return GestureDetector(
                        onTap: () {
                          CustomModalMessage.showCustomBottomSheetOneSecond(
                            // autoDismissDurationSeconds: 2,
                            context: context,
                            message: "Henter lokationer nær dig",
                            textStyle: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: redAccent,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            remainingNearby > 999 ? "999+" : remainingNearby.toString(),
                            style: const TextStyle(
                              color: white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              // TODO civilized colors at some point?
              label: 'MAP',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.people_alt),
              label: 'SOCIAL',
            ),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                Provider.of<MainNavigationProvider>(context, listen: false)
                    .setScreen(newPage: PageName.nightMap);
                break;
              case 1:
                Provider.of<MainNavigationProvider>(context, listen: false)
                    .setScreen(newPage: PageName.nightSocial);
                break;
              default:
                print('ERROR - BUTTON DOES NOT EXIST');
                break;
            }
          },
        ),

        // ✅ Centered Small Loader (ONLY if `remainingNearbyClubsNotifier == 0` AND `remainingClubsNotifier > 0`)
        ValueListenableBuilder<int>(
          valueListenable: clubDataHelper.remainingNearbyClubsNotifier,
          builder: (context, remainingNearby, child) {
            if (remainingNearby > 0) return const SizedBox(); // ✅ Prioritize red counter

            return LoadingIndicatorWithTick( // ✅ Added return
              remainingItemsNotifier: clubDataHelper.remainingClubsNotifier, // ✅ Pass custom ValueListenable
              messageOnTap: "Henter resterende lokationer i baggrunden ({count})", // ✅ Pass custom message
            );
          },
        ),

      ],
    );
  }
}
