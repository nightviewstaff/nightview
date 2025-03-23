// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:nightview/constants/colors.dart';
// import 'package:nightview/constants/text_styles.dart';
// import 'package:nightview/constants/values.dart';
// import 'package:nightview/generated/l10n.dart';
// import 'package:nightview/helpers/users/friends/friends_helper.dart';
// import 'package:nightview/models/users/user_data.dart';
// import 'package:nightview/helpers/users/misc/profile_picture_helper.dart';
// import 'package:nightview/providers/night_map_provider.dart';
// import 'package:provider/provider.dart';

// class FriendsList extends StatelessWidget {
//   final String userId;

//   const FriendsList({super.key, required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border(
//               top: BorderSide(color: primaryColor, width: kMainStrokeWidth)),
//         ),
//         child: FutureBuilder<List<String>>(
//           future: FriendsHelper.getFriends(userId),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return Center(
//                   child: CircularProgressIndicator(color: primaryColor));
//             }
//             final friendIds = snapshot.data!;
//             if (friendIds.isEmpty) {
//               return Center(
//                   child: Text(S.of(context).no_friends, style: kTextStyleP1));
//             }

//             return ListView.builder(
//               itemCount: friendIds.length,
//               itemBuilder: (context, index) {
//                 return _buildFriendItem(context, friendIds[index]);
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildFriendItem(BuildContext context, String friendId) {
//     return FutureBuilder<UserData?>(
//       future: FriendsHelper.getUserData(friendId),
//       builder: (context, userSnapshot) {
//         if (!userSnapshot.hasData) return SizedBox.shrink();
//         final user = userSnapshot.data!;

//         return FutureBuilder<ImageProvider?>(
//           future: ProfilePictureHelper.getProfilePicture(friendId),
//           builder: (context, imageSnapshot) {
//             return ListTile(
//               leading: CircleAvatar(
//                 backgroundImage:
//                     imageSnapshot.data ?? AssetImage('images/user_pb.jpg'),
//                 radius: 20,
//               ),
//               title: Text('${user.firstName} ${user.lastName}',
//                   style: kTextStyleP1),
//               subtitle: FutureBuilder(
//                 future: Provider.of<NightMapProvider>(context, listen: false)
//                     .locationHelper
//                     .getLastPositionOfUser(friendId),
//                 builder: (context, locationSnapshot) {
//                   if (!locationSnapshot.hasData ||
//                       locationSnapshot.data!.private) {
//                     return Text(S.of(context).not_in_town, style: kTextStyleP3);
//                   }
//                   final clubName =
//                       Provider.of<NightMapProvider>(context, listen: false)
//                           .clubDataHelper
//                           .clubData[locationSnapshot.data!.clubId]
//                           ?.name;
//                   return Text(clubName ?? S.of(context).unknown_location,
//                       style: kTextStyleP3);
//                 },
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
