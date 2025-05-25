import 'package:flutter/material.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/never_used/night_offers/night_offers_main_screen.dart';
import 'package:nightview/screens/night_map/night_map_main_screen.dart';
import 'package:nightview/screens/night_social/night_social_main_screen.dart';
import 'package:nightview/screens/profile/my_profile_main_screen.dart';
import 'package:nightview/screens/explore_screen.dart';

class MainNavigationProvider extends ChangeNotifier {
  PageName _currentPageName = PageName.nightMap;
  PageName get currentPageName => _currentPageName;
  int _currentIndex = 0;

  final List<Widget> screens = [
    const NightMapMainScreen(), // index 0
    const ExploreScreen(), // index 1
    const NightSocialMainScreen(), // index 3
    const MyProfileMainScreen(), // index 4
  ];

  Widget get currentScreen => screens[_currentIndex];

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  String get currentPageNameAsString {
    switch (_currentPageName) {
      case PageName.nightMap:
        return 'NightMap';

      case PageName.explore:
        return 'Explore';

      case PageName.nightSocial:
        return 'NightSocial';

      case PageName.profile:
        return 'Profile';
    }
  }

  int get currentScreenIndex {
    switch (_currentPageName) {
      case PageName.nightMap:
        return 0;
      case PageName.explore:
        return 1;
      case PageName.nightSocial:
        return 2;
      case PageName.profile:
        return 3;
    }
  }

  void setScreen({required PageName newPage}) {
    if (_currentPageName == newPage) return; // ✅ Prevent redundant rebuilds
    _currentPageName = newPage;
    _currentIndex = currentScreenIndex;
    notifyListeners();
  }
}
