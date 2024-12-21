import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class AddClub {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // TODO Once every type is made in the DB this could work. Smarter to make DB structure
  // List<String> clubTypes = ['Bar', 'Cafe', 'Restaurant']; // Example types
  // for (String type in clubTypes) {
  // await firestore.collection('club_types').add({'name': type});
  // }

  // Hardcoded list of allowed club types
  final List<String> allowedTypes = [
    'bar',
    'club',
    'bar_club',
    'bodega',
    'cocktail_bar',
    'jazz_bar',
    'pub',
    'sports_bar',
    'wine_bar',
    'karaoke_bar',
    'beer_bar',
    'gay_bar',
    'live_music_bar'
  ];

  Future<bool> isValidType(String type) async {
    // Validate against the hardcoded list
    return allowedTypes.contains(type);
  }

  /// Adds a new club to the Firestore database with a custom document ID.
  Future<void> addClubToDatabaseTemplate({
    //Default values
    int ageRestriction = 10,
    String logo = "default_logo.png",
    String mainOfferImg = "",
    String offerType = "OfferType.none",
    String ageOfVisitors = '20',
    String peakHours = '23:00 - 01:00',
    int rating = 3,
    int totalPossibleAmountOfVisitors = 100, // Capacity. Needs renaming
    int visitors = 0,
    int firstTimeVisitors = 0,
    int regularVisitors = 0,
    int returningVisitors = 0,
    List<dynamic> favorites = const [],

    //Specific values
    required String name, // Club name used as the document ID
    required String typeOfClub,
    required double lat,
    required double lon,
    required List<GeoPoint> corners,
    Map<String, dynamic>? openingHours,
  }) async {
    try {
      // Prepare the club data to match your Firestore structure

      if (!await isValidType(typeOfClub)) {
        throw Exception('Invalid type_of_club value: $typeOfClub');
      }

      Map<String, dynamic> clubData = {
        'name': name,
        // Include the name in the Firestore document
        'age_restriction': ageRestriction,
        'type_of_club': typeOfClub,
        'logo': logo,
        'main_offer_img': mainOfferImg.isNotEmpty
            ? mainOfferImg
            : "${name.toLowerCase().replaceAll(' ', '_')}_0_offer.png",
        'lat': lat,
        'lon': lon,
        'corners': corners,
        'offer_type': offerType,
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
      String baseId = name.toLowerCase().replaceAll(' ', '_');
      int increment = 0;
      String documentId = "${baseId}_${increment}";

      // Check if the document ID already exists
      bool exists = true;
      while (exists) {
        final docSnapshot = await _firestore.collection('club_data').doc(documentId).get();
        print('DOC!! $docSnapshot');
        if (docSnapshot.exists) {
          // Increment the counter and update the document ID
          increment++;
          documentId = "${baseId}_$increment";
          mainOfferImg = "${name.toLowerCase().replaceAll(' ', '_')}_offer_$increment";
        } else {
          exists = false; // No conflict, documentId is available
        }
      }

      // Add the club to the Firestore 'club_data' collection with the custom document ID
      DocumentReference clubRef =
          _firestore.collection('club_data').doc(documentId);

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
  void addSpecificClub1() { //TODO Happy hour some places!
    addClubToDatabaseTemplate(
      name: "RUST",
      typeOfClub: "bar",
      logo: "rust_conga_0_logo.png",
      lat: 55.69123315161955,
      lon: 12.559292337495881,
      corners: [
        GeoPoint(55.69121803328024, 12.559174990857736),
        GeoPoint(55.69116322925132, 12.559301725226932),
        GeoPoint(55.691254317284724, 12.559436506222744),
        GeoPoint(55.691311388931986, 12.559307760196894),
      ],
      openingHours: {
        "monday": null,
        "tuesday": null,
        "wednesday": {"open": "19:00", "close": "01:00"},
        "thursday": {"open": "19:00", "close": "01:00"},
        "friday": {"open": "19:00", "close": "04:00"},
        "saturday": {"open": "19:00", "close": "04:00"},
        "sunday": null,
      },
      ageRestriction: 18,
      totalPossibleAmountOfVisitors: 100,
    );
  }
// Be aware of shit like this.
//"thursday": {"open": "23:59", "close": "00:00"},

  void addSpecificClub22() {
    addClubToDatabaseTemplate(
      name: "baggen",
      typeOfClub: "bar_club",
      logo: "baggen_0_logo.png",
      lat: 55.668686676964924,
      lon: 12.559789440977704,
      corners: [
        GeoPoint(55.6686922215259, 12.559636420827353),
        GeoPoint(55.668770897792236, 12.559814218325652),
        GeoPoint(55.66861179797812, 12.559747196190367),
        GeoPoint(55.66868327337771, 12.559930927487674),
      ],
      openingHours: {
        "monday": null,
        "tuesday": null,
        "wednesday": null,
        "thursday": {"ageRestriction": 18, "open": "22:00", "close": "04:00"},
        "friday": {"open": "23:00", "close": "05:00"},
        "saturday": {"open": "23:00", "close": "05:00"},
        "sunday": null,
      },
      ageRestriction: 21,
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub46() {//LUKKET?!?
    addClubToDatabaseTemplate(
      name: "gespenst",
      typeOfClub: "bar",
      logo: "NOT PRESENT!", // HELP. No logo provided
      lat: 55.6795523841334,
      lon: 12.58349003600709,
      corners: [
        GeoPoint(55.679548855224255, 12.583525195172442),
        GeoPoint(55.67951556760504, 12.58338028047501),
        GeoPoint(55.67963704566551, 12.583444687001046),
        GeoPoint(55.679614565768645, 12.583313573703371),
      ],
      openingHours: {
        "monday": null,
        "tuesday": null,
        "wednesday": {"open": "19:00", "close": "01:00"},
        "thursday": {"open": "19:00", "close": "01:00"},
        "friday": {"open": "19:00", "close": "02:00"},
        "saturday": {"open": "19:00", "close": "02:00"},
        "sunday": null,
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub69() {
    addClubToDatabaseTemplate(
      name: "Bar7",
      typeOfClub: "cocktail_bar",
      logo: "bar7_0_logo.png",
      lat: 55.67893017330696,
      lon: 12.570663577576454,
      corners: [
        GeoPoint(55.6789279048429, 12.570518738305584),
        GeoPoint(55.6789891533267, 12.570704481259432),
        GeoPoint(55.678899927108475, 12.570784947521023),
        GeoPoint(55.67885569200112, 12.57058378186704),
      ],
      openingHours: {
        "monday": null,
        "tuesday": null,
        "wednesday": {"open": "19:00", "close": "00:00"},
        "thursday": {"open": "19:00", "close": "01:00"},
        "friday": {"ageRestriction": 23, "open": "18:00", "close": "04:00"},
        "saturday": {"ageRestriction": 23, "open": "18:00", "close": "04:00"},
        "sunday": null,
      },
      ageRestriction: 21,
      totalPossibleAmountOfVisitors: 100,
    );
  }



  void addSpecificClub76() {
    addClubToDatabaseTemplate(
      name: "ramblin' bar",
      typeOfClub: "beer_bar",
      logo: "ramblin'_bar_0_logo.png",
      lat: 55.663188081053185,
      lon: 12.542086379486976,
      corners: [
        GeoPoint(55.66316122675101, 12.542000548807941),
        GeoPoint(55.663176734167195, 12.542276816306082),
        GeoPoint(55.663288311736665, 12.542046816908357),
      ],
      openingHours: {
        "monday": null,
        "tuesday": null,
        "wednesday": {"open": "14:00", "close": "00:00"},
        "thursday": {"open": "14:00", "close": "00:00"},
        "friday": {"open": "14:00", "close": "02:00"},
        "saturday": {"open": "14:00", "close": "02:00"},
        "sunday": null,
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub79() {
    addClubToDatabaseTemplate(
      name: "hviids vinstue",
      typeOfClub: "vinbar",
      logo: "hviids_vinstue_0_logo.png",
      lat: 55.67979634590497,
      lon: 12.584832608403351,
      corners: [
        GeoPoint(55.67977593017568, 12.584864124355807),
        GeoPoint(55.67974492849228, 12.584689780789022),
        GeoPoint(55.679893509507664, 12.584663629254003),
        GeoPoint(55.67990371734296, 12.58484668999913),
      ],
      openingHours: {
        "monday": {"open": "10:00", "close": "01:00"},
        "tuesday": {"open": "10:00", "close": "01:00"},
        "wednesday": {"open": "10:00", "close": "01:00"},
        "thursday": {"open": "10:00", "close": "01:00"},
        "friday": {"open": "10:00", "close": "02:00"},
        "saturday": {"open": "10:00", "close": "02:00"},
        "sunday": {"open": "10:00", "close": "20:00"},
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub82() {
    addClubToDatabaseTemplate(
      name: "tap 21 craft beer",
      typeOfClub: "øl_bar",
      logo: "tap_21_craft_beer_0_logo.png",
      lat: 55.678303684265636,
      lon: 12.547009513615478,
      corners: [
        GeoPoint(55.67827721841935, 12.54699342036316),
        GeoPoint(55.678328259678246, 12.546730563908618),
        GeoPoint(55.67840387623668, 12.546803654102211),
        GeoPoint(55.67834905424709, 12.547070533869832),
      ],
      openingHours: {
        "monday": null,
        "tuesday": {"open": "16:00", "close": "23:00"},
        "wednesday": {"open": "16:00", "close": "23:00"},
        "thursday": {"open": "16:00", "close": "00:00"},
        "friday": {"open": "15:00", "close": "01:00"},
        "saturday": {"open": "15:00", "close": "01:00"},
        "sunday": null,
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }



  void addSpecificClub84() {
    addClubToDatabaseTemplate(
      name: "trows",
      typeOfClub: "øl_bar",
      logo: "trows_0_logo.png",
      lat: 55.67063521498686,
      lon: 12.542275004102391,
      corners: [
        GeoPoint(55.67063786208932, 12.542236112075953),
        GeoPoint(55.67066508941853, 12.542359493677063),
        GeoPoint(55.67057281894842, 12.542421855029799),
        GeoPoint(55.67054332260468, 12.54229713232433),
      ],
      openingHours: {
        "monday": null,
        "tuesday": {"open": "16:00", "close": "23:00"},
        "wednesday": {"open": "16:00", "close": "23:00"},
        "thursday": {"open": "16:00", "close": "23:00"},
        "friday": {"open": "15:00", "close": "00:00"},
        "saturday": {"open": "15:00", "close": "00:00"},
        "sunday": null,
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }



  void addSpecificClub92() {
    addClubToDatabaseTemplate(
      name: "tørst bar",
      typeOfClub: "bar_klub",
      logo: "tørst_bar_0_logo.png",
      lat: 55.67754665326874,
      lon: 12.570073587666023,
      corners: [
        GeoPoint(55.67753304200092, 12.570011896865468),
        GeoPoint(55.67759882975157, 12.57013661957094),
        GeoPoint(55.67750997845296, 12.570292858228868),
        GeoPoint(55.67746498559074, 12.570114491349003),
      ],
      openingHours: {
        "monday": null,
        "tuesday": null,
        "wednesday": null,
        "thursday": null,
        "friday": {"open": "20:00", "close": "05:00"},
        "saturday": {"open": "20:00", "close": "05:00"},
        "sunday": null,
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }


// GODKENDT OVER

  void addSpecificClub100() {
    addClubToDatabaseTemplate(
      name: "london pub",
      typeOfClub: "pub",
      logo: "london_pub_0_logo.png",
      lat: 55.68550609993533,
      lon: 12.538232301171563,
      corners: [
        GeoPoint(55.68551489566689, 12.53817631537193),
        GeoPoint(55.68566287061874, 12.538298382771126),
        GeoPoint(55.68563596612367, 12.538405765370419),
        GeoPoint(55.68548954325879, 12.538293793771157),
      ],
      openingHours: {
        "monday": {"open": "11:00", "close": "00:00"},
        "tuesday": {"open": "11:00", "close": "00:00"},
        "wednesday": {"open": "11:00", "close": "00:00"},
        "thursday": {"open": "11:00", "close": "00:00"},
        "friday": {"open": "11:00", "close": "01:00"},
        "saturday": {"open": "11:00", "close": "01:00"},
        "sunday": {"open": "12:00", "close": "23:00"},
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub101() {
    addClubToDatabaseTemplate(
      name: "bo-bi bar",
      typeOfClub: "bar",
      logo: "bo_bi_bar_0_logo.png",
      lat: 55.68110444739103,
      lon: 12.5786891814146,
      corners: [
        GeoPoint(55.68108214206189, 12.578605362392107),
        GeoPoint(55.68101476374961, 12.578736568052278),
        GeoPoint(55.681083795431974, 12.578792406151655),
        GeoPoint(55.681137655231424, 12.578690148427496),
      ],
      openingHours: {
        "monday": {"open": "12:00", "close": "02:00"},
        "tuesday": {"open": "12:00", "close": "02:00"},
        "wednesday": {"open": "12:00", "close": "02:00"},
        "thursday": {"open": "12:00", "close": "02:00"},
        "friday": {"open": "12:00", "close": "02:00"},
        "saturday": {"open": "12:00", "close": "00:00"},
        "sunday": {"open": "14:00", "close": "02:00"},
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub102() {
    addClubToDatabaseTemplate(
      name: "charlie scotts bar",
      typeOfClub: "live_music",
      logo: "charlie_scotts_bar_0_logo.png",
      lat: 55.67876777113347,
      lon: 12.573340367490719,
      corners: [
        GeoPoint(55.678781101708964, 12.573355638666493),
        GeoPoint(55.67864790284647, 12.573561281494678),
        GeoPoint(55.67858066078836, 12.573409298456484),
        GeoPoint(55.678706245761894, 12.573147417320145),
      ],
      openingHours: {
        "monday": {"open": "14:00", "close": "00:00"},
        "tuesday": {"open": "14:00", "close": "00:00"},
        "wednesday": {"open": "14:00", "close": "00:00"},
        "thursday": {"open": "14:00", "close": "00:00"},
        "friday": {"open": "14:00", "close": "03:00"},
        "saturday": {"open": "12:00", "close": "02:00"},
        "sunday": {"open": "13:00", "close": "00:00"},
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub103() {
    addClubToDatabaseTemplate(
      name: "the social pub",
      typeOfClub: "pub",
      logo: "the_social_pub_0_logo.png",
      lat: 55.678108591120896,
      lon: 12.580401829706522,
      corners: [
        GeoPoint(55.67812900772046, 12.58029185914901),
        GeoPoint(55.67815396132766, 12.580523870203274),
        GeoPoint(55.67806322086148, 12.58055538615573),
        GeoPoint(55.678040157626086, 12.58031868123621),
      ],
      openingHours: {
        "monday": {"open": "18:00", "close": "01:00"},
        "tuesday": {"open": "18:00", "close": "02:00"},
        "wednesday": {"open": "18:00", "close": "02:00"},
        "thursday": {"open": "18:00", "close": "02:00"},
        "friday": {"open": "15:00", "close": "03:00"},
        "saturday": {"open": "15:00", "close": "03:00"},
        "sunday": null,
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }
  void addSpecificClub104() {
    addClubToDatabaseTemplate(
      name: "the australian bar",
      typeOfClub: "bar_club",
      logo: "the_australian_bar_0_logo.png",
      lat: 55.677949057656335,
      lon: 12.57051385296162,
      corners: [
        GeoPoint(55.678272843740814, 12.57021798381043),
        GeoPoint(55.67825772039037, 12.570137517548835),
        GeoPoint(55.677847497274286, 12.57048486359583),
        GeoPoint(55.677909125537056, 12.570639090597219),
        GeoPoint(55.67811745103431, 12.57049492187794),
      ],
      openingHours: {
        "monday": null,
        "tuesday": null,
        "wednesday": {"open": "18:00", "close": "02:00"},
        "thursday": {"open": "18:00", "close": "02:00"},
        "friday": {"open": "18:00", "close": "04:00"},
        "saturday": {"open": "18:00", "close": "04:00"},
        "sunday": null,
      },
      ageRestriction: 18,
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub105() {
    addClubToDatabaseTemplate(
      name: "heidi's bier bar",
      typeOfClub: "bar_club",
      logo: "heidis_bier_bar_0_logo.png",
      lat: 55.67747198129463,
      lon: 12.569611145687439,
      corners: [
        GeoPoint(55.677370041244494, 12.569536503843167),
        GeoPoint(55.67747628506863, 12.569686036979297),
        GeoPoint(55.67746470786737, 12.569435423948413),
        GeoPoint(55.677655889580976, 12.569433405704746),
        GeoPoint(55.677674476641954, 12.569491934796861),
      ],
      openingHours: {
        "monday": {"open": "16:00", "close": "02:00"},
        "tuesday": {"open": "16:00", "close": "02:00"},
        "wednesday": {"open": "16:00", "close": "02:00"},
        "thursday": {"open": "16:00", "close": "05:00"},
        "friday": {"open": "14:00", "close": "05:00"},
        "saturday": {"open": "16:00", "close": "05:00"},
        "sunday": null,
      },
      ageRestriction: 20,
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub106() {
    addClubToDatabaseTemplate(
      name: "den glade gris",
      typeOfClub: "bar_club",
      logo: "den_glade_gris_0_logo.png",
      lat: 55.68009445642439,
      lon: 12.574580563714003,
      corners: [
        GeoPoint(55.68012176631851, 12.574560381268444),
        GeoPoint(55.68002406686476, 12.574695880434072),
        GeoPoint(55.67995012338665, 12.574501157525685),
        GeoPoint(55.680040018714614, 12.574352480176744),
      ],
      openingHours: {
        "monday": null,
        "tuesday": null,
        "wednesday": {"open": "18:00", "close": "02:00"},
        "thursday": {"open": "16:00", "close": "02:00"},
        "friday": {"ageRestriction": 20, "open": "15:00", "close": "05:00"},
        "saturday": {"ageRestriction": 20, "open": "15:00", "close": "05:00"},
        "sunday": null,
      },
      ageRestriction: 18,
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub107() {
    addClubToDatabaseTemplate(
      name: "black swan",
      typeOfClub: "bar",
      logo: "black_swan_0_logo.png",
      lat: 55.686551248027975,
      lon: 12.587407197399326,
      corners: [
        GeoPoint(55.686572281036284, 12.587399314658231),
        GeoPoint(55.68653945229111, 12.587525266752042),
        GeoPoint(55.686471122605155, 12.58746973948488),
        GeoPoint(55.68651654849906, 12.58730857497775),
      ],
      openingHours: {
        "monday": {"open": "15:00", "close": "01:00"},
        "tuesday": {"open": "15:00", "close": "01:00"},
        "wednesday": {"open": "15:00", "close": "01:00"},
        "thursday": {"open": "15:00", "close": "02:00"},
        "friday": {"open": "14:00", "close": "02:00"},
        "saturday": {"open": "14:00", "close": "02:00"},
        "sunday": {"open": "15:00", "close": "01:00"},
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub108() {
    addClubToDatabaseTemplate(
      name: "warpigs brewpub",
      typeOfClub: "pub",
      logo: "warpigs_brewpub_0_logo.png",
      lat: 55.66849897382377,
      lon: 12.5599271675171,
      corners: [
        GeoPoint(55.66851863908281, 12.559873523342706),
        GeoPoint(55.66831215337015, 12.560175271823685),
        GeoPoint(55.66840594188753, 12.560341568764311),
        GeoPoint(55.66860410720914, 12.56005054911821),
      ],
      openingHours: {
        "monday": {"open": "12:00", "close": "00:00"},
        "tuesday": {"open": "12:00", "close": "00:00"},
        "wednesday": {"open": "12:00", "close": "00:00"},
        "thursday": {"open": "12:00", "close": "00:00"},
        "friday": {"open": "12:00", "close": "02:00"},
        "saturday": {"open": "11:30", "close": "02:00"},
        "sunday": {"open": "11:30", "close": "23:00"},
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub109() {
    addClubToDatabaseTemplate(
      name: "kongens bar",
      typeOfClub: "pub",
      logo: "kongens_bar_0_logo.png",
      lat: 55.68114371207389,
      lon: 12.58411241385401,
      corners: [
        GeoPoint(55.6811561879179, 12.584099673362589),
        GeoPoint(55.68110136978579, 12.584286757420797),
        GeoPoint(55.68101025809972, 12.584198244533042),
        GeoPoint(55.68106016162212, 12.584035970905493),
      ],
      openingHours: {
        "monday": null,
        "tuesday": {"open": "15:00", "close": "01:00"},
        "wednesday": {"open": "15:00", "close": "01:00"},
        "thursday": {"open": "15:00", "close": "01:00"},
        "friday": {"open": "15:00", "close": "02:00"},
        "saturday": {"open": "15:00", "close": "02:00"},
        "sunday": null,
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub110() {
    addClubToDatabaseTemplate(
      name: "amager pub",
      typeOfClub: "pub",
      logo: "amager_pub_0_logo.png",
      lat: 55.66563497233016,
      lon: 12.59960283170284,
      corners: [
        GeoPoint(55.66557937603339, 12.599555893050244),
        GeoPoint(55.66563232488924, 12.599749012078071),
        GeoPoint(55.66566825442918, 12.599454639671071),
        GeoPoint(55.66571893393473, 12.599671898577375),
      ],
      openingHours: {
        "monday": {"open": "10:00", "close": "03:00"},
        "tuesday": {"open": "10:00", "close": "03:00"},
        "wednesday": {"open": "10:00", "close": "03:00"},
        "thursday": {"open": "10:00", "close": "03:00"},
        "friday": {"open": "10:00", "close": "03:00"},
        "saturday": {"open": "10:00", "close": "03:00"},
        "sunday": {"open": "10:00", "close": "02:00"},
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub111() {
    addClubToDatabaseTemplate(
      name: "brewpub",
      typeOfClub: "beer_bar",
      logo: "brewpub_0_logo.png",
      lat: 55.677167686021306,
      lon: 12.56946733432529,
      corners: [
        GeoPoint(55.677148781298236, 12.56937949198972),
        GeoPoint(55.677232340105185, 12.569522990156226),
        GeoPoint(55.67716655173819, 12.56964503065298),
        GeoPoint(55.67708110231471, 12.569504885247369),
      ],
      openingHours: {
        "monday": {"open": "12:00", "close": "00:00"},
        "tuesday": {"open": "12:00", "close": "00:00"},
        "wednesday": {"open": "12:00", "close": "00:00"},
        "thursday": {"open": "12:00", "close": "00:00"},
        "friday": {"open": "12:00", "close": "02:00"},
        "saturday": {"open": "12:00", "close": "02:00"},
        "sunday": null,
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub112() {
    addClubToDatabaseTemplate(
      name: "fermentoren",
      typeOfClub: "beer_bar",
      logo: "fermentoren_0_logo.png",
      lat: 55.66791220381257,
      lon: 12.556348767276075,
      corners: [
        GeoPoint(55.668013874381884, 12.55616849644973),
        GeoPoint(55.66808071842441, 12.556399561818305),
        GeoPoint(55.66783749543581, 12.556619671501302),
        GeoPoint(55.66778188534849, 12.556410517503885),
      ],
      openingHours: {
        "monday": {"open": "15:00", "close": "00:00"},
        "tuesday": {"open": "15:00", "close": "00:00"},
        "wednesday": {"open": "15:00", "close": "00:00"},
        "thursday": {"open": "14:00", "close": "01:00"},
        "friday": {"open": "14:00", "close": "02:00"},
        "saturday": {"open": "14:00", "close": "02:00"},
        "sunday": {"open": "14:00", "close": "00:00"},
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub113() {
    addClubToDatabaseTemplate(
      name: "lèanowski",
      typeOfClub: "bar",
      logo: "lèanowski_0_logo.png",
      lat: 55.68986216203991,
      lon: 12.560193203990174,
      corners: [
        GeoPoint(55.68976502320193, 12.560307868412945),
        GeoPoint(55.689902604986884, 12.56038095860056),
        GeoPoint(55.689944937746404, 12.560106032206779),
        GeoPoint(55.68983948373356, 12.560022883736465),
      ],
      openingHours: {
        "monday": {"open": "12:00", "close": "02:00"},
        "tuesday": {"open": "12:00", "close": "02:00"},
        "wednesday": {"open": "12:00", "close": "02:00"},
        "thursday": {"open": "12:00", "close": "04:00"},
        "friday": {"open": "12:00", "close": "05:00"},
        "saturday": {"open": "12:00", "close": "05:00"},
        "sunday": {"open": "12:00", "close": "02:00"},
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub114() {
    addClubToDatabaseTemplate(
      name: "generator pétanque & shuffleboard bar",
      typeOfClub: "bar",
      logo: "generator_petanque_shuffleboard_bar_0_logo.png",
      lat: 55.682863290045184,
      lon: 12.58255407005928,
      corners: [
        GeoPoint(55.682611717204736, 12.582372697548706),
        GeoPoint(55.682665720630084, 12.582158701446652),
        GeoPoint(55.68323447558253, 12.582653949572139),
        GeoPoint(55.683177025963005, 12.582880174022883),
      ],
      openingHours: {
        "monday": {"open": "07:00", "close": "23:00"},
        "tuesday": {"open": "07:00", "close": "23:00"},
        "wednesday": {"open": "07:00", "close": "23:00"},
        "thursday": {"open": "07:00", "close": "00:00"},
        "friday": {"open": "07:00", "close": "02:00"},
        "saturday": {"open": "07:00", "close": "02:00"},
        "sunday": {"open": "07:00", "close": "02:00"},
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }
// GOdkendt over

  void addSpecificClub115() {
    addClubToDatabaseTemplate(
      name: "temple bar",
      typeOfClub: "bar",
      logo: "temple_bar_0_logo.png",
      lat: 55.689559266076486,
      lon: 12.556588652755948,
      corners: [
        GeoPoint(55.68956531366947, 12.556428390784939),
        GeoPoint(55.68967974651318, 12.556603406329351),
        GeoPoint(55.68960807551952, 12.556793794065781),
        GeoPoint(55.689484452227035, 12.556646462213207),
      ],
      openingHours: {
        "monday": {"open": "14:00", "close": "02:00"},
        "tuesday": {"open": "14:00", "close": "02:00"},
        "wednesday": {"open": "14:00", "close": "02:00"},
        "thursday": {"open": "14:00", "close": "02:00"},
        "friday": {"open": "14:00", "close": "02:00"},
        "saturday": {"open": "14:00", "close": "02:00"},
        "sunday": {"open": "14:00", "close": "02:00"},
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }


  void addSpecificClub118() {
    addClubToDatabaseTemplate(
      name: "jernbanecafeen",
      typeOfClub: "bar",
      logo: "jernbanecafeen_0_logo.png",
      lat: 55.67221382212613,
      lon: 12.563637604253053,
      corners: [
        GeoPoint(55.67217487345496, 12.563709353336305),
        GeoPoint(55.67209319456235, 12.563445155777407),
        GeoPoint(55.67216126031806, 12.56337810054613),
        GeoPoint(55.67226373687133, 12.563624193196171),
      ],
      openingHours: {
        "monday": {"open": "07:00", "close": "02:00"},
        "tuesday": {"open": "07:00", "close": "02:00"},
        "wednesday": {"open": "07:00", "close": "02:00"},
        "thursday": {"open": "07:00", "close": "02:00"},
        "friday": {"open": "07:00", "close": "02:00"},
        "saturday": {"open": "07:00", "close": "02:00"},
        "sunday": {"open": "07:00", "close": "02:00"},
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub119() {
    addClubToDatabaseTemplate(
      name: "the barking dog",
      typeOfClub: "cocktail_bar",
      logo: "the_barking_dog_0_logo.png",
      lat: 55.69009075742492,
      lon: 12.562546599987675,
      corners: [
        GeoPoint(55.69007677255265, 12.562615666862209),
        GeoPoint(55.69013308998088, 12.562490944147223),
        GeoPoint(55.689993619154706, 12.562282402406575),
        GeoPoint(55.689962625570274, 12.56236353922035),
        GeoPoint(55.68999891073983, 12.562503684625959),
      ],
      openingHours: {
        "monday": null,
        "tuesday": {"open": "18:00", "close": "01:00"},
        "wednesday": {"open": "18:00", "close": "01:00"},
        "thursday": {"open": "18:00", "close": "01:00"},
        "friday": {"open": "18:00", "close": "02:00"},
        "saturday": {"open": "18:00", "close": "02:00"},
        "sunday": null,
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub120() {
    addClubToDatabaseTemplate(
      name: "wall street pub",
      typeOfClub: "pub",
      logo: "wall_street_pub_0_logo.png",
      lat: 55.68166308949545,
      lon: 12.584799647372991,
      corners: [
        GeoPoint(55.681563661977414, 12.585116148001928),
        GeoPoint(55.68168237008754, 12.584686324054578),
        GeoPoint(55.68190806572607, 12.584881454748764),
        GeoPoint(55.68167732386819, 12.58514640584574),
      ],
      openingHours: {
        "monday": {"open": "12:00", "close": "03:00"},
        "tuesday": {"open": "12:00", "close": "04:00"},
        "wednesday": {"open": "12:00", "close": "04:00"},
        "thursday": {"open": "12:00", "close": "05:00"},
        "friday": {"open": "12:00", "close": "06:00"},
        "saturday": {"open": "12:00", "close": "06:00"},
        "sunday": null,
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub121() {
    addClubToDatabaseTemplate(
      name: "city pub",
      typeOfClub: "pub",
      logo: "city_pub_0_logo.png",
      lat: 55.67302411013976,
      lon: 12.559793584820314,
      corners: [
        GeoPoint(55.67303625006681, 12.559698054578003),
        GeoPoint(55.67307039359143, 12.559827222229575),
        GeoPoint(55.67293457806143, 12.559902570026326),
        GeoPoint(55.67291788561739, 12.559780129856607),
      ],
      openingHours: {
        "monday": {"open": "15:00", "close": "00:00"},
        "tuesday": {"open": "15:00", "close": "00:00"},
        "wednesday": {"open": "15:00", "close": "00:00"},
        "thursday": {"open": "15:00", "close": "00:00"},
        "friday": {"open": "15:00", "close": "03:00"},
        "saturday": {"open": "15:00", "close": "03:00"},
        "sunday": {"open": "16:00", "close": "00:00"},
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub122() {
    addClubToDatabaseTemplate(
      name: "the old english pub",
      typeOfClub: "pub",
      logo: "the_old_english_pub_0_logo.png",
      lat: 55.67556756234588,
      lon: 12.566456221968258,
      corners: [
        GeoPoint(55.675516895595045, 12.5664481753421),
        GeoPoint(55.675584199175134, 12.566635929952486),
        GeoPoint(55.675770984909406, 12.56617995446628),
        GeoPoint(55.67569838813103, 12.5665138894519),
      ],
      openingHours: {
        "monday": {"open": "12:00", "close": "02:00"},
        "tuesday": {"open": "12:00", "close": "02:00"},
        "wednesday": {"open": "12:00", "close": "02:00"},
        "thursday": {"open": "12:00", "close": "02:00"},
        "friday": {"open": "12:00", "close": "05:00"},
        "saturday": {"open": "11:30", "close": "05:00"},
        "sunday": {"open": "11:30", "close": "02:00"},
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub123() {
    addClubToDatabaseTemplate(
      name: "the storm inn",
      typeOfClub: "pub",
      logo: "the_storm_inn_0_logo.png",
      lat: 55.67412116786289,
      lon: 12.57255262598527,
      corners: [
        GeoPoint(55.6740810867179, 12.572517757271912),
        GeoPoint(55.67412268035814, 12.572562013715787),
        GeoPoint(55.674127974090986, 12.572258924130448),
        GeoPoint(55.67419603630677, 12.572332684870245),
      ],
      openingHours: {
        "monday": null,
        "tuesday": {"open": "16:00", "close": "00:00"},
        "wednesday": {"open": "16:00", "close": "00:00"},
        "thursday": {"open": "16:00", "close": "01:00"},
        "friday": {"open": "12:00", "close": "01:30"},
        "saturday": {"open": "12:00", "close": "01:30"},
        "sunday": {"open": "12:00", "close": "20:30"},
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub124() {
    addClubToDatabaseTemplate(
      name: "the old irish pub",
      typeOfClub: "bar_club",
      logo: "the_old_irish_pub_ved_tivoli_0_logo.png",
      lat: 55.67551411471095,
      lon: 12.566261891210106,
      corners: [
        GeoPoint(55.67544552522207, 12.566235336129122),
        GeoPoint(55.675490792025776, 12.566476168346767),
        GeoPoint(55.675589979399966, 12.56609839232909),
        GeoPoint(55.67566187344615, 12.566289641442582),
      ],
      openingHours: {
        "monday": {"open": "12:00", "close": "06:00"},
        "tuesday": {"open": "12:00", "close": "06:00"},
        "wednesday": {"open": "12:00", "close": "06:00"},
        "thursday": {"open": "12:00", "close": "06:00"},
        "friday": {"open": "12:00", "close": "06:00"},
        "saturday": {"open": "12:00", "close": "06:00"},
        "sunday": {"open": "12:00", "close": "06:00"},
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub125() {
    addClubToDatabaseTemplate(
      name: "BRUS",
      typeOfClub: "beer_bar",
      logo: "brus_0_logo.png",
      lat: 55.68126144704113,
      lon: 12.56447606464483,
      corners: [
        GeoPoint(55.681194909339546, 12.56451629777563),
        GeoPoint(55.68135860700611, 12.564626938898236),
        GeoPoint(55.68140737592466, 12.564432478724587),
        GeoPoint(55.68126863008427, 12.564309767675656),
      ],
      openingHours: {
        "monday": {"open": "12:00", "close": "00:00"},
        "tuesday": {"open": "12:00", "close": "00:00"},
        "wednesday": {"open": "12:00", "close": "00:00"},
        "thursday": {"open": "12:00", "close": "00:00"},
        "friday": {"open": "12:00", "close": "02:00"},
        "saturday": {"open": "12:00", "close": "02:00"},
        "sunday": {"open": "12:00", "close": "00:00"},
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }



  void addSpecificClub126() {
    addClubToDatabaseTemplate(
      name: "charlie's bar",
      typeOfClub: "pub",
      logo: "charlie's_bar_0_logo.png",
      lat: 55.6806802079646,
      lon: 12.580274644266746,
      corners: [
        GeoPoint(55.680696086499, 12.580297443040863),
        GeoPoint(55.68065639015095, 12.580338346723842),
        GeoPoint(55.68058153407073, 12.580127122787157),
        GeoPoint(55.680623498860626, 12.580082195791098),
      ],
      openingHours: {
        "monday": {"open": "14:00", "close": "00:00"},
        "tuesday": {"open": "14:00", "close": "00:00"},
        "wednesday": {"open": "12:00", "close": "00:00"},
        "thursday": {"open": "12:00", "close": "01:00"},
        "friday": {"open": "12:00", "close": "02:00"},
        "saturday": {"open": "12:00", "close": "02:00"},
        "sunday": null,
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub127() {
    addClubToDatabaseTemplate(
      name: "proud mary pub",
      typeOfClub: "bar_club",
      logo: "proud_mary_pub_københavn_0_logo.png",
      lat: 55.675787677725474,
      lon: 12.56706150527081,
      corners: [
        GeoPoint(55.67566706236237, 12.566892864194289),
        GeoPoint(55.675783561164685, 12.566772406271001),
        GeoPoint(55.6757967341531, 12.567262998497636),
        GeoPoint(55.67589182652719, 12.567100927852666),
      ],
      openingHours: {
        "monday": {"open": "14:00", "close": "02:00"},
        "tuesday": {"open": "14:00", "close": "02:00"},
        "wednesday": {"open": "14:00", "close": "03:00"},
        "thursday": {"open": "14:00", "close": "04:00"},
        "friday": {"open": "11:00", "close": "05:00"},
        "saturday": {"open": "11:00", "close": "05:00"},
        "sunday": {"open": "11:00", "close": "02:00"},
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub128() {
    addClubToDatabaseTemplate(
      name: "the scottish pub",
      typeOfClub: "pub",
      logo: "the_scottish_pub_0_logo.png",
      lat: 55.67599880895638,
      lon: 12.56714922015081,
      corners: [
        GeoPoint(55.67608572524691, 12.567140920195687),
        GeoPoint(55.67599479743063, 12.567241705365053),
        GeoPoint(55.675947996266345, 12.567035392194823),
        GeoPoint(55.676023546689514, 12.56695476405933),
      ],
      openingHours: {
        "monday": {"open": "12:00", "close": "03:00"},
        "tuesday": {"open": "12:00", "close": "03:00"},
        "wednesday": {"open": "12:00", "close": "03:00"},
        "thursday": {"open": "12:00", "close": "03:00"},
        "friday": {"open": "12:00", "close": "05:00"},
        "saturday": {"open": "12:00", "close": "05:00"},
        "sunday": {"open": "12:00", "close": "02:00"},
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub129() {
    addClubToDatabaseTemplate(
      name: "the dubliner",
      typeOfClub: "pub",
      lat: 55.67868418210784,
      lon: 12.578909770818331,
      corners: [
        GeoPoint(55.67869098754209, 12.578795776947738),
        GeoPoint(55.67869287794026, 12.579025105793283),
        GeoPoint(55.678640702916745, 12.578807846886978),
        GeoPoint(55.678642593317356, 12.579033822971622),
      ],
      openingHours: {
        "monday": {"open": "10:00", "close": "luk"},
        "tuesday": {"open": "10:00", "close": "lk"},
        "wednesday": {"open": "10:00", "close": "lk"},
        "thursday": {"open": "10:00", "close": "luk"},
        "friday": {"open": "10:00", "close": "05:00"},
        "saturday": {"open": "10:00", "close": "05:00"},
        "sunday": {"open": "11:00", "close": "luk"},
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub130() {
    addClubToDatabaseTemplate(
      name: "kennedy's irish bar",
      typeOfClub: "bar",
      logo: "kennedy's_irish_bar_0_logo.png",
      lat: 55.67368879046827,
      lon: 12.55604794265282,
      corners: [
        GeoPoint(55.673685000531925, 12.555920899772346),
        GeoPoint(55.673718113480504, 12.556103136645572),
        GeoPoint(55.67358908700462, 12.555962746755972),
        GeoPoint(55.67352971184535, 12.556170631789966),
      ],
      openingHours: {
        "monday": {"open": "12:00", "close": "02:00"},
        "tuesday": {"open": "12:00", "close": "02:00"},
        "wednesday": {"open": "12:00", "close": "02:00"},
        "thursday": {"open": "12:00", "close": "02:00"},
        "friday": {"open": "12:00", "close": "02:00"},
        "saturday": {"open": "12:00", "close": "02:00"},
        "sunday": {"open": "12:00", "close": "01:00"},
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }



  void addSpecificClub131() {
    addClubToDatabaseTemplate(
      name: "globe irish pub",
      typeOfClub: "pub",
      logo: "globe_irish_pub_0_logo.png",
      lat: 55.68181218786044,
      lon: 12.570956669494493,
      corners: [
        GeoPoint(55.68177891949226, 12.570999584834011),
        GeoPoint(55.68184659034776, 12.570978127164251),
        GeoPoint(55.681835248871764, 12.570791043106045),
        GeoPoint(55.68175926089773, 12.570599265167088),
      ],
      openingHours: {
        "monday": {"open": "14:00", "close": "00:00"},
        "tuesday": {"open": "14:00", "close": "01:00"},
        "wednesday": {"open": "14:00", "close": "01:00"},
        "thursday": {"open": "14:00", "close": "02:00"},
        "friday": {"open": "13:00", "close": "03:00"},
        "saturday": {"open": "12:30", "close": "03:00"},
        "sunday": {"open": "13:00", "close": "22:00"},
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub132() {
    addClubToDatabaseTemplate(
      name: "the southern cross pub",
      typeOfClub: "pub",
      logo: "the_southern_cross_pub_copenhagen_0_logo.png",
      lat: 55.67524912466911,
      lon: 12.572433312692805,
      corners: [
        GeoPoint(55.675243452974996, 12.57233340041799),
        GeoPoint(55.67529903554186, 12.572474886927962),
        GeoPoint(55.67521206958601, 12.572571446441875),
        GeoPoint(55.67516707407847, 12.572427277735503),
      ],
      openingHours: {
        "monday": {"open": "16:00", "close": "03:00"},
        "tuesday": {"open": "16:00", "close": "03:00"},
        "wednesday": {"open": "16:00", "close": "03:00"},
        "thursday": {"open": "16:00", "close": "03:00"},
        "friday": {"open": "14:00", "close": "05:00"},
        "saturday": {"open": "12:00", "close": "05:00"},
        "sunday": {"open": "13:00", "close": "03:00"},
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub133() {
    addClubToDatabaseTemplate(
      name: "the shamrock inn",
      typeOfClub: "pub",
      logo: "the_shamrock_inn_0_logo.png",
      lat: 55.675949783414424,
      lon: 12.565911742483337,
      corners: [
        GeoPoint(55.675910460355915, 12.565729352290393),
        GeoPoint(55.67598683779877, 12.56591576579642),
        GeoPoint(55.67582349575927, 12.565837981743543),
        GeoPoint(55.67589457987877, 12.566043170710609),
      ],
      openingHours: {
        "monday": {"open": "15:00", "close": "02:00"},
        "tuesday": {"open": "15:00", "close": "02:00"},
        "wednesday": {"open": "15:00", "close": "02:00"},
        "thursday": {"open": "15:00", "close": "03:00"},
        "friday": {"open": "12:30", "close": "04:00"},
        "saturday": {"open": "13:30", "close": "04:00"},
        "sunday": {"open": "15:00", "close": "02:00"},
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub134() {
    addClubToDatabaseTemplate(
      name: "gaia cocktails",
      typeOfClub: "cocktail_bar",
      logo: "gaia_cocktails_0_logo.png",
      lat: 55.67871769625327,
      lon: 12.567531602357915,
      corners: [
        GeoPoint(55.67873735637654, 12.567397491921923),
        GeoPoint(55.67865342270443, 12.567451806648501),
        GeoPoint(55.67869652380179, 12.567670406659165),
        GeoPoint(55.67877894506625, 12.56761005696297),
      ],
      openingHours: {
        "monday": {"open": "16:00", "close": "00:00"},
        "tuesday": {"open": "16:00", "close": "00:00"},
        "wednesday": {"open": "16:00", "close": "00:00"},
        "thursday": {"open": "16:00", "close": "00:00"},
        "friday": {"open": "14:00", "close": "02:00"},
        "saturday": {"open": "14:00", "close": "02:00"},
        "sunday": {"open": "16:00", "close": "00:00"},
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub135() {
    addClubToDatabaseTemplate(
      name: "lulu",
      typeOfClub: "cocktail_bar",
      logo: "lulu_0_logo.png",
      lat: 55.688591189910085,
      lon: 12.562212185039023,
      corners: [
        GeoPoint(55.688602566562906, 12.562159037932386),
        GeoPoint(55.68868523680747, 12.562266677642027),
        GeoPoint(55.68863517961604, 12.562403245523635),
        GeoPoint(55.688550613154675, 12.56229896955492),
      ],
      openingHours: {
        "monday": {"open": "16:00", "close": "00:00"},
        "tuesday": {"open": "16:00", "close": "00:00"},
        "wednesday": {"open": "16:00", "close": "00:00"},
        "thursday": {"open": "16:00", "close": "00:00"},
        "friday": {"open": "16:00", "close": "02:00"},
        "saturday": {"open": "16:00", "close": "02:00"},
        "sunday": null,
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub136() {
    addClubToDatabaseTemplate(
      name: "bar somm'",
      typeOfClub: "bar",
      logo: "bar_somm'_0_logo.png",
      lat: 55.68412033000026,
      lon: 12.56817118363016,
      corners: [
        GeoPoint(55.684074815668566, 12.568002529506069),
        GeoPoint(55.68401850049125, 12.568147430953337),
        GeoPoint(55.684205623979544, 12.568346584967239),
        GeoPoint(55.68424871895907, 12.56823728496198),
      ],
      openingHours: {
        "monday": null,
        "tuesday": null,
        "wednesday": {"open": "16:00", "close": "00:00"},
        "thursday": {"open": "16:00", "close": "00:00"},
        "friday": {"open": "16:00", "close": "00:00"},
        "saturday": {"open": "16:00", "close": "00:00"},
        "sunday": null,
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }




  void addSpecificClub137() {
    addClubToDatabaseTemplate(
      name: "kødbyens øl & cocktailbar",
      typeOfClub: "bar",
      logo: "kødbyens_øl_&_cocktailbar_0_logo.png",
      lat: 55.6686718663795,
      lon: 12.559491069497579,
      corners: [
        GeoPoint(55.668727836458835, 12.559712351716962),
        GeoPoint(55.66864312495626, 12.559518562136955),
        GeoPoint(55.66869947325294, 12.559399203848923),
        GeoPoint(55.668774730247456, 12.559647308155508),
      ],
      openingHours: {
        "monday": null,
        "tuesday": null,
        "wednesday": {"open": "15:00", "close": "00:00"},
        "thursday": {"open": "16:00", "close": "01:00"},
        "friday": {"open": "12:00", "close": "02:00"},
        "saturday": {"open": "16:00", "close": "02:00"},
        "sunday": null,
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub138() {
    addClubToDatabaseTemplate(
      name: "the library bar",
      typeOfClub: "bar",
      lat: 55.67380140169433,
      lon: 12.564848950126793,
      corners: [
        GeoPoint(55.673823536858364, 12.564946012606546),
        GeoPoint(55.673881769749954, 12.564836670482613),
        GeoPoint(55.673846753903966, 12.564735427775265),
        GeoPoint(55.673764542664145, 12.564771875149908),
      ],
      openingHours: {
        "monday": {"open": "16:00", "close": "00:00"},
        "tuesday": {"open": "16:00", "close": "00:00"},
        "wednesday": {"open": "16:00", "close": "00:00"},
        "thursday": {"open": "16:00", "close": "00:00"},
        "friday": {"open": "16:00", "close": "01:00"},
        "saturday": {"open": "16:00", "close": "01:00"},
        "sunday": {"open": "16:00", "close": "00:00"},
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub139() {
    addClubToDatabaseTemplate(
      name: "the bird & the churchkey",
      typeOfClub: "cocktail_bar",
      logo: "the_bird_&_the_churchkey_0_logo.png",
      lat: 55.677650850612395,
      lon: 12.578048712946483,
      corners: [
        GeoPoint(55.67760774836284, 12.577980316624126),
        GeoPoint(55.67765765622641, 12.578209645469672),
        GeoPoint(55.677717394343595, 12.577886439319231),
        GeoPoint(55.67777486383802, 12.578126496999651),
      ],
      openingHours: {
        "monday": {"open": "16:00", "close": "00:00"},
        "tuesday": {"open": "16:00", "close": "00:00"},
        "wednesday": {"open": "16:00", "close": "00:00"},
        "thursday": {"open": "16:00", "close": "00:00"},
        "friday": {"open": "14:00", "close": "02:00"},
        "saturday": {"open": "14:00", "close": "02:00"},
        "sunday": {"open": "16:00", "close": "00:00"},
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub140() {
    addClubToDatabaseTemplate(
      name: "barkowski",
      typeOfClub: "bar",
      logo: "barkowski_0_logo.png",
      lat: 55.68464835089849,
      lon: 12.567651837404092,
      corners: [
        GeoPoint(55.684561468508974, 12.567552160623963),
        GeoPoint(55.684640570393874, 12.567641102981616),
        GeoPoint(55.68461333861597, 12.567419513824529),
        GeoPoint(55.68478450947978, 12.567288400514606),
      ],
      openingHours: {
        "monday": {"open": "12:00", "close": "02:00"},
        "tuesday": {"open": "12:00", "close": "02:00"},
        "wednesday": {"open": "12:00", "close": "02:00"},
        "thursday": {"open": "12:00", "close": "02:00"},
        "friday": {"open": "12:00", "close": "05:00"},
        "saturday": {"open": "12:00", "close": "05:00"},
        "sunday": {"open": "12:00", "close": "02:00"},
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub141() {
    addClubToDatabaseTemplate(
      name: "mikkeller bar",
      typeOfClub: "beer_bar",
      logo: "mikkeller_bar_0_logo.png",
      lat: 55.67191641525334,
      lon: 12.557561900312479,
      corners: [
        GeoPoint(55.67195801119495, 12.557561900312479),
        GeoPoint(55.671865365628214, 12.55765443651331),
        GeoPoint(55.6718180973974, 12.55751362055552),
        GeoPoint(55.67193607879488, 12.557402979445829),
      ],
      openingHours: {
        "monday": {"open": "14:00", "close": "23:00"},
        "tuesday": {"open": "14:00", "close": "23:00"},
        "wednesday": {"open": "14:00", "close": "23:00"},
        "thursday": {"open": "14:00", "close": "00:00"},
        "friday": {"open": "12:00", "close": "01:00"},
        "saturday": {"open": "12:00", "close": "01:00"},
        "sunday": {"open": "12:00", "close": "22:00"},
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }



//GODKENDT OVER


  void addSpecificClub142() {
    addClubToDatabaseTemplate(
      name: "märkbar",
      typeOfClub: "bar",
      logo: "märkbar_0_logo.png",
      lat: 55.671746024585445,
      lon: 12.54597021817339,
      corners: [
        GeoPoint(55.67171652912747, 12.545897798537215),
        GeoPoint(55.67175812528159, 12.546064766030023),
        GeoPoint(55.67180728431578, 12.54582672000614),
        GeoPoint(55.671837157852565, 12.545934008354932),
      ],
      openingHours: {
        "monday": null,
        "tuesday": {"open": "16:00", "close": "02:00"},
        "wednesday": {"open": "16:00", "close": "02:00"},
        "thursday": {"open": "16:00", "close": "02:00"},
        "friday": {"open": "16:00", "close": "04:00"},
        "saturday": {"open": "16:00", "close": "04:00"},
        "sunday": null,
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub143() {
    addClubToDatabaseTemplate(
      name: "andy's bar",
      typeOfClub: "bar",
      logo: "andy's_bar_0_logo.png",
      lat: 55.68217165282674,
      lon: 12.582293010671908,
      corners: [
        GeoPoint(55.68219175487749, 12.582259373262643),
        GeoPoint(55.682159895018685, 12.582383158928732),
        GeoPoint(55.682118553020395, 12.582186716458635),
        GeoPoint(55.68208176239798, 12.582305792887427),
      ],
      openingHours: {
        "monday": null,
        "tuesday": null,
        "wednesday": {"open": "20:00", "close": "02:00"},
        "thursday": {"open": "20:00", "close": "04:00"},
        "friday": {"open": "18:00", "close": "06:00"},
        "saturday": {"open": "20:00", "close": "06:00"},
        "sunday": null,
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }

  void addSpecificClub144() {
    addClubToDatabaseTemplate(
      name: "the drunken flamingo",
      typeOfClub: "club",
      logo: "the_drunken_flamingo_0_logo.png",
      lat: 55.67832100583751,
      lon: 12.57182894868128,
      corners: [
        GeoPoint(55.678271854987685, 12.57170959039325),
        GeoPoint(55.67833688532964, 12.571888627825295),
        GeoPoint(55.67837960869407, 12.571606995896882),
        GeoPoint(55.67858301663707, 12.571662651719336),
      ],
      openingHours: {
        "monday": null,
        "tuesday": null,
        "wednesday": null,
        "thursday": null,
        "friday": {"open": "20:00", "close": "05:00"},
        "saturday": {"open": "20:00", "close": "05:00"},
        "sunday": null,
      },
      totalPossibleAmountOfVisitors: 100,
    );
  }




}

// TODO Under

// TODO Billeder bar i DB

// Man skal have notifikationer alle dage undtagen mandag og søndag. +
// 1 total notifikation hvis dine venner tager i byen og informationer om hvem der kommer.

class FirestoreService { // TODO
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> setData(
      String collection, String documentId, Map<String, dynamic> data) async {
    await firestore.collection(collection).doc(documentId).set(data);
  }

  Future<void> addSubcollection(String collection, String documentId,
      String subcollection, Map<String, dynamic> data) async {
    await firestore
        .collection(collection)
        .doc(documentId)
        .collection(subcollection)
        .add(data);
  }
}
