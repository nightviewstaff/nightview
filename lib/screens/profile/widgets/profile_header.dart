// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:nightview/constants/button_styles.dart';
// import 'package:nightview/constants/colors.dart';
// import 'package:nightview/constants/text_styles.dart';
// import 'package:nightview/constants/values.dart';
// import 'package:nightview/generated/l10n.dart';
// import 'package:nightview/helpers/users/friends/friend_request_helper.dart';
// import 'package:nightview/helpers/users/friends/friends_helper.dart';

// class ProfileHeader extends StatelessWidget {
//   final String? userId;
//   final ImageProvider? profilePicture;
//   final String biography;
//   final bool isFriend;
//   final VoidCallback onFriendStatusChanged;

//   const ProfileHeader({
//     super.key,
//     this.userId,
//     this.profilePicture,
//     required this.biography,
//     required this.isFriend,
//     required this.onFriendStatusChanged,
//   });

//   Widget _removeFriendButton(BuildContext context) => IconButton(
//         icon: FaIcon(
//           FontAwesomeIcons.userMinus,
//           color: Colors.redAccent,
//           size: 15.0,
//         ),
//         tooltip: S.of(context).remove_friend,
//         onPressed: () async {
//           final confirmed = await showDialog<bool>(
//             context: context,
//             barrierDismissible: false,
//             builder: (BuildContext dialogContext) {
//               return AlertDialog(
//                 title: Text(
//                   S.of(context).remove_friend,
//                   style: TextStyle(color: Colors.redAccent),
//                 ),
//                 content: Text(S.of(context).remove_friend_confirmation),
//                 actions: <Widget>[
//                   TextButton(
//                     onPressed: () => Navigator.of(dialogContext).pop(false),
//                     child: Text(S.of(context).no,
//                         style: TextStyle(color: primaryColor)),
//                   ),
//                   TextButton(
//                     onPressed: () => Navigator.of(dialogContext).pop(true),
//                     child: Text(S.of(context).yes,
//                         style: TextStyle(color: Colors.redAccent)),
//                   ),
//                 ],
//               );
//             },
//           );

//           if (confirmed == true) {
//             await FriendsHelper.removeFriend(userId!);
//             onFriendStatusChanged();
//           }
//         },
//       );

//   Widget _addFriendButton(BuildContext context) => FilledButton(
//         onPressed: () async {
//           await FriendRequestHelper.sendFriendRequest(userId!);
//           onFriendStatusChanged();
//         },
//         style: kFilledButtonStyle,
//         child: Padding(
//           padding: EdgeInsets.all(kMainPadding),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(S.of(context).add_friend, style: kTextStyleP2),
//               FaIcon(FontAwesomeIcons.userPlus),
//             ],
//           ),
//         ),
//       );

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(kMainPadding),
//       color: Colors.black,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Biography
//           Expanded(
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(kMainBorderRadius),
//                 border:
//                     Border.all(color: primaryColor, width: kMainStrokeWidth),
//               ),
//               child: Column(
//                 children: [
//                   SizedBox(height: kSmallSpacerValue),
//                   Text(S.of(context).bio, style: kTextStyleH4),
//                   Divider(color: primaryColor, thickness: kMainStrokeWidth),
//                   Padding(
//                     padding: EdgeInsets.all(kMainPadding),
//                     child: TextField(
//                       controller: TextEditingController(text: biography),
//                       decoration: InputDecoration.collapsed(
//                           hintText: S.of(context).no_bio),
//                       readOnly: true,
//                       maxLines: 8,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(width: kNormalSpacerValue),
//           // Profile Picture and Friend Actions
//           Column(
//             children: [
//               CircleAvatar(
//                 backgroundImage:
//                     profilePicture ?? AssetImage('images/user_pb.jpg'),
//                 radius: 70.0,
//               ),
//               SizedBox(height: kNormalSpacerValue),
//               if (userId != null && !isFriend)
//                 _addFriendButton(context), // Pass context here
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
