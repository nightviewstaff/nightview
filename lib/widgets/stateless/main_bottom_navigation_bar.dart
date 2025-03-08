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
        ValueListenableBuilder<int>(
          valueListenable: clubDataHelper.remainingNearbyClubsNotifier,
          builder: (context, remainingNearby, child) {
            if (remainingNearby > 1) {
              // ✅ Display Red Counter While Nearby Clubs are Loading
              return GestureDetector(
                onTap: () {
                  CustomModalMessage.showCustomBottomSheetOneSecond(
                    // TODO CHANGE COLOR FROM RED -> GREY -> Primcol when 1/3 2/3 and 3/3 fetched of nearby!
                    context: context,
                    message: "Henter lokationer nær dig",
                    textStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2, // ✅ Thin indicator
                        valueColor: AlwaysStoppedAnimation<Color>(secondaryColor), // ✅ Subtle color
                      ),
                    ),
                    Text(
                      remainingNearby > 999 ? "999+" : remainingNearby.toString(),
                      style: const TextStyle(
                        color: redAccent,
                        fontSize: 7,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }
            else {
              // ✅ Switch to Loader when Nearby Clubs are Fully Loaded
              return ValueListenableBuilder<int>(
                valueListenable: clubDataHelper.remainingClubsNotifier,
                builder: (context, remainingClubs, child) {
                  if (remainingClubs > 0) {
                    return LoadingIndicatorWithTick(
                      remainingItemsNotifier: clubDataHelper
                          .remainingClubsNotifier,
                      messageOnTap: "Henter resterende lokationer i baggrunden ({count})",
                    );
                  }
                  return const SizedBox(); // ✅ Hide when everything is fully loaded
                },
              );
            }
          },
        ),

      ],
    );
  }
}
