import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/values.dart';

class NightOffersMainScreen extends StatefulWidget {
  const NightOffersMainScreen({super.key});

  @override
  State<NightOffersMainScreen> createState() => _NightOffersMainScreenState();
}

class _NightOffersMainScreenState extends State<NightOffersMainScreen> {
  late Future<List<Map<String, String>>> _offersFuture;

  @override
  void initState() {
    super.initState();
    _offersFuture = _fetchOffers();
  }

  Future<List<Map<String, String>>> _fetchOffers() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.generate(
      9,
      (index) => {
        'image': 'assets/images/offer_$index.png',
        // 'text': 'Tilbud ${index + 1} + sampletext x101111',
      },
    );
  }

  void _showOfferDialog(BuildContext context, Map<String, String> offer) {
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth = screenSize.width * 0.9;
    final dialogHeight = screenSize.height * 0.85;

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
                    offer['image']!,
                    width: double.infinity,
                    height: dialogHeight * 0.35,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(kBiggerPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          offer['text']!,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(kBiggerPadding),
        child: FutureBuilder<List<Map<String, String>>>(
          future: _offersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            final offers = snapshot.data ?? [];

            return GridView.builder(
              itemCount: offers.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 0.6,
              ),
              itemBuilder: (context, index) {
                final offer = offers[index];
                return GestureDetector(
                  onTap: () => _showOfferDialog(context, offer),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(kMainBorderRadius),
                          child: Container(
                            color: white,
                            child: Image.asset(
                              offer['image']!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: kSmallPadding),
                      Text(
                        offer['text']!,
                        style: Theme.of(context).textTheme.labelMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
