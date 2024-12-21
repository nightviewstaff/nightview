import 'package:flutter/material.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/screens/night_map/night_map_main_screen.dart';
import 'package:nightview/screens/night_social/night_social_main_screen.dart';

class MainNavigationProvider extends ChangeNotifier {

  PageName _currentPageName = PageName.nightMap;

  PageName get currentPageName => _currentPageName;

  String get currentPageNameAsString {
    switch (_currentPageName) {

      case PageName.nightMap:
        return 'NightMap';

      // case PageName.nightOffers:
      //   return 'NightOffers';

      case PageName.nightSocial:
        return 'NightSocial';

    }
  }

  int get pageIndex {
    switch (_currentPageName) {
      case PageName.nightMap:
        return 0;

      // case PageName.nightOffers:
      //   return 1;

      case PageName.nightSocial:
        return 1;
    }
  }

  Widget? get currentScreen {
    switch (_currentPageName) {

      case PageName.nightMap:
        return NightMapMainScreen();

      // case PageName.nightOffers:
      //   return NightOffersMainScreen();

      case PageName.nightSocial:
        return NightSocialMainScreen();
    }
  }

  void setScreen({required PageName newPage}) {

    _currentPageName = newPage;
    notifyListeners();

  }

}