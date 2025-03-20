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
  static const Duration _searchDelay = Duration(seconds: 1);

  DateTime? _lastUpdate;
  List<UserData> _searchedUsers = [];
  bool _shouldSearch = false;
  final List<ImageProvider> _searchedUserPbs = [];

  List<UserData> get searchedUsers => _searchedUsers;

  List<ImageProvider> get searchedUserPbs => _searchedUserPbs;

  set searchedUsers(List<UserData> value) {
    _searchedUsers = value;
    notifyListeners();
  }

  void _addUserPb(String? url) {
    if (url == null) {
      _searchedUserPbs.add(const AssetImage('images/user_pb.jpg'));
    } else {
      _searchedUserPbs.add(CachedNetworkImageProvider(url));
    }
    notifyListeners();
  }

  void reset() {
    _lastUpdate = null;
    _searchedUsers.clear();
    _searchedUserPbs.clear();
    notifyListeners();
  }

  void updateSearch(BuildContext context, String value) {
    _lastUpdate = DateTime.now();
    _shouldSearch = true;

    if (value.isEmpty) {
      searchedUsers = [];
      _shouldSearch = false;
      return;
    }

    Future.delayed(_searchDelay, () async {
      DateTime now = DateTime.now();
      Duration diff = now.difference(_lastUpdate!);
      if (diff > _searchDelay) {
        List<UserData> friendFilteredUsers =
            await FriendsHelper.filterFriends(_getUsers(context, value));

        Future.wait(friendFilteredUsers.map((user) async =>
            await FriendRequestHelper.userHasRequest(user.id)
                ? null
                : user)).then((requestFilteredUsers) async {
          requestFilteredUsers.removeWhere((user) => user == null);
          List<UserData> filteredUsers =
              List<UserData>.from(requestFilteredUsers);

          if (_shouldSearch) {
            searchedUsers = filteredUsers;

            _searchedUserPbs.clear();
            for (UserData user in filteredUsers) {
              String? url =
                  await ProfilePictureHelper.getProfilePicture(user.id);
              _addUserPb(url);
            }
          }
          _shouldSearch = false;
        });
      }
    });
  }

  void removeFromSearch(int index) {
    _searchedUsers.removeAt(index);
    _searchedUserPbs.removeAt(index);
    notifyListeners();
  }

  List<UserData> _getUsers(BuildContext context, String searchStr) {
    List<UserData> users = [];
    Map<String, UserData> allUsers =
        Provider.of<GlobalProvider>(context, listen: false)
            .userDataHelper
            .userData;

    for (UserData user in allUsers.values) {
      String fullName =
          '${user.firstName.trim()} ${user.lastName.trim()}'.toLowerCase();
      if (fullName.contains(searchStr.toLowerCase().trim())) {
        users.add(user);
      }
    }

    return users;
  }
}
