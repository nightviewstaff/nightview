import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/helpers/clubs/club_data_helper.dart';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/services/firestore/upload_image_with_meta_data.dart';
import 'package:nightview/utilities/club_data/club_distance_calculator.dart';
import 'package:nightview/utilities/club_data/club_name_formatter.dart';
import 'package:provider/provider.dart';

class ImageUploadScreen extends StatefulWidget {
  final XFile image;

  const ImageUploadScreen({super.key, required this.image});

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  final TextEditingController _captionController = TextEditingController();

  int _rating = 0;
  List<String> selectedFriendIds = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(widget.image.path),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Row for rating and tag button

            //TODO Make friends who are tagged vissible like in social screen.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _rating = index + 1;
                        });
                      },
                      child: Icon(
                        index < _rating! ? Icons.star : Icons.star_border,
                        color: secondaryColor,
                        size: 24,
                      ),
                    );
                  }),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _showTagFriendsDialog(context);
                  },
                  icon: const Icon(
                    Icons.person_add,
                    size: 22,
                    color: primaryColor,
                  ),
                  label: const Text(
                    "Tag",
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: black,
                    foregroundColor: white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Row for comment and share button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _captionController,
                    decoration: InputDecoration(
                      labelText: 'Caption',
                      filled: true,
                      fillColor: black,
                      labelStyle: const TextStyle(color: white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            const BorderSide(color: primaryColor, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            const BorderSide(color: primaryColor, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            const BorderSide(color: secondaryColor, width: 2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    final caption = _captionController.text;
                    print('📸 Rating: $_rating');
                    print('💬 Caption: $caption');
                    if (_rating != 0) {
                      _showShareDialog(context);
                    } else {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          backgroundColor: black,
                          title: const Text("Select Rating",
                              style: TextStyle(color: redAccent)),
                          content: const Text(
                            "Please select a star rating before sharing.",
                            style: TextStyle(color: white),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("OK",
                                  style: TextStyle(color: primaryColor)),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                  ),
                  child: const Text(
                    "Share",
                    selectionColor: white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showTagFriendsDialog(BuildContext context) {
    final allFriends =
        Provider.of<GlobalProvider>(context, listen: false).friends;
    final profilePictures =
        Provider.of<GlobalProvider>(context, listen: false).friendPbs;
    final TextEditingController searchController = TextEditingController();

    _showCustomDialog(
      showCloseIcon: true,
      context: context,
      title: 'Tag Friends',
      content: StatefulBuilder(
        builder: (context, setState) {
          return Container(
            color: black,
            child: SizedBox(
              width: double.maxFinite,
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: allFriends.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final friend = allFriends[index];
                  final isSelected = selectedFriendIds.contains(friend.id);
                  final profileImage = profilePictures.length > index
                      ? profilePictures[index]
                      : const AssetImage('images/user_pb.jpg');
                  final isDefaultImage = profileImage is AssetImage &&
                      profileImage.assetName == 'images/user_pb.jpg';
//TODO fix default image if no image

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedFriendIds.remove(friend.id);
                        } else {
                          selectedFriendIds.add(friend.id);
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? secondaryColor : black,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? primaryColor : white,
                          width: isSelected ? 3 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: secondaryColor,
                                backgroundImage:
                                    isDefaultImage ? null : profileImage,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            friend.firstName,
                            style: const TextStyle(color: white, fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      actions: const [],
    );
  }

  void _showShareDialog(BuildContext context) async {
    final clubDataHelper = Provider.of<ClubDataHelper>(context, listen: false);
    final searchController = TextEditingController();
    String searchQuery = '';

    String? selectedClubId;
    if (clubDataHelper.clubDataList.value.isEmpty) {
      await clubDataHelper.loadInitialClubs();
    }
    List<ClubData> clubs = clubDataHelper.clubDataList.value;

    // Obtain user's current location
    Position userPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Calculate distance to each club and sort
    clubs.sort((a, b) {
      double distanceA = Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        a.lat,
        a.lon,
      );
      double distanceB = Geolocator.distanceBetween(
          userPosition.latitude, userPosition.longitude, b.lat, b.lon);
      return distanceA.compareTo(distanceB);
    });

    // Pre-select the nearest club
    selectedClubId = clubs.isNotEmpty ? clubs.first.id : null;

    if (selectedClubId == null) {
      print('❌ No clubs found. Cannot proceed.');
      return;
    }

    _showCustomDialog(
      context: context,
      title: 'Share Photo',
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TextField(
              //   controller: searchController,
              //   onChanged: (value) {
              //     setState(() {
              //       searchQuery = value;
              //     });
              //   },
              //   style: const TextStyle(color: Colors.white),
              //   decoration: InputDecoration(
              //     hintText: 'Search Clubs',
              //     hintStyle: const TextStyle(color: Colors.grey),
              //     prefixIcon: const Icon(Icons.search, color: Colors.grey),
              //     filled: true,
              //     fillColor: Colors.grey[900],
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(8),
              //       borderSide: BorderSide.none,
              //     ),
              //   ),
              // ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Select Club'),
                value: selectedClubId,
                items: clubs.map((club) {
                  return DropdownMenuItem(
                    value: club.id,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Club icon
                        CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(club.logo),
                          backgroundColor: transparent,
                        ),
                        // SizedBox(
                        //   width: 15,
                        // ),
                        // Club name
                        SizedBox(
                          width: 150,
                          child: Text(
                            ClubNameFormatter.displayClubName(club),
                            style: const TextStyle(
                                color: primaryColor, fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // Distance
                        Text(
                          ClubDistanceCalculator.displayDistanceToClub(
                              userLat: userPosition.latitude,
                              userLon: userPosition.longitude,
                              club: club),
                          style: const TextStyle(color: white, fontSize: 10),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedClubId = value;
                  });
                },
              ),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final caption = _captionController.text;
            final userId = Provider.of<GlobalProvider>(context, listen: false)
                .userDataHelper
                .currentUserId;

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(
                child: CircularProgressIndicator(color: primaryColor),
              ),
            );

            try {
              await uploadImageWithMetaData(
                imageFile: widget.image,
                clubId: selectedClubId!,
                caption: caption,
                rating: _rating,
                taggedUserIds: selectedFriendIds,
                uploaderId: userId!,
              );

              Navigator.of(context).pop(); // remove loading spinner
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    '✅ Memory saved!',
                    style: TextStyle(color: white), // ✅ white text
                  ),
                  backgroundColor: black, // your black constant
                ),
              );

              Navigator.pop(context); // close ImageUploadScreen
              Navigator.pop(context);
            } catch (e) {
              Navigator.of(context).pop(); // remove loading spinner
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: black,
                  title: const Text("Upload Failed",
                      style: TextStyle(color: redAccent)),
                  content:
                      Text(e.toString(), style: const TextStyle(color: white)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK",
                          style: TextStyle(color: primaryColor)),
                    ),
                  ],
                ),
              );
            }
          },
          child: const Text('Share'),
        ),
      ],
    );
  }

  Future<void> _showCustomDialog({
    required BuildContext context,
    required String title,
    required Widget content,
    required List<Widget> actions,
    bool showCloseIcon = false,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.only(top: 10, left: 16, right: 6),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              if (showCloseIcon)
                IconButton(
                  icon: const Icon(Icons.close, color: white),
                  onPressed: () => Navigator.pop(context),
                ),
            ],
          ),
          content: content,
          actions: actions,
          backgroundColor: black,
        );
      },
    );
  }

  Widget buildSearchBar(
      TextEditingController controller, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(color: white),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[900],
          hintText: 'Search...',
          hintStyle: const TextStyle(color: grey),
          prefixIcon: const Icon(Icons.search, color: grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
