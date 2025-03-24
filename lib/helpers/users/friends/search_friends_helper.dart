import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/helpers/users/friends/friend_request_helper.dart';
import 'package:nightview/helpers/users/friends/friends_helper.dart';
import 'package:nightview/helpers/users/misc/profile_picture_helper.dart';
import 'package:nightview/models/users/user_data.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:provider/provider.dart';

class SearchFriendsHelper extends ChangeNotifier {
  static const Duration _searchDelay = Duration(milliseconds: 300);
  static const int pageSize = 50;

  DateTime? _lastUpdate;
  List<UserData> _searchedUsers = [];
  final Map<String, ImageProvider?> _userPbs = {};
  final Map<String, bool> _hasPictureCache = {};
  int _currentPage = 0;
  bool _hasMore = true;
  LatLng? _userLocation;
  String _currentSearch = '';

  List<UserData> get searchedUsers => _searchedUsers;
  List<ImageProvider?> get searchedUserPbs =>
      _searchedUsers.map((user) => _userPbs[user.id]).toList();
  bool get hasMore => _hasMore;

  void reset() {
    _lastUpdate = null;
    _searchedUsers.clear();
    _userPbs.clear();
    _hasPictureCache.clear();
    _currentPage = 0;
    _hasMore = true;
    _currentSearch = '';
    notifyListeners();
  }

  void preloadInitialSuggestions(BuildContext context) {
    _userLocation =
        Provider.of<GlobalProvider>(context, listen: false).userLocation;
    _loadInitialUsers(context);
  }

  void _loadInitialUsers(BuildContext context) async {
    final allUsers = await _getSortedUsers(context, '');
    final initialUsers = allUsers.take(pageSize).toList();
    _searchedUsers = initialUsers;
    for (var user in initialUsers) {
      _userPbs[user.id] = null;
    }
    _hasMore = allUsers.length > pageSize;
    notifyListeners();
    _loadProfilePicturesInBatches(context, initialUsers);
    _refineWithFriendRequests(context, initialUsers);
  }

  void loadMore(BuildContext context) async {
    if (!_hasMore) return;
    final allUsers = await _getSortedUsers(context, _currentSearch);
    final start = _currentPage * pageSize;
    final end =
        start + pageSize > allUsers.length ? allUsers.length : start + pageSize;
    final nextUsers = allUsers.sublist(start, end);
    for (var user in nextUsers) {
      if (!_userPbs.containsKey(user.id)) {
        _userPbs[user.id] = null;
      }
    }
    _searchedUsers.addAll(nextUsers);
    _currentPage++;
    _hasMore = end < allUsers.length;
    notifyListeners();
    _loadProfilePicturesInBatches(context, nextUsers);
    _refineWithFriendRequests(context, nextUsers);
  }

  void updateSearch(BuildContext context, String value) {
    _currentSearch = value;
    _lastUpdate = DateTime.now();
    Future.delayed(_searchDelay, () async {
      if (_lastUpdate == null ||
          DateTime.now().difference(_lastUpdate!) < _searchDelay) return;
      final allUsers = await _getSortedUsers(context, value);
      _currentPage = 0;
      _searchedUsers = allUsers.take(pageSize).toList();
      for (var user in _searchedUsers) {
        if (!_userPbs.containsKey(user.id)) {
          _userPbs[user.id] = null;
        }
      }
      _hasMore = allUsers.length > pageSize;
      notifyListeners();
      _loadProfilePicturesInBatches(context, _searchedUsers);
      _refineWithFriendRequests(context, _searchedUsers);
    });
  }

  void removeFromSearch(int index) {
    final userId = _searchedUsers[index].id;
    _searchedUsers.removeAt(index);
    _userPbs.remove(userId);
    _hasPictureCache.remove(userId);
    notifyListeners();
  }

