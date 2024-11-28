import 'package:flutter/material.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/providers/main_navigation_provider.dart';
import 'package:provider/provider.dart';

class MainBottomNavigationBar extends StatelessWidget {
  const MainBottomNavigationBar({super.key});


  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: Provider.of<MainNavigationProvider>(context).pageIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.pin_drop),
          label: 'MAP', // KORT her i stedet?
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.percent_sharp),
        //   label: 'OFFERS',
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_alt),
          label: 'SOCIAL', //VENNER her i stedet?
        ),
      ],
      onTap: (index) {

        switch (index) {

          case 0:
            Provider.of<MainNavigationProvider>(context, listen: false).setScreen(newPage: PageName.nightMap);
            break;

          // case 1:
          //   Provider.of<MainNavigationProvider>(context, listen: false).setScreen(newPage: PageName.nightOffers);
          //   break;

          case 1:
            Provider.of<MainNavigationProvider>(context, listen: false).setScreen(newPage: PageName.nightSocial);
            break;

          default:
            print('ERROR - BUTTON DOES NOT EXIST');
            break;

        };
      },

    );
  }


}