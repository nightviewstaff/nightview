import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:nightview/models/clubs/club_data.dart';

class SearchProvider with ChangeNotifier {
  String _query = '';
  final List<ClubData> _results = [];
  bool _isLoading = false;
  List<ClubData> _allClubs = [];
  // final SearchService _searchService = SearchService();

  String get query => _query;

  List<ClubData> get results => _results;

  bool get isLoading => _isLoading;

  void updateAllClubs(List<ClubData> clubs) {
    _allClubs = clubs;
  }

  void search(String query, LatLng userLocation) async {
    _query = query;
    _isLoading = true;
    notifyListeners();

    // try {
    //   _results =
    //       await _searchService.performSearch(query, _allClubs, userLocation);
    // } catch (e) {
    //   _results = [];
    // }

    _isLoading = false;
    notifyListeners();
  }
}
