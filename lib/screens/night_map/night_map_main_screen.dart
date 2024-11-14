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

class NightMapMainScreen extends StatefulWidget {
  static const id = 'night_map_main_screen';

  const NightMapMainScreen({super.key});

  @override
  State<NightMapMainScreen> createState() => _NightMapMainScreenState();
}

class _NightMapMainScreenState extends State<NightMapMainScreen> {
  final searchController = TextEditingController();

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
    return amount / fullAmount;
  }

  int getPercentValue({required int amount, required int fullAmount}) {
    return (amount / fullAmount * 100).round();
  }

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
                'Antal brugere i byen',
                style: kTextStyleH3,
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(kSubtleBorderRadius),
                      ),
                      border: Border.all(
                        color: Colors.white,
                        width: kMainStrokeWidth,
                      ),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: kMainPadding),
                      child: Text(
                        Provider.of<GlobalProvider>(context)
                            .partyCount
                            .toString(),
                        style: kTextStyleH3,
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   width: kNormalSpacerValue,
                  // ),
                  // CircularPercentIndicator(
                  //   radius: 25.0,
                  //   percent: getDecimalValue(
                  //     amount: Provider.of<GlobalProvider>(context).partyCount,
                  //     fullAmount: Provider.of<GlobalProvider>(context)
                  //         .userDataHelper
                  //         .userCount,
                  //   ),
                  //   center: Text('${getPercentValue(
                  //     amount: Provider.of<GlobalProvider>(context).partyCount,
                  //     fullAmount: Provider.of<GlobalProvider>(context)
                  //         .userDataHelper
                  //         .userCount,
                  //   )}%'),
                  //   progressColor: primaryColor,
                  //   backgroundColor: Colors.white,
                  // ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(kMainPadding),
          child: Row(
            children: [
              FaIcon(
                FontAwesomeIcons.magnifyingGlass,
                color: primaryColor,
                size: 35.0,
              ),
              SizedBox(
                width: kSmallSpacerValue,
              ),
              Expanded(
                child: SearchField(
                  controller: searchController,
                  itemHeight: 60.0,
                  suggestions: getSearchSuggestions(),
                  searchInputDecoration: kSearchInputDecoration, //TODO be aware/fix of UI here
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
        Expanded(
          child: NightMap(),
        ),
      ],
    );
  }
}
