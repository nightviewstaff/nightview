import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/input_decorations.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/models/club_data.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/screens/night_map/night_map.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NightMapMainScreen extends StatefulWidget {
  static const id = 'night_map_main_screen';

  const NightMapMainScreen({super.key});

  @override
  State<NightMapMainScreen> createState() => _NightMapMainScreenState();
}

class _NightMapMainScreenState extends State<NightMapMainScreen> {
  final searchController = TextEditingController();

  Future<int> getUserCount() async {
    try {
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('user_data').get();
      return snapshot.docs.length;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  List<SearchFieldListItem> getSearchSuggestions() {
    List<SearchFieldListItem> suggestions = [];

    Provider.of<GlobalProvider>(context)
        .clubDataHelper
        .clubData
        .forEach((id, clubData) {
      suggestions.add(
        SearchFieldListItem<ClubData>(
          clubData.name,
          item: clubData,
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(clubData.logo),
            ),
            title: Text(clubData.name),
          ),
        ),
      );
    });

    return suggestions;
  }

  double getDecimalValue({required int amount, required int fullAmount}) {
    double value = amount / fullAmount;
    if (value < 0.01) return 0.01;
    if (value > 1.0) return 1.0;
    return value;
  }

  int getPercentValue({required int amount, required int fullAmount}) {
    return (amount / fullAmount * 100).round();
  }

  // double getwidth() {
  //   if (Provider.of<GlobalProvider>(context).partyCount < 10) {
  //     return 40.00;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(kMainPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Brugere i byen',
                style: kTextStyleH3,
              ),
              Row(
                children: [
                  Container(
                    height: 40.00,
                    // width: getwidth(), Ugly if partyCount < 10
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      border: Border.all(
                        color: white,
                        width: kMainStrokeWidth,
                      ),
                    ),
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: kMainPadding),
                      child: Center(
                        // Center the text vertically
                        child: Text(
                          Provider.of<GlobalProvider>(context)
                              .partyCount
                              .toString(),
                          style: kTextStyleH3.copyWith(color: primaryColor),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: kNormalSpacerValue,
                  ),
                  FutureBuilder<int>(
                    future: getUserCount(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('E');
                      } else if (!snapshot.hasData || snapshot.data == 0) {
                        return Text('ND');
                      }

                      int userCount = snapshot.data!;
                      return CircularPercentIndicator(
                        radius: 20.0,
                        lineWidth: 3.0,
                        // Adjusted to be smaller
                        percent: getDecimalValue(
                          amount:
                          Provider.of<GlobalProvider>(context).partyCount,
                          fullAmount: userCount,
                        ),
                        center: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: (getDecimalValue(
                                    amount: Provider.of<GlobalProvider>(
                                        context)
                                        .partyCount,
                                    fullAmount: userCount) *
                                    100)
                                    .toStringAsFixed(0),
                                style: kTextStyleH3.copyWith(
                                    color: primaryColor,
                                    fontSize: 15.0), // Adjusted font size
                              ),
                              TextSpan(
                                text: '%',
                                style: kTextStyleH3.copyWith(
                                    fontSize: 15.0), // Adjusted font size
                              ),
                            ],
                          ),
                        ),
                        progressColor: secondaryColor,
                        backgroundColor: Colors.white,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(kMainPadding),
          child: Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.magnifyingGlass,
                color: primaryColor,
                size: 35.0,
              ),
              const SizedBox(
                width: kSmallSpacerValue,
              ),
              Expanded(
                child: SearchField(
                  controller: searchController,
                  itemHeight: 60.0,
                  suggestions: getSearchSuggestions(),
                  searchInputDecoration: kSearchInputDecoration,
                  hint: 'Søg efter klub/bar',
                  onSuggestionTap: (value) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    searchController.clear();
                    Provider.of<GlobalProvider>(context, listen: false)
                        .nightMapController
                        .move(LatLng(value.item.lat, value.item.lon),
                        kCloseMapZoom);
                  },
                ),
              ),
            ],
          ),
        ),
        const Expanded(
          child: NightMap(),
        ),
      ],
    );
  }
}