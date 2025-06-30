import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/constants/icons.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/generated/l10n.dart';
import 'package:nightview/providers/main_navigation_provider.dart';
import 'package:nightview/providers/night_map_provider.dart';
import 'package:nightview/screens/admin/admin_screen.dart';
import 'package:provider/provider.dart';

class MainBottomNavigationBar extends StatelessWidget {
  const MainBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isAdmin = Provider.of<GlobalProvider>(context).isAdmin;

    final navProvider = Provider.of<MainNavigationProvider>(context);
    final currentIndex = navProvider.currentScreenIndex;

    final items = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: const Icon(defaultMap),
        label: S.of(context).map,
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.search_sharp),
        label: 'Explore',
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.people_alt),
        label: S.of(context).social,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.person_4_rounded),
        label: S.of(context).profile,
      ),
    ];
    if (isAdmin) {
      items.add(
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.shield,
            color: nightviewOrange,
          ),
          label: 'Admin',
        ),
      );
    }

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 12,
      unselectedFontSize: 10,
      selectedItemColor: primaryColor,
      unselectedItemColor: secondaryColor,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      currentIndex: currentIndex,
      iconSize: 18,
      items: items,
      onTap: (index) {
        if (index == 0) {
          navProvider.setScreen(newPage: PageName.nightMap);
        } else if (index == 1) {
          navProvider.setScreen(newPage: PageName.explore);
        } else if (index == 2) {
          navProvider.setScreen(newPage: PageName.nightSocial);
        } else if (index == 3) {
          navProvider.setScreen(newPage: PageName.profile);
        } else if (isAdmin && index == 4) {
          navProvider.setScreen(newPage: PageName.admin);
        }
      },
    );
  }
}

        // Consumer<GlobalProvider>(
        //   builder: (context, provider, child) {
        //     // TODO
        //     bool isAdmin = provider.isAdmin;
        //     return isAdmin
        //         ? Positioned(
        //             bottom: 20.0, // Adjust to position above the nav bar
        //             child: GestureDetector(
        //               onTap: () {
        //                 print('Admin icon tapped');
        //                 Navigator.push(
        //                   context,
        //                   MaterialPageRoute(
        //                       builder: (context) => const AdminScreen()),
        //                 );
        //               },
        //               child: Container(
        //                 padding: const EdgeInsets.all(8.0),
        //                 child: const Icon(
        //                   Icons.shield, // Admin icon
        //                   color: nightviewOrange,
        //                   size: 30.0,
        //                 ),
        //               ),
        //             ),
        //           )
        //         : const SizedBox(); // Hide if not admin
        //   },
        // ),

        /* TODO not working as intended. Not needed for now.
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
                      remainingItemsNotifier: clubDataHelper.remainingClubsNotifier,
                      messageOnTap: "Henter resterende lokationer i baggrunden ({count})",
                    );
                  }
                  return const SizedBox(); // ✅ Hide when everything is fully loaded
                },
              );
            }
          },
        ),
        */
