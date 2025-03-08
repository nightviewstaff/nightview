// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:maps_toolkit/maps_toolkit.dart';
// import 'package:nightview/constants/colors.dart';
// import 'package:nightview/constants/text_styles.dart';
// import 'package:nightview/constants/values.dart';
// import 'package:nightview/models/clubs/club_data.dart';
// import 'package:nightview/utilities/club_data/club_distance_calculator.dart';
// import 'package:nightview/utilities/club_data/club_name_formatter.dart';
//
// class ClubListTile extends StatelessWidget {
//   final ClubData club;
//   final double userLocationLat;
//   final double userLocationLon;
//   final VoidCallback onTap;
//
//   const ClubListTile({
//     super.key,
//     required this.club,
//     required this.userLocationLat,
//     required this.userLocationLon,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: _buildClubLogo(),
//       title: _buildTitleSection(),
//       trailing: _buildClubTypeIcon(),
//       onTap: onTap,
//     );
//   }
//
//   Widget _buildClubLogo() {
//     return CircleAvatar(
//       backgroundImage: CachedNetworkImageProvider(club.logo),
//       radius: kBigSizeRadius,
//     );
//   }
//
//   Widget _buildTitleSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           ClubNameFormatter.formatClubName(club.name),
//           style: kTextStyleP3,
//         ),
//         const SizedBox(height: 2),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Text(
//                 ClubNameFormatter.displayClubLocation(club),
//                 style: kTextStyleP3.copyWith(color: primaryColor),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             Text(
//               ClubDistanceCalculator.displayDistanceToClub(
//                 club: club,
//                 userLat: userLocationLat,
//                 userLon: userLocationLon,
//               ),
//               style: kTextStyleP3.copyWith(color: primaryColor),
//             ),
//           ],
//         )
//       ],
//     );
//   }
//
//   Widget _buildClubTypeIcon() {
//     return CircleAvatar(
//       backgroundImage: CachedNetworkImageProvider(club.typeOfClubImg),
//       radius: 15,
//     );
//   }
// }
