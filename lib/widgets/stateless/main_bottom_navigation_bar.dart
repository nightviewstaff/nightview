import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/providers/main_navigation_provider.dart';
import 'package:nightview/providers/night_map_provider.dart';
import 'package:provider/provider.dart';

class MainBottomNavigationBar extends StatelessWidget {
  const MainBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final clubDataHelper = Provider
        .of<NightMapProvider>(context, listen: false)
        .clubDataHelper;

    return BottomNavigationBar(
      selectedItemColor: primaryColor,
      unselectedItemColor: secondaryColor,
      currentIndex: Provider
          .of<MainNavigationProvider>(context)
          .currentScreenAsInt,
      items: [
        BottomNavigationBarItem(

          icon: Stack(
            alignment: Alignment.topRight,
            children: [
              const Icon(Icons.pin_drop), // Base icon
              ValueListenableBuilder<int>(
                valueListenable: clubDataHelper.remainingClubsNotifier,
                builder: (context, remaining, child) {
                  if (remaining == 0) return const SizedBox(); // Hide when done

                  return Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      remaining > 99 ? "99+" : remaining.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          //TODO Civilized colors
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
    );
  }


}