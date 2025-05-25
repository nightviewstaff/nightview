import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/widgets/stateless/offer_image_grid.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 🔍 Search bar
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.tune, color: primaryColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.search, color: primaryColor),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Search clubs...',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 🖼️ Offers grid with equal padding top/bottom
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: OfferImageGrid(), // Should auto-size to 80% of screen
              ),
            ),

            // 🧾 Club cards
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 360),
                      margin: const EdgeInsets.only(bottom: 24),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Club Name",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(Icons.star_border, size: 18),
                                        const Icon(Icons.favorite_border,
                                            size: 18),
                                      ],
                                    ),
                                    const Text(
                                      "23+",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: black,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 6,
                                  children: const [
                                    Chip(label: Text("HipHop")),
                                    Chip(label: Text("Live DJ")),
                                    Chip(label: Text("Open 'til 5")),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  height: 60,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 5,
                                    itemBuilder: (context, imageIndex) {
                                      return Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        width: 60,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: const DecorationImage(
                                            image: NetworkImage(
                                                "https://picsum.photos/100"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: -20,
                            left: -20,
                            child: CircleAvatar(
                              radius: 26,
                              backgroundColor: white,
                              backgroundImage: const NetworkImage(
                                  "https://picsum.photos/64"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
