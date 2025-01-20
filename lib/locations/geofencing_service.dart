import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nightview/models/users/location_data.dart';
import 'package:nightview/helpers/users/misc/location_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart' as loc;
import 'package:nightview/locations/geofence_corner.dart';
import 'package:nightview/locations/geofence_center.dart';
import 'package:nightview/locations/geofence.dart';

class GeofencingService {
  // static const fetchBackground = "fetchBackground";
  List<Geofence> geofences = [];

  void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      // if (task == fetchBackground) {
      //   Position position = await Geolocator.getCurrentPosition(
      //       desiredAccuracy: LocationAccuracy.best);
      //   await _loadGeofencesIfNeeded();
      //   _checkGeofence(position);
      // }
      return Future.value(true);
    });
  }

  void initializeWorkManager() {
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
  }

  // void registerPeriodicTask() {
  //   Workmanager().registerPeriodicTask(
  //     "1"
  //     ,
  //     fetchBackground,
      // frequency: const Duration(minutes: 20),
    // );
  // }

  Future<void> _loadGeofencesIfNeeded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? lastUpdate = prefs.getInt('last_geofence_update');
    int now = DateTime.now().millisecondsSinceEpoch;

    // Check if 24 hours have passed since the last update
    if (lastUpdate == null || now - lastUpdate > 86400000) {
      await _loadGeofencesFromDatabase();
      prefs.setInt('last_geofence_update', now);
    }
  }

  Future<void> _loadGeofencesFromDatabase() async {
    geofences.clear();
    CollectionReference clubData =
        FirebaseFirestore.instance.collection('club_data');
    QuerySnapshot querySnapshot = await clubData.get();
    for (var doc in querySnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      List corners = data['corners'];
      if (corners != null && corners.length >= 4) {
        geofences.add(Geofence(
          clubId: doc.id, // Add clubId to Geofence
          corners:
              corners.map((corner) => GeofenceCorner.fromMap(corner)).toList(),
          center: _calculateCenter(corners),
        ));
      }
    }
  }

  GeofenceCenter _calculateCenter(List corners) {
    double latSum = 0;
    double lonSum = 0;
    for (var corner in corners) {
      latSum += corner['latitude'];
      lonSum += corner['longitude'];
    }
    return GeofenceCenter(
      latitude: latSum / corners.length,
      longitude: lonSum / corners.length,
    );
  }

  void _checkGeofence(Position position) {
    for (var geofence in geofences) {
      double distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          geofence.center.latitude,
          geofence.center.longitude);

      if (distance <= geofence.radius) {
        // _showNotification("Du er ankommet på klubben", "Hav en skøn aften!");
        _handleGeofenceEvent(geofence, true); // Entering geofence
      } else {
        // _showNotification("Du har forladt klubben", "Kom sikkert hjem.");
        _handleGeofenceEvent(geofence, false); // Exiting geofence
      }
    }
  }

  Future<void> _handleGeofenceEvent(Geofence geofence, bool entering) async {
    // Assuming you have a method to get the current user ID
    String userId = await getCurrentUserId();
    String clubId = geofence.clubId; // Use clubId from Geofence
    bool isPrivate = false; // Set this based on your app's logic
    Timestamp timestamp = Timestamp.now();

    LocationData locationData = LocationData(
      userId: userId,
      clubId: clubId,
      private: isPrivate,
      timestamp: timestamp,
    );

    bool success = await uploadLocationData(locationData);
    if (success) {
      print("Location data uploaded successfully.");
    } else {
      print("Failed to upload location data.");
    }
  }

  Future<String> getCurrentUserId() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      throw Exception("No user is currently signed in");
    }
  }

  // Redundant method
  Future<bool> uploadLocationData(LocationData locationData) async {
    final firestore = FirebaseFirestore.instance;

    await _cancelLatestLocationData(locationData.userId);

    try {
      await firestore.collection('location_data').add({
        'user_id': locationData.userId,
        'club_id': locationData.clubId,
        'private': locationData.private,
        'timestamp': locationData.timestamp,
        'latest': true,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> _cancelLatestLocationData(String userId) async {
    final firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot<Map<String, dynamic>> snap = await firestore
          .collection('location_data')
          .where('user_id', isEqualTo: userId)
          .where('latest', isEqualTo: true)
          .get();
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snap.docs) {
        await firestore
            .collection('location_data')
            .doc(doc.id)
            .set({'latest': false}, SetOptions(merge: true));
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
