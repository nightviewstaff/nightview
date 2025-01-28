import '../locations/geofencing_service.dart';


class Initializator {
  void initializeNeededTasks() async {
    GeofencingService geofencingService = GeofencingService();
    geofencingService.initializeWorkManager();
    // geofencingService.registerPeriodicTask();

  }

}