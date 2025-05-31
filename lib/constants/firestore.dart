import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestorePaths {
  // Firestore Collections
  static const String chats = 'chats';
  static const String clubData = 'club_data';
  static const String clubdataBackup = 'club_data_backup';
  static const String clubDataNew = 'club_data_new';
  static const String clubTags = 'club_tags';
  static const String clubVisits = 'club_visits';
  static const String favorites = 'favorites';
  static const String friendRequests = 'friend_requests';
  static const String friends = 'friends';
  static const String locationData = 'location_data';
  static const String mainOfferRedemption = 'main_offer_redemptions';
  static const String moodImages = 'mood_images';
  static const String notifications = 'notifications';
  static const String referralPoints = 'referral_points';
  static const String shareCodes = 'share_codes';
  static const String userData = 'user_data';
  static const String values = 'values';

  // Firestore Collection References
  static final clubDataNewRef =
      FirebaseFirestore.instance.collection(clubDataNew);
  static final clubTagsRef = FirebaseFirestore.instance.collection(clubTags);
  static final clubVisitsRef =
      FirebaseFirestore.instance.collection(clubVisits);
  static final favoritesRef = FirebaseFirestore.instance.collection(favorites);
  static final friendRequestsRef =
      FirebaseFirestore.instance.collection(friendRequests);
  static final friendsRef = FirebaseFirestore.instance.collection(friends);
  static final locationDataRef =
      FirebaseFirestore.instance.collection(locationData);
  static final mainOfferRedemptionRef =
      FirebaseFirestore.instance.collection(mainOfferRedemption);
  static final moodImagesRef =
      FirebaseFirestore.instance.collection(moodImages);
  static final notificationsRef =
      FirebaseFirestore.instance.collection(notifications);
  static final referralPointsRef =
      FirebaseFirestore.instance.collection(referralPoints);
  static final shareCodesRef =
      FirebaseFirestore.instance.collection(shareCodes);
  static final userDataRef = FirebaseFirestore.instance.collection(userData);
  static final valuesRef = FirebaseFirestore.instance.collection(values);
}

class StoragePaths {
  // Firebase Storage Folders
  static const String clubImages = 'club_images/';
  static const String clubLogos = 'club_logos/';
  static const String dailyOffers = 'daily_offers/';
  static const String flags = 'flags/';
  static const String mainOffers = 'main_offers/';
  static const String nightviewImages = 'nightview_images/';
  static const String pb = 'pb/';
  static const String userImages = 'user_images/';

  // Storage References
  static final clubImagesRef = FirebaseStorage.instance.ref(clubImages);
  static final clubLogosRef = FirebaseStorage.instance.ref(clubLogos);
  static final dailyOffersRef = FirebaseStorage.instance.ref(dailyOffers);
  static final flagsRef = FirebaseStorage.instance.ref(flags);
  static final mainOffersRef = FirebaseStorage.instance.ref(mainOffers);
  static final nightviewImagesRef =
      FirebaseStorage.instance.ref(nightviewImages);
  static final pbRef = FirebaseStorage.instance.ref(pb);
  static final userImagesRef = FirebaseStorage.instance.ref(userImages);
}
