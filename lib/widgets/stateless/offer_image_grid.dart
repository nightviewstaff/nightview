import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/values.dart';

class OfferImageGrid extends StatelessWidget {
  const OfferImageGrid({super.key});

  void _showOfferDialog(BuildContext context, String imagePath) {
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth = screenSize.width * 0.9;
    final dialogHeight = screenSize.height * 0.55;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SizedBox(
            width: dialogWidth,
            height: dialogHeight,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.asset(
                    imagePath,
                    width: double.infinity,
                    height: dialogHeight,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        GestureDetector(
                          onHorizontalDragEnd: (_) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Offer Accepted!')),
                            );
                          },
                          child: Container(
                            height: 48,
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Text(
                              'Swipe to Accept',
                              style: TextStyle(color: white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
