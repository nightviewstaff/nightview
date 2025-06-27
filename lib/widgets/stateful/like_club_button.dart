import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/icons.dart';
import 'package:nightview/generated/l10n.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:provider/provider.dart';

class LikeClubButton extends StatefulWidget {
  const LikeClubButton({super.key});

  @override
  State<LikeClubButton> createState() => _LikeClubButtonState();
}

class _LikeClubButtonState extends State<LikeClubButton> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<GlobalProvider>(context, listen: false);
      bool isLiked = await provider.getChosenClubLiked();
      provider.setChosenClubLikedLocal(isLiked);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GlobalProvider>(context);
    final bool isLiked = provider.chosenClubLikedLocal;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async {
          final String? userId = provider.userDataHelper.currentUserId;
          final String clubId = provider.chosenClub.id;

          if (userId == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  S.of(context).generic_error,
                  style: const TextStyle(color: redAccent),
                ),
                backgroundColor: black,
              ),
            );
            return;
          }

          if (isLiked) {
            bool doRemove = await _showRemoveConfirmationDialog(context);
            if (doRemove) {
              // 👇 Optimistic visual update BEFORE async completes
              provider.setChosenClubLikedLocal(false);
              provider.clubDataHelper
                  .unlikeClub(clubId, userId)
                  .catchError((e) {
                provider.setChosenClubLikedLocal(true); // rollback if failed
              });
            }
          } else {
            provider
                .setChosenClubLikedLocal(true); // 👈 Instant visual feedback
            provider.clubDataHelper.likeClub(clubId, userId).catchError((e) {
              provider.setChosenClubLikedLocal(false); // rollback if failed
            });
          }
        },
        child: Icon(
          isLiked ? defaultFullHeartIcon : defaultEmptyHeartIcon,
          color: isLiked ? redAccent : white,
          // size: 26,
        ),
      ),
    );
  }

  Future<bool> _showRemoveConfirmationDialog(BuildContext context) async {
    bool doRemove = false;
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text(
          // S.of(context).remove_like,
          "Remove Like",
          style: const TextStyle(color: redAccent),
        ),
        content: SingleChildScrollView(
          // child: Text(S.of(context).remove_like_confirmation),
          child: Text(
              "Are you sure you want to remove your like from this location?"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              doRemove = false;
              Navigator.of(context).pop();
            },
            child: Text(
              S.of(context).undo,
              style: const TextStyle(color: primaryColor),
            ),
          ),
          TextButton(
            onPressed: () {
              doRemove = true;
              Navigator.of(context).pop();
            },
            child: Text(
              S.of(context).remove,
              style: const TextStyle(color: redAccent),
            ),
          ),
        ],
      ),
    );
    return doRemove;
  }
}

// TODOD Animations below. When implemented favorite buttons crashes...

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:nightview/constants/colors.dart';
// import 'package:nightview/constants/icons.dart';
// import 'package:nightview/generated/l10n.dart';
// import 'package:nightview/providers/global_provider.dart';
// import 'package:provider/provider.dart';

// class LikeClubButton extends StatefulWidget {
//   const LikeClubButton({super.key});

//   @override
//   State<LikeClubButton> createState() => _LikeClubButtonState();
// }

// class _LikeClubButtonState extends State<LikeClubButton> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final provider = Provider.of<GlobalProvider>(context, listen: false);
//       bool isLiked = await provider.getChosenClubLiked();
//       provider.setChosenClubLikedLocal(isLiked);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<GlobalProvider>(context);
//     final bool isLiked = provider.chosenClubLikedLocal;

//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           GestureDetector(
//             onTap: () async {
//               final String? userId = provider.userDataHelper.currentUserId;
//               final String clubId = provider.chosenClub.id;

//               if (userId == null) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text(
//                       S.of(context).generic_error,
//                       style: const TextStyle(color: redAccent),
//                     ),
//                     backgroundColor: black,
//                   ),
//                 );
//                 return;
//               }

//               if (isLiked) {
//                 bool doRemove = await _showRemoveConfirmationDialog(context);
//                 if (doRemove) {
//                   provider.setChosenClubLikedLocal(false);
//                   provider.clubDataHelper
//                       .unlikeClub(clubId, userId)
//                       .catchError((e) {
//                     provider.setChosenClubLikedLocal(true);
//                   });
//                 }
//               } else {
//                 provider.setChosenClubLikedLocal(true);
//                 provider.clubDataHelper
//                     .likeClub(clubId, userId)
//                     .catchError((e) {
//                   provider.setChosenClubLikedLocal(false);
//                 });
//               }
//             },
//             child: Icon(
//               isLiked ? defaultFullHeartIcon : defaultEmptyHeartIcon,
//               color: isLiked ? redAccent : white,
//             ),
//           ),
//           LoveBubbles(isLiked: isLiked),
//         ],
//       ),
//     );
//   }

//   Future<bool> _showRemoveConfirmationDialog(BuildContext context) async {
//     bool doRemove = false;
//     await showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (context) => AlertDialog(
//         title: Text(
//           "Remove Like",
//           style: const TextStyle(color: redAccent),
//         ),
//         content: SingleChildScrollView(
//           child: Text(
//               "Are you sure you want to remove your like from this location?"),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               doRemove = false;
//               Navigator.of(context).pop();
//             },
//             child: Text(
//               S.of(context).undo,
//               style: const TextStyle(color: primaryColor),
//             ),
//           ),
//           TextButton(
//             onPressed: () {
//               doRemove = true;
//               Navigator.of(context).pop();
//             },
//             child: Text(
//               S.of(context).remove,
//               style: const TextStyle(color: redAccent),
//             ),
//           ),
//         ],
//       ),
//     );
//     return doRemove;
//   }
// }

// class LoveBubbles extends StatefulWidget {
//   final bool isLiked;

//   const LoveBubbles({required this.isLiked, super.key});

//   @override
//   State<LoveBubbles> createState() => _LoveBubblesState();
// }

// class _LoveBubblesState extends State<LoveBubbles>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   bool _wasLiked = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     );
//   }

//   @override
//   void didUpdateWidget(LoveBubbles oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.isLiked && !_wasLiked) {
//       _controller.forward(from: 0);
//     }
//     _wasLiked = widget.isLiked;
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (context, child) {
//         return Stack(
//           alignment: Alignment.center,
//           children: [
//             for (int i = 0; i < 3; i++)
//               Transform.translate(
//                 offset: Offset(
//                   (i - 1) * 10.0,
//                   -50 * _controller.value,
//                 ),
//                 child: Opacity(
//                   opacity: widget.isLiked ? (1 - _controller.value) : 0,
//                   child: const Icon(
//                     Icons.favorite,
//                     color: redAccent,
//                     size: 10,
//                   ),
//                 ),
//               ),
//           ],
//         );
//       },
//     );
//   }
// }
