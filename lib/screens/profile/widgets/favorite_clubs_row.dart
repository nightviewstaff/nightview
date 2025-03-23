// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:nightview/constants/colors.dart';
// import 'package:nightview/constants/text_styles.dart';
// import 'package:nightview/constants/values.dart';
// import 'package:nightview/helpers/clubs/club_data_helper.dart';
// import 'package:nightview/models/clubs/club_data.dart';
// import 'package:nightview/providers/global_provider.dart';
// import 'package:provider/provider.dart';

// class FavoriteClubsRow extends StatelessWidget {
//   final String userId;

//   const FavoriteClubsRow({super.key, required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     final globalProvider = Provider.of<GlobalProvider>(context, listen: false);
//     final clubDataHelper = Provider.of<ClubDataHelper>(context, listen: false);

//     return FutureBuilder<List<ClubData>>(
//       future: globalProvider.getFavoriteClubs(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return Center(child: CircularProgressIndicator(color: primaryColor));
//         }
//         final favoriteClubIds = snapshot.data!;
//         if (favoriteClubIds.isEmpty) {
//           return SizedBox.shrink();
//         }

//         return Container(
//           height: 100,
//           padding: EdgeInsets.symmetric(vertical: kSmallSpacerValue),
//           child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: favoriteClubIds.map((clubId) {
//                 final club = clubDataHelper.clubData[clubId];
//                 if (club == null) return SizedBox.shrink();
//                 return Padding(
//                   padding: EdgeInsets.only(right: kNormalSpacerValue),
//                   child: _buildClubItem(club),
//                 );
//               }).toList(),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildClubItem(ClubData club) {
//     return Column(
//       children: [
//         Container(
//           width: 60,
//           height: 60,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(color: primaryColor, width: 2),
//           ),
//           child: ClipOval(
//             child: CachedNetworkImage(
//               imageUrl: club.logo,
//               placeholder: (context, url) => Image.asset(
//                 'images/club_types/${club.typeOfClub}_icon.png',
//                 fit: BoxFit.cover,
//               ),
//               errorWidget: (context, url, error) => Image.asset(
//                 club.typeOfClubImg,
//                 fit: BoxFit.cover,
//               ),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         SizedBox(height: kSmallSpacerValue),
//         Text(
//           club.name,
//           style: kTextStyleP1.copyWith(fontSize: 12),
//           overflow: TextOverflow.ellipsis,
//           maxLines: 1,
//         ),
//       ],
//     );
//   }
// }
