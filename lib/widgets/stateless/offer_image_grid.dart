import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';

class OfferImageGrid extends StatelessWidget {
  const OfferImageGrid({super.key});

  void _showOfferDialog(BuildContext context, String imagePath) {
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth = screenSize.width * 0.9;
    final dialogHeight = screenSize.height * 0.5;
    final dialogMaxHeight = screenSize.height * 0.8;

    final bool isNightOffer = false;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          backgroundColor: transparent,
          insetPadding:
              const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
          child: Container(
            width: dialogWidth,
            height: dialogMaxHeight,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(60),
              border: Border.all(color: white, width: 2.5),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Image
                  Container(
                    width: dialogWidth,
                    height: dialogHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Buttons Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // ClubBottomSheet.showClubSheet(context: context, club: club, moveMap: false)
                        },
                        child: Container(
                          width: dialogWidth * 0.4,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: grey, width: 0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'View CLUBNAME',
                              // ${club.name}',
                              style: kTextStyleP1.copyWith(
                                  fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // TODO: Handle booking offer
                        },
                        child: Container(
                          width: dialogWidth * 0.4,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: grey, width: 0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'Book offer',
                              style: kTextStyleP1.copyWith(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Description Box
                  Container(
                    width: dialogWidth * 0.7,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: transparent,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: white, width: 1.5),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Beskrivelse/copy bla bla bla bla bla bla bla",
                          style: kTextStyleH3ToP1,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.circle, size: 6, color: white),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text("2 cocktails frit valg fra barkortet",
                                  style: kTextStyleP1),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.circle, size: 6, color: white),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                "Tilbud varer fra kl 19 - 23",
                                style: kTextStyleP1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.circle, size: 6, color: white),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                "1 cocktail har 2 cl sprit",
                                style: kTextStyleP1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final offers = List.generate(
      9,
      (index) => 'images/swipe/$index.png', // ✅ Make sure path is correct
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kMainPadding),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: offers.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          childAspectRatio: 0.68,
        ),
        itemBuilder: (context, index) {
          final image = offers[index];
          return GestureDetector(
            onTap: () => _showOfferDialog(context, image),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(kMainBorderRadius),
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