  Future<List<UserData>> _getSortedUsers(
      BuildContext context, String searchStr) async {
    final allUsersMap = Provider.of<GlobalProvider>(context, listen: false)
        .userDataHelper
        .userData;
    final search = searchStr.trim().toLowerCase();
    final userList = allUsersMap.values.toList();

    // Fetch friend IDs once to avoid multiple Firestore calls
    final friendIds = await FriendsHelper.getAllFriendIds();

    // Filter users by name and exclude friends
    final filteredUsers = userList.where((user) {
      final fullName = '${user.firstName} ${user.lastName}'.toLowerCase();
      // Exclude users who are already friends
      return !friendIds.contains(user.id) &&
          (search.isEmpty || fullName.contains(search));
    }).toList();

    // Sort: Exact firstName matches first, then profile pictures, then active status, then proximity
    filteredUsers.sort((a, b) {
      // 1. Exact firstName match
      final aExactFirst = a.firstName.toLowerCase() == search ? 0 : 1;
      final bExactFirst = b.firstName.toLowerCase() == search ? 0 : 1;
      if (aExactFirst != bExactFirst) return aExactFirst.compareTo(bExactFirst);

      // 2. Profile picture priority
      final aHasPic = _hasPictureCache[a.id] ?? false ? 0 : 1;
      final bHasPic = _hasPictureCache[b.id] ?? false ? 0 : 1;
      if (aHasPic != bHasPic) return aHasPic.compareTo(bHasPic);

      // 3. Active status
      final aActive = a.partyStatus == PartyStatus.yes ? 0 : 1;
      final bActive = b.partyStatus == PartyStatus.yes ? 0 : 1;
      if (aActive != bActive) return aActive.compareTo(bActive);

      // 4. Proximity
      if (_userLocation != null) {
        final distance = Distance();
        final distA = distance.as(LengthUnit.Kilometer, _userLocation!,
            LatLng(a.lastPositionLat, a.lastPositionLon));
        final distB = distance.as(LengthUnit.Kilometer, _userLocation!,
            LatLng(b.lastPositionLat, b.lastPositionLon));
        return distA.compareTo(distB);
      }

      return 0;
    });

    return filteredUsers;
  }

  Future<void> _loadProfilePicturesInBatches(
      BuildContext context, List<UserData> users) async {
    const int batchSize = 20;
    for (int i = 0; i < users.length; i += batchSize) {
      final batch = users.sublist(
          i, i + batchSize > users.length ? users.length : i + batchSize);
      await Future.wait(batch.map((user) async {
        final url = await ProfilePictureHelper.getProfilePicture(user.id);
        ImageProvider provider;
        if (url != null && url.isNotEmpty) {
          provider = CachedNetworkImageProvider(url);
          print('Loaded profile picture for user ${user.id}: $url');
        } else {
          provider = const AssetImage('images/user_pb.jpg');
          print('Using default profile picture for user ${user.id}');
        }
        _userPbs[user.id] = provider;
        _hasPictureCache[user.id] = url != null && url.isNotEmpty;
      }));
      _reSortUsers();
    }
  }

  void _reSortUsers() {
    _searchedUsers.sort((a, b) {
      // 1. Exact firstName match
      final aExactFirst = a.firstName.toLowerCase() == _currentSearch ? 0 : 1;
      final bExactFirst = b.firstName.toLowerCase() == _currentSearch ? 0 : 1;
      if (aExactFirst != bExactFirst) return aExactFirst.compareTo(bExactFirst);

      // 2. Profile picture priority
      final aHasPic = _hasPictureCache[a.id] ?? false ? 0 : 1;
      final bHasPic = _hasPictureCache[b.id] ?? false ? 0 : 1;
      if (aHasPic != bHasPic) return aHasPic.compareTo(bHasPic);

      // 3. Active status
      final aActive = a.partyStatus == PartyStatus.yes ? 0 : 1;
      final bActive = b.partyStatus == PartyStatus.yes ? 0 : 1;
      if (aActive != bActive) return aActive.compareTo(bActive);

      // 4. Proximity
      if (_userLocation != null) {
        final distance = Distance();
        final distA = distance.as(LengthUnit.Kilometer, _userLocation!,
            LatLng(a.lastPositionLat, a.lastPositionLon));
        final distB = distance.as(LengthUnit.Kilometer, _userLocation!,
            LatLng(b.lastPositionLat, b.lastPositionLon));
        return distA.compareTo(distB);
      }

      return 0;
    });
    notifyListeners();
  }

  Future<void> _refineWithFriendRequests(
      BuildContext context, List<UserData> users) async {
    final userIds = users.map((u) => u.id).toList();
    final statuses = await FriendRequestHelper.batchCheckRequests(userIds);
    for (var user in users) {
      if (statuses[user.id] ?? false) {
        _searchedUsers.removeWhere((u) => u.id == user.id);
        _userPbs.remove(user.id);
        _hasPictureCache.remove(user.id);
      }
    }
    _reSortUsers();
  }
}
