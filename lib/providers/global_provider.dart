import 'dart:math';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/helpers/users/chats/chat_helper.dart';
import 'package:nightview/locations/location_service.dart';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:nightview/helpers/clubs/club_data_helper.dart';
import 'package:nightview/helpers/users/friends/friend_request_helper.dart';
import 'package:nightview/helpers/users/friends/friends_helper.dart';
import 'package:nightview/helpers/misc/main_offer_redemptions_helper.dart';
import 'package:nightview/helpers/misc/referral_points_helper.dart';
import 'package:nightview/helpers/misc/share_code_helper.dart';
import 'package:nightview/models/users/user_data.dart';
import 'package:nightview/helpers/users/misc/user_data_helper.dart';

class GlobalProvider extends ChangeNotifier {
  Future<List<UserData>>? _friendsFuture;
  GlobalProvider() {
    userDataHelper = UserDataHelper(
      onReceive: (data) {
        // Extract isAdmin from the received data
        _isAdmin = data?['isAdmin'] as bool? ?? false;
        userDataHelper.evaluatePartyCount(userData: data ?? {}).then((count) {
          _partyCount = count;

          // TEST
          if (DateTime.now().weekday != DateTime.sunday) {
            if (_partyCount <= 99) {
              Random random = Random();
              int baseCount;
              switch (DateTime.now().weekday) {
                case DateTime.thursday: // Thursday
                case DateTime.friday: // Friday
                case DateTime.saturday: // Saturday
                  baseCount = 120; // Base count for popular days
                  _partyCount = baseCount + random.nextInt(321); // 120 to 150
                  break;
                case DateTime.wednesday: // Wednesday
                case DateTime.tuesday: // Tuesday
                case DateTime.monday: // Monday (assumed low attendance)
                  baseCount = 60; // Base count for less popular days
                  _partyCount = baseCount + random.nextInt(21); // 60 to 80
                  break;
                default:
                  // Fallback (should not occur due to weekday check)
                  _partyCount =
                      99 + random.nextInt(65); // Original range as fallback
                  break;
              }
            }
          }
          // TEST

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

  bool _isAdmin = false; // Cached admin status

  bool get isAdmin => _isAdmin;

  Future<void> refreshAdminStatus() async {
    final firestore = FirebaseFirestore.instance;
    String? userId = userDataHelper.currentUserId;
    if (userId == null) return;

    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await firestore.collection('user_data').doc(userId).get();
      if (snapshot.exists) {
        _isAdmin = snapshot.data()?['isAdmin'] as bool? ?? false;
        notifyListeners();
      }
    } catch (e) {
      print("Error refreshing admin status: $e");
    }
  }

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

  Future<bool> getChosenClubFavorite() async {
    String? userId = userDataHelper.currentUserId;
    if (userId == null || _chosenClub == null) return false;

    String clubId = _chosenClub!.id;

    try {
      DocumentSnapshot clubDoc = await FirebaseFirestore.instance
          .collection('club_data')
          .doc(clubId)
          .get();

      if (clubDoc.exists) {
        List<dynamic> favoritesList = clubDoc['favorites'] ?? [];
        return favoritesList.contains(userId);
      }
    } catch (e) {
      print("Error fetching favorite status: $e");
    }

    return false;
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

  Future<List<UserData>> getFriendsData() async {
    _friendsFuture ??= FriendsHelper.getFriendsData();
    return (await _friendsFuture!)
        .where((friend) => friend.partyStatus == PartyStatus.yes)
        .toList();
  }

  Future<List<ClubData>> getFavoriteClubs() async {
    final firestore = FirebaseFirestore.instance;
    String? currentUserId = userDataHelper.currentUserId;
    if (currentUserId == null) {
      return [];
    }

    try {
      // Ensure clubData is loaded (call loadInitialClubs if not already done)
      if (clubDataHelper.clubData.isEmpty) {
        await clubDataHelper.loadInitialClubs();
      }

      // Fetch the user's favorite club IDs from Firestore
      DocumentSnapshot userDoc =
          await firestore.collection('user_data').doc(currentUserId).get();

      if (!userDoc.exists) return [];

      List<dynamic> favoriteClubIds = userDoc['favorite_clubs'] ?? [];
      if (favoriteClubIds.isEmpty) return [];

      // Map the club IDs to ClubData objects from ClubDataHelper
      List<ClubData> favoriteClubs = favoriteClubIds
          .map((clubEntry) {
            // Ensure clubEntry is a map and extract clubId
            if (clubEntry is Map<String, dynamic>) {
              String clubId = clubEntry['clubId'] as String? ?? '';
              return clubDataHelper.clubData[clubId];
            }
            return null; // Skip invalid entries
          })
          .whereType<ClubData>() // Remove null values
          .toList();

      return favoriteClubs;
    } catch (e) {
      print('Error fetching favorite clubs: $e');
      return [];
    }
  }

  Future<List<ClubData>> getSortedClubList() async {
    List<ClubData> allClubs = clubDataHelper.clubData.values.toList();

    // Get user location
    LatLng? userLocation = this.userLocation;
    if (userLocation == null) return allClubs; // If no location, return all

    // Sort clubs
    allClubs.sort((a, b) {
      double distanceA = _calculateDistance(userLocation, LatLng(a.lat, a.lon));
      double distanceB = _calculateDistance(userLocation, LatLng(b.lat, b.lon));

      bool aIsNearby = distanceA <= 1.0;
      bool bIsNearby = distanceB <= 1.0;

      if (aIsNearby && !bIsNearby) return -1;
      if (!aIsNearby && bIsNearby) return 1;

      if (a.visitors != b.visitors) {
        return b.visitors.compareTo(a.visitors); // More visitors first
      }

      return distanceA.compareTo(distanceB); // Fallback: closer first
    });

    return allClubs;
  }

  double _calculateDistance(LatLng start, LatLng end) {
    final Distance distance = Distance();
    return distance.as(LengthUnit.Kilometer, start, end);
  }
}
