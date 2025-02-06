import 'dart:math';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/helpers/users/chats/chat_helper.dart';
import 'package:nightview/locations/location_service.dart';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:nightview/helpers/clubs/club_data_helper.dart';
import 'package:nightview/helpers/users/friends/friend_request_helper.dart';
import 'package:nightview/helpers/users/friends/friends_helper.dart';
import 'package:nightview/models/users/location_data.dart';
import 'package:nightview/helpers/users/misc/location_helper.dart';
import 'package:nightview/helpers/misc/main_offer_redemptions_helper.dart';
import 'package:nightview/helpers/misc/referral_points_helper.dart';
import 'package:nightview/helpers/misc/share_code_helper.dart';
import 'package:nightview/models/users/user_data.dart';
import 'package:nightview/helpers/users/misc/user_data_helper.dart';

class GlobalProvider extends ChangeNotifier {
  GlobalProvider() {

    userDataHelper = UserDataHelper(
      onReceive: (data) {
        userDataHelper.evaluatePartyCount(userData: data ?? {}).then((count) {
          _partyCount = count;
          if (DateTime.now().weekday != DateTime.sunday) {
            // if (_partyCount <= 99) { // TEST
            //   Random random = Random();
            //   _partyCount = 99 + random.nextInt(65);
            // }
          }
          // _partyCount = 1633; // TEST
          notifyListeners();
        });
      },
    );

    clubDataHelper = ClubDataHelper(
      onReceive: (data) {
        clubDataHelper.evaluateVisitors();
        notifyListeners();
      },
    );

  }

  ClubDataHelper clubDataHelper = ClubDataHelper();
  late UserDataHelper userDataHelper;
  // late LocationHelper locationHelper;
  MainOfferRedemptionsHelper mainOfferRedemptionsHelper =
      MainOfferRedemptionsHelper();
  AppinioSwiperController cardController = AppinioSwiperController();

  ClubData? _chosenClub;
  bool _chosenClubFavoriteLocal = false;
  PartyStatus _partyStatusLocal = PartyStatus.unsure;
  PermissionState _permissionState = PermissionState.noPermissions;
  int _partyCount = 0;
  bool _locationOptOut = false;
  bool _biographyChanged = false;
  bool _friendRequestsLoaded = false;
  bool _pendingFriendRequests = false;
  List<UserData> _friends = [];
  ImageProvider _profilePicture = AssetImage('images/user_pb.jpg');
  UserData? _chosenProfile;
  String? _chosenChatId;
  ImageProvider _chosenChatPicture = AssetImage('images/user_pb.jpg');
  String _chosenChatTitle = '';
  final List<ImageProvider> _friendPbs = [];
  LatLng? _userLocation;

  // TEST //
  LatLng? get userLocation => _userLocation;

  Future<void> fetchUserLocation() async {
    try {
      LocationService.getUserLocation();
    } catch (e) {
      print(e.toString());
    }
  }

  // TEST //

  ClubData get chosenClub => _chosenClub!;

  bool get chosenClubFavoriteLocal => _chosenClubFavoriteLocal;

  PartyStatus get partyStatusLocal => _partyStatusLocal;

  PermissionState get permissionState => _permissionState;

  int get partyCount => _partyCount;

  bool get locationOptOut => _locationOptOut;

  bool get biographyChanged => _biographyChanged;

  bool get friendRequestsLoaded => _friendRequestsLoaded;

  bool get pendingFriendRequests => _pendingFriendRequests;

  List<UserData> get friends => _friends;

  ImageProvider get profilePicture => _profilePicture;

  UserData? get chosenProfile => _chosenProfile;

  String? get chosenChatId => _chosenChatId;

  ImageProvider get chosenChatPicture => _chosenChatPicture;

  String get chosenChatTitle => _chosenChatTitle;

  List<ImageProvider> get friendPbs => _friendPbs;

  bool get chosenClubFavorite {
    String? userId = userDataHelper.currentUserId;
    String clubId = chosenClub.id;
    List<dynamic> favoritesList;

    try {
      favoritesList = clubDataHelper.clubData[clubId]!.favorites;
    } catch (e) {
      print(e);
      return false;
    }

    return favoritesList.contains(userId);
  }

  Color get partyStatusColor {
    switch (_partyStatusLocal) {
      case PartyStatus.unsure:
        return grey;
      case PartyStatus.yes:
        return primaryColor;
      case PartyStatus.no:
        return redAccent;
    }
  }

  void setChosenClub(ClubData newValue) {
    _chosenClub = newValue;
    notifyListeners();
  }

  void setChosenClubFavoriteLocal(bool newValue) {
    _chosenClubFavoriteLocal = newValue;
    notifyListeners();
  }

  void setPartyStatusLocal(PartyStatus status) {
    _partyStatusLocal = status;
    notifyListeners();
  }

  void setPermissionState(PermissionState newValue) {
    _permissionState = newValue;
    notifyListeners();
  }

  void setLocationOptOut(bool optOut) {
    _locationOptOut = optOut;
    notifyListeners();
  }

  void setBiographyChanged(bool newValue) {
    _biographyChanged = newValue;
    notifyListeners();
  }

  void setFriendRequestsLoaded(bool newValue) {
    _friendRequestsLoaded = newValue;
    notifyListeners();
  }

  void setPendingFriendRequests(bool newValue) {
    _pendingFriendRequests = newValue;
    notifyListeners();
  }

  void setFriends(List<UserData> friends) {
    _friends = friends;
    notifyListeners();
  }

  void setProfilePicture(String? url) {
    if (url == null) {
      _profilePicture = AssetImage('images/user_pb.jpg');
    } else {
      _profilePicture = CachedNetworkImageProvider(url);
    }
    notifyListeners();
  }

  void setChosenProfile(UserData profile) {
    _chosenProfile = profile;
    notifyListeners();
  }

  void setChosenChatId(String id) {
    _chosenChatId = id;
    notifyListeners();
  }

  void setChosenChatPicture(String? url) {
    if (url == null) {
      _chosenChatPicture = AssetImage('images/user_pb.jpg');
    } else {
      _chosenChatPicture = CachedNetworkImageProvider(url);
    }
    notifyListeners();
  }

  void setChosenChatTitle(String? newValue) {
    if (newValue == null) {
      _chosenChatTitle = '';
    } else {
      _chosenChatTitle = newValue;
    }
    notifyListeners();
  }

  void addFriendPb(String? url) {
    if (url == null) {
      _friendPbs.add(const AssetImage('images/user_pb.jpg'));
    } else {
      _friendPbs.add(CachedNetworkImageProvider(url));
    }
    notifyListeners();
  }

  void clearFriendPbs() {
    _friendPbs.clear();
    notifyListeners();
  }

  Future<bool> deleteAllUserData() async {
    String? userIdToDelete = userDataHelper.currentUserId;

    if (userIdToDelete == null) {
      return false;
    }

    try {
      await userDataHelper.deleteDataAssociatedTo(userIdToDelete);
      await clubDataHelper.deleteDataAssociatedTo(userIdToDelete);
      // await locationHelper.deleteDataAssociatedTo(userIdToDelete); In provider now
      await mainOfferRedemptionsHelper.deleteDataAssociatedTo(userIdToDelete);
      await FriendRequestHelper.deleteDataAssociatedTo(userIdToDelete);
      await FriendsHelper.deleteDataAssociatedTo(userIdToDelete);
      await ChatHelper.deleteDataAssociatedTo(userIdToDelete);
      await ShareCodeHelper.deleteDataAssociatedTo(userIdToDelete);
      await ReferralPointsHelper.deleteDataAssociatedTo(userIdToDelete);

      // Needs to be last
      await userDataHelper.deleteCurrentUser();
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }
}
