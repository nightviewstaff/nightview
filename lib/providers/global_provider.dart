import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/models/chat_helper.dart';
import 'package:nightview/models/club_data.dart';
import 'package:nightview/models/club_data_helper.dart';
import 'package:nightview/models/friend_request_helper.dart';
import 'package:nightview/models/friends_helper.dart';
import 'package:nightview/models/location_data.dart';
import 'package:nightview/models/location_helper.dart';
import 'package:nightview/models/main_offer_redemptions_helper.dart';
import 'package:nightview/models/user_data.dart';
import 'package:nightview/models/user_data_helper.dart';

class GlobalProvider extends ChangeNotifier {
  GlobalProvider() {
    clubDataHelper = ClubDataHelper(
      onReceive: (data) {
        clubDataHelper.evaluateVisitors(locationHelper: locationHelper);
        notifyListeners();
      },
    );
    userDataHelper = UserDataHelper(
      onReceive: (data) {
        userDataHelper
            .evaluatePartyCount(
          userData: data ?? {},
        )
            .then((count) {
          _partyCount = count;
          notifyListeners();
        });
      },
    );
    locationHelper = LocationHelper(
      onPositionUpdate: (location) async {
        if (userDataHelper.isLoggedIn() && location != null) {
          clubDataHelper.clubData.forEach((clubId, clubData) {
            if (locationHelper.locationInClub(location: location, clubData: clubData)) {
              locationHelper.uploadLocationData(
                LocationData(
                  userId: userDataHelper.currentUserId!,
                  clubId: clubId,
                  private: false,
                  timestamp: Timestamp.now(),
                ),
              );
              return;
            }
          });
        }
        await clubDataHelper.evaluateVisitors(locationHelper: locationHelper);
        notifyListeners();
      },
    );
  }

  late ClubDataHelper clubDataHelper;
  late UserDataHelper userDataHelper;
  late LocationHelper locationHelper;

  MainOfferRedemptionsHelper mainOfferRedemptionsHelper = MainOfferRedemptionsHelper();
  AppinioSwiperController cardController = AppinioSwiperController();
  MapController nightMapController = MapController();

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
  List<ImageProvider> _friendPbs = [];

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
        return Colors.grey;
      case PartyStatus.yes:
        return primaryColor;
      case PartyStatus.no:
        return Colors.redAccent;
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
      _profilePicture = NetworkImage(url);
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
      _chosenChatPicture = NetworkImage(url);
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
      _friendPbs.add(NetworkImage(url));
    }
    notifyListeners();
  }

  void clearFriendPbs() {
    _friendPbs.clear();
    notifyListeners();
  }

  Future<void> updatePositionAndEvaluateVisitors({required double lat, required double lon}) async {
    // await userDataHelper.setCurrentUsersLastPosition(
    //   lat: lat,
    //   lon: lon,
    // );
    clubDataHelper.evaluateVisitors(
      // userData: userDataHelper.userData,
      locationHelper: locationHelper,
    );
  }

  Future<bool> deleteAllUserData() async {
    String? userIdToDelete = userDataHelper.currentUserId;

    if (userIdToDelete == null) {
      return false;
    }

    try {
      await userDataHelper.deleteDataAssociatedTo(userIdToDelete);
      await clubDataHelper.deleteDataAssociatedTo(userIdToDelete);
      await locationHelper.deleteDataAssociatedTo(userIdToDelete);
      await mainOfferRedemptionsHelper.deleteDataAssociatedTo(userIdToDelete);
      await userDataHelper.deleteCurrentUser();
      await FriendRequestHelper.deleteDataAssociatedTo(userIdToDelete);
      await FriendsHelper.deleteDataAssociatedTo(userIdToDelete);
      await ChatHelper.deleteDataAssociatedTo(userIdToDelete);
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }
}
