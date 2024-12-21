import 'package:cloud_firestore/cloud_firestore.dart';

class LocationData {
  final String userId;
  final String clubId;
  final bool private;
  final Timestamp timestamp;

  LocationData(
      {required this.userId,
      required this.clubId,
      required this.private,
      required this.timestamp});

  DateTime get timestampAsDateTime => timestamp.toDate();

  String get readableTimestamp =>
      '${timestampAsDateTime.day}/${timestampAsDateTime.month}-${timestampAsDateTime.year}: ${timestampAsDateTime.hour.toString().padLeft(2, '0')}:${timestampAsDateTime.minute.toString().padLeft(2, '0')}';
}
