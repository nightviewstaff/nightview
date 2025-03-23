import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nightview/helpers/users/friends/friend_request_helper.dart';
import 'package:nightview/helpers/users/friends/friends_helper.dart';
import 'package:nightview/helpers/users/misc/profile_picture_helper.dart';
import 'package:nightview/models/users/user_data.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:provider/provider.dart';

class SearchFriendsHelper extends ChangeNotifier {
  static const Duration _searchDelay = Duration(milliseconds: 300);

  DateTime? _lastUpdate;
  List<UserData> _searchedUsers = [];
  final List<ImageProvider?> _searchedUserPbs =
      []; // Nullable to indicate loading

  List<UserData> get searchedUsers => _searchedUsers;
  List<ImageProvider?> get searchedUserPbs => _searchedUserPbs;

  set searchedUsers(List<UserData> value) {
    _searchedUsers = value;
    _searchedUserPbs.clear();
    _searchedUserPbs
        .addAll(List.filled(value.length, null)); // Placeholder for images
    notifyListeners();
    _loadProfilePictures(); // Load images in background
  }

  void _addUserPb(String? url) {
    if (url == null) {
      _searchedUserPbs.add(const AssetImage('images/user_pb.jpg'));
    } else {
      _searchedUserPbs.add(CachedNetworkImageProvider(url));
    }
  }

  void reset() {
    _lastUpdate = null;
    _searchedUsers.clear();
    _searchedUserPbs.clear();
    notifyListeners();
  }

  void preloadInitialSuggestions(BuildContext context) {
    updateSearch(context, ''); // Empty = show all
  }

  void updateSearch(BuildContext context, String value) {
    _lastUpdate = DateTime.now();

    Future.delayed(_searchDelay, () async {
      if (_lastUpdate == null) return;

      final diff = DateTime.now().difference(_lastUpdate!);
      if (diff >= _searchDelay) {
        final allUsers = _getFilteredUsers(context, value);

        final requestFilteredUsers = <UserData>[];
        for (final user in allUsers) {
          final hasRequest = await FriendRequestHelper.userHasRequest(user.id);
          if (!hasRequest) {
            requestFilteredUsers.add(user);
          }
        }

        searchedUsers =
            requestFilteredUsers; // Updates users and triggers image loading
      }
    });
  }

  void removeFromSearch(int index) {
    _searchedUsers.removeAt(index);
    _searchedUserPbs.removeAt(index);
    notifyListeners();
  }

  List<UserData> _getFilteredUsers(BuildContext context, String searchStr) {
    final allUsersMap = Provider.of<GlobalProvider>(context, listen: false)
        .userDataHelper
        .userData;

    final search = searchStr.trim().toLowerCase();
    return allUsersMap.values.where((user) {
      final fullName = '${user.firstName} ${user.lastName}'.toLowerCase();
      return search.isEmpty || fullName.contains(search);
    }).toList();
  }

  Future<void> _loadProfilePictures() async {
    for (int i = 0; i < _searchedUsers.length; i++) {
      if (_searchedUserPbs[i] == null) {
        // Only load if not already set
        final url =
            await ProfilePictureHelper.getProfilePicture(_searchedUsers[i].id);
        _searchedUserPbs[i] = (url != null
            ? CachedNetworkImageProvider(url)
            : const AssetImage('images/user_pb.jpg')) as ImageProvider<Object>?;
        notifyListeners(); // Update UI as each image loads
      }
    }
  }
}
