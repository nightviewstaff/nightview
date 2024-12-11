import 'package:cloud_firestore/cloud_firestore.dart';

class AddClub {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // TODO Once every type is made in the DB this could work. Smarter to make DB structure
  // List<String> clubTypes = ['Bar', 'Cafe', 'Restaurant']; // Example types
  // for (String type in clubTypes) {
  // await firestore.collection('club_types').add({'name': type});
  // }


  // Hardcoded list of allowed club types
  final List<String> allowedTypes = ['bar', 'club', 'bar_club', 'bodega', 'cocktail_bar', 'jazz_bar', 'pub',
    'sports_bar', 'wine_bar', 'karaoke_bar', 'beer_bar', 'gay_bar', 'live_music'];

  Future<bool> isValidType(String type) async {
    // Validate against the hardcoded list
    return allowedTypes.contains(type);
  }

  /// Adds a new club to the Firestore database with a custom document ID.
  Future<void> addClubToDatabaseTemplate({
    required String name, // Club name used as the document ID
    int ageRestriction = 10,
    required String typeOfClub,

    String logo = "default_logo.png",
    String mainOfferImg ="" ,

    required double lat,
    required double lon,
    required List<GeoPoint> corners,

    String offerType = "OfferType.none", // Added offer type
    String ageOfVisitors = '20',
    List<dynamic> favorites = const [],

    int firstTimeVisitors = 0,
    String peakHours = '23:00 - 01:00',
    int rating = 3,
    int regularVisitors = 0,
    int returningVisitors = 0,
    int totalPossibleAmountOfVisitors = 100, // Capacity. Needs renaming
    int visitors = 0, // Include visitors field
    Map<String, dynamic>? openingHours,
  }) async {
    try { // Prepare the club data to match your Firestore structure

      if (!await isValidType(typeOfClub)) {
        throw Exception('Invalid type_of_club value: $typeOfClub');
      }
      // TODO If there already is a club in the DB then put _1 instead of _0 everywhere

      Map<String, dynamic> clubData = {
        'name': name, // Include the name in the Firestore document
        'age_restriction': ageRestriction,
        'type_of_club': typeOfClub,
        'logo': logo,
        // "${name.toLowerCase().replaceAll(' ', '_')}_0_logo.jpg", // Use name for consistency
        'main_offer_img': mainOfferImg.isNotEmpty
            ? mainOfferImg
            : "${name.toLowerCase().replaceAll(' ', '_')}_0_offer.png",
        'lat': lat,
        'lon': lon,
        'corners': corners,
        'offer_type': offerType, // Added offer type
        'age_of_visitors': ageOfVisitors,
        'favorites': favorites,
        'first_time_visitors': firstTimeVisitors,
        'peak_hours': peakHours,
        'rating': rating,
        'regular_visitors': regularVisitors,
        'returning_visitors': returningVisitors,
        'total_possible_amount_of_visitors': totalPossibleAmountOfVisitors,
        'visitors': visitors,
        'opening_hours': openingHours,
      };

      // Generate a document ID based on the name
      String documentId = "${name.toLowerCase().replaceAll(' ', '_')}_0";

      // Add the club to the Firestore 'club_data' collection with the custom document ID
      DocumentReference clubRef =
      firestore.collection('club_data').doc(documentId);

      // Set the club data
      await clubRef.set(clubData);

      // Create a default 'ratings' subcollection for the new club
      await clubRef.collection('ratings').add({
        'club_id': clubRef.id,
        'rating': 3,
        'timestamp': FieldValue.serverTimestamp(),
        'user_id': 'Edj2ex3selWyLnUV8qvDanrNH2L2', // My ID
      });

      print("Club added successfully with ID: $documentId");
    } catch (e) {
      print("Failed to add club: $e");
    }
  }



  /// Example method for adding a specific club.
  void addSpecificClub() {
    addClubToDatabaseTemplate(
      name: "Ørsted Ølbar",
      ageRestriction: 18,
      typeOfClub: "Bar",
      logo: "", // Generated
      mainOfferImg: "", // Gets generated
      lat: 55.68126144704113,
      lon: 12.56447606464483,
      corners: [
        GeoPoint(55.681194909339546, 12.56451629777563),
        GeoPoint(55.68135860700611, 12.564626938898236),
        GeoPoint(55.68140737592466, 12.564432478724587),
        GeoPoint(55.68126863008427, 12.564309767675656),
      ],
      offerType: "OfferType.none", // Example offer type
      openingHours: {
        "monday": {"open": "17:00", "close": "00:00"},
        "tuesday": {"open": "17:00", "close": "00:00"},
        "wednesday": {"open": "17:00", "close": "00:00"},
        "thursday": {"open": "17:00", "close": "00:00"},
        "friday": {"open": "17:00", "close": "02:00"},
        "saturday": {"open": "17:00", "close": "01:00"},
        "sunday": null, // Closed
      },
      favorites: [],
      firstTimeVisitors: 0,
      peakHours: "17:00 - 02:00",
      rating: 3,
      regularVisitors: 0,
      returningVisitors: 0,
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub1() {
    addClubToDatabaseTemplate(
      name: "La Bonita",
      ageRestriction: 18, // 18+ age restriction
      logo: "la_bonita_0_logo.png", // Specify like this if there is one.
      typeOfClub: "club", // Valid type from allowedTypes
      lat: 55.67507623620078, // Latitude
      lon: 12.572241503981857, // Longitude
      corners: [
        GeoPoint(55.67505430554872, 12.572130192313674),
        GeoPoint(55.6749998569801, 12.5721610377157),
        GeoPoint(55.675078504888226, 12.572332028531282),
        GeoPoint(55.67514051562739, 12.572218034654227),
        GeoPoint(55.67509211701012, 12.572104711329391),
      ], // Geographical corners of the location
      openingHours: {
        "friday": {"open": "23:00", "close": "05:00"},
        "saturday": {"open": "23:00", "close": "05:00"},
      }, // Opening hours for Friday and Saturday
      peakHours: "23:00 - 03:00", // Based on opening hours
      rating: 3, // Default rating
      totalPossibleAmountOfVisitors: 100, // Capacity
    );
  }



}


// TODO Under

// TODO Billeder bar i DB

// Man skal have notifikationer alle dage undtagen mandag og søndag. +
// 1 total notifikation hvis dine venner tager i byen og informationer om hvem der kommer.




class FirestoreService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> setData(
      String collection, String documentId, Map<String, dynamic> data) async {
    await firestore.collection(collection).doc(documentId).set(data);
  }

  Future<void> addSubcollection(
      String collection, String documentId, String subcollection, Map<String, dynamic> data) async {
    await firestore
        .collection(collection)
        .doc(documentId)
        .collection(subcollection)
        .add(data);
  }
}
