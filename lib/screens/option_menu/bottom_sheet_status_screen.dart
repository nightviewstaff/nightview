import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:provider/provider.dart';

class BottomSheetStatusScreen extends StatelessWidget {
  const BottomSheetStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: black,
      height: 200.0,
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: Text('Skal i byen i aften'),
              leading: FaIcon(
                FontAwesomeIcons.solidCircleDot,
                color: primaryColor,
              ),
              onTap: () {
                Provider.of<GlobalProvider>(context, listen: false)
                    .setPartyStatusLocal(PartyStatus.yes);
                Provider.of<GlobalProvider>(context, listen: false)
                    .userDataHelper
                    .setCurrentUsersPartyStatus(status: PartyStatus.yes);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text('Skal ikke i byen i aften'),
              leading: FaIcon(
                FontAwesomeIcons.solidCircleDot,
                color: redAccent,
              ),
              onTap: () {
                Provider.of<GlobalProvider>(context, listen: false)
                    .setPartyStatusLocal(PartyStatus.no);
                Provider.of<GlobalProvider>(context, listen: false)
                    .userDataHelper
                    .setCurrentUsersPartyStatus(status: PartyStatus.no);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text('Usikker'),
              leading: FaIcon(
                FontAwesomeIcons.solidCircleDot,
                color: grey,
              ),
              onTap: () {
                Provider.of<GlobalProvider>(context, listen: false)
                    .setPartyStatusLocal(PartyStatus.unsure);
                Provider.of<GlobalProvider>(context, listen: false)
                    .userDataHelper
                    .setCurrentUsersPartyStatus(status: PartyStatus.unsure);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
