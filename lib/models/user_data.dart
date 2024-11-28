import 'package:nightview/constants/enums.dart';
import 'package:nightview/constants/values.dart';

class UserData {
  final String id;
  final String firstName;
  final String lastName;
  final String mail;
  final String phone;
  final int birthdayDay;
  final int birthdayMonth;
  final int birthdayYear;
  final double lastPositionLat;
  final double lastPositionLon;
  final DateTime? lastPositionTime;
  final PartyStatus partyStatus;
  final DateTime partyStatusTime;

  UserData({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.mail,
    required this.phone,
    required this.birthdayDay,
    required this.birthdayMonth,
    required this.birthdayYear,
    required this.lastPositionLat,
    required this.lastPositionLon,
    this.lastPositionTime,
    required this.partyStatus,
    required this.partyStatusTime,
  });

  bool answeredStatusToday() {
    DateTime now = DateTime.now();
    DateTime threshold = DateTime(now.year, now.month, now.day, kNewDayHour);

    if (now.hour < kNewDayHour) {
      threshold = threshold.subtract(Duration(days: 1));
    }

    return partyStatusTime.isAfter(threshold);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'mail': mail,
      'phone': phone,
      'birthdayDay': birthdayDay,
      'birthdayMonth': birthdayMonth,
      'birthdayYear': birthdayYear,
      'lastPositionLat': lastPositionLat,
      'lastPositionLon': lastPositionLon,
      'lastPositionTime': lastPositionTime?.millisecondsSinceEpoch,
      'partyStatus': partyStatus.toString().split('.').last,
      'partyStatusTime': partyStatusTime.millisecondsSinceEpoch,
    };
  }

  static UserData fromMap(Map<String, dynamic> map) {
    return UserData(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      mail: map['mail'],
      phone: map['phone'],
      birthdayDay: map['birthdayDay'],
      birthdayMonth: map['birthdayMonth'],
      birthdayYear: map['birthdayYear'],
      lastPositionLat: map.containsKey('last_position_lat') ? map['last_position_lat']?.toDouble() : null,
      lastPositionLon: map.containsKey('last_position_lon') ? map['last_position_lon']?.toDouble() : null,
      lastPositionTime: map.containsKey('last_position_time')
          ? DateTime.fromMillisecondsSinceEpoch(map['last_position_time'])
          : null,
      partyStatus: PartyStatus.values.firstWhere((e) => e.toString() == 'PartyStatus.' + map['partyStatus']),
      partyStatusTime: DateTime.fromMillisecondsSinceEpoch(map['partyStatusTime']),
    );
  }
}
