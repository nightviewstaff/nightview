import 'package:flutter/material.dart';
import 'package:nightview/models/clubs/club_data.dart';

// A class to hold and manage the filtered clubs list
class FilteredClubsNotifier extends ChangeNotifier {
  List<ClubData> _filteredClubs =
      []; // Replace ClubData with your actual data type
  List<ClubData> get filteredClubs => _filteredClubs;

  void updateFilteredClubs(List<ClubData> clubs) {
    _filteredClubs = clubs;
    notifyListeners(); // Tell the UI to update when the list changes
  }
}
