import 'package:flutter/material.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/screens/night_map/night_map_main_screen.dart';
import 'package:nightview/screens/night_social/night_social_main_screen.dart';

class MainNavigationProvider extends ChangeNotifier {

  PageName _currentPageName = PageName.nightMap;
  PageName get currentPageName => _currentPageName;
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const NightMapMainScreen(), // Use const if possible
    NightSocialMainScreen(),
  ];

  Widget get currentScreen => _screens[_currentIndex];

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

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

  int get currentScreenAsInt {
    switch (_currentPageName) {
      case PageName.nightMap:
        return _currentIndex = 0;

      // case PageName.nightOffers:
      //   return 1;

      case PageName.nightSocial:
return        _currentIndex = 1;
    }
  }

  void setScreen({required PageName newPage}) {

    _currentPageName = newPage;
    if(_currentPageName != PageName.nightMap) {
      notifyListeners();
    }

  }

}