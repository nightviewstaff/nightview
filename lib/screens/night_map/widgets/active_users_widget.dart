// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:nightview/app_localization.dart';
// import 'package:nightview/constants/colors.dart';
// import 'package:nightview/constants/text_styles.dart';
// import 'package:nightview/generated/l10n.dart';
// import 'package:nightview/utilities/club_data/club_data_location_formatting.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ActiveUsersWidget extends StatefulWidget {
//   const ActiveUsersWidget({super.key});

//   @override
//   _ActiveUsersWidgetState createState() => _ActiveUsersWidgetState();
// }

// class _ActiveUsersWidgetState extends State<ActiveUsersWidget> {
//   String _selectedCity = "København";
//   int _activeUsersCount = 0;
//   final List<String> cities =
//       ClubDataLocationFormatting.danishCitiesAndAreas.keys.toList()..sort();

//   @override
//   void initState() {
//     super.initState();
//     _loadSelectedCity();
//   }

//   Future<void> _loadSelectedCity() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _selectedCity = prefs.getString('selectedCity') ?? "København";
//     });
//     _updateActiveUsersCount();
//   }

//   Future<void> _saveSelectedCity(String city) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('selectedCity', city);
//   }

//   void _updateActiveUsersCount() {
//     final List<User> users = getUsers(); // Replace with your data source
//     setState(() {
//       _activeUsersCount = _getActiveUsersInCity(_selectedCity, users);
//     });
//   }

//   int _getActiveUsersInCity(String city, List<User> users) {
//     final bounds = ClubDataLocationFormatting.cityBoundingBoxes[city];
//     if (bounds == null) return 0;

//     // return users.where((user) {
//     //   final lat = user.latitude;
//     //   final lon = user.longitude;
//     //   return lat >= bounds["minLat"]! &&
//     //       lat <= bounds["maxLat"]! &&
//     //       lon >= bounds["minLon"]! &&
//     //       lon <= bounds["maxLon"]!;
//     // }).length;

//     return 100;
//   }

//   void _showCityDropdown(BuildContext context) async {
//     final RenderBox renderBox = context.findRenderObject() as RenderBox;
//     final Offset offset = renderBox.localToGlobal(Offset.zero);

//     final String? selected = await showMenu<String>(
//       context: context,
//       position: RelativeRect.fromLTRB(
//         offset.dx,
//         offset.dy + renderBox.size.height,
//         offset.dx,
//         0,
//       ),
//       items: cities.map((String city) {
//         return PopupMenuItem<String>(
//           value: city,
//           child: Text(city),
//         );
//       }).toList(),
//     );

//     if (selected != null) {
//       setState(() {
//         _selectedCity = selected;
//       });
//       await _saveSelectedCity(selected);
//       _updateActiveUsersCount();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         RichText(
//           text: TextSpan(
//             children: [
//               TextSpan(
//                 text: S.of(context).current_users.split('byen')[0],
//                 style: kTextStyleH3,
//               ),
//               TextSpan(
//                 text: _selectedCity,
//                 style: kTextStyleH3.copyWith(
//                   color: primaryColor,
//                 ),
//                 recognizer: TapGestureRecognizer()
//                   ..onTap = () {
//                     _showCityDropdown(context);
//                   },
//               ),
//               TextSpan(
//                 text: " ${S.of(context).current_users.split('byen')[1]}",
//                 style: kTextStyleH3,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// // Placeholder for user data
// class User {
//   final double latitude;
//   final double longitude;

//   User(this.latitude, this.longitude);
// }

// List<User> getUsers() {
//   // Replace with actual user data
//   return [];
// }
