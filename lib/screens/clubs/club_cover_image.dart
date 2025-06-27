import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/firestore.dart';

class ClubCoverImage extends StatelessWidget {
  final String clubId;

  const ClubCoverImage({required this.clubId, super.key});

  Future<String?> _getCoverImageUrl(String clubId) async {
    // TESTS
    // clubId = "Icon_Madrid_1";
    // print(clubId)
    try {
      final ref = StoragePaths.clubImagesRef
          .child('$clubId/cover_image.webp'); // Construct full path
      return await ref.getDownloadURL();
    } catch (e) {
      return null; // If file not found or other error
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getCoverImageUrl(clubId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 200,
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          return Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(snapshot.data!),
                fit: BoxFit.cover,
              ),
            ),
          );
        }

        // Fallback to solid black background
        return Container(
          height: 200,
          color: black,
        );
      },
    );
  }
}
