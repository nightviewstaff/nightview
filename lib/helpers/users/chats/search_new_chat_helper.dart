import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nightview/helpers/users/misc/profile_picture_helper.dart';
import 'package:nightview/models/users/user_data.dart';

class SearchNewChatHelper extends ChangeNotifier {
  List<UserData> _friends = [];
  List<UserData> _filteredFriends = [];
  List<ImageProvider> _filteredFriendPbs = [];

  List<UserData> get friends => _friends;

  List<UserData> get filteredFriends => _filteredFriends;

  List<ImageProvider> get filteredFriendPbs => _filteredFriendPbs;

  void setFriends(List<UserData> friends) {
    _friends = friends;
    _filteredFriends = friends;
    notifyListeners();

    _fetchProfilePictures();
  }

  void _addUserPb(String? url) {
    if (url == null) {
      _filteredFriendPbs.add(const AssetImage('images/user_pb.jpg'));
    } else {
      _filteredFriendPbs.add(CachedNetworkImageProvider(url));
    }
    notifyListeners();
  }

  void updateSearch(String searchStr) {
    _filteredFriends = _friends
        .where((user) => '${user.firstName.trim()} ${user.lastName.trim()}'
            .toLowerCase()
            .contains(searchStr.toLowerCase()))
        .toList();
    notifyListeners();

    _fetchProfilePictures();
  }

  void _fetchProfilePictures() async {
    _filteredFriendPbs.clear();
    for (UserData user in _filteredFriends) {
      String? url = await ProfilePictureHelper.getProfilePicture(user.id);
      _addUserPb(url);
    }
  }
}
