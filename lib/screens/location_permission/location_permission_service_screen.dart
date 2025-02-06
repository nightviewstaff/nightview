import 'package:flutter/material.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/providers/night_map_provider.dart';
import 'package:nightview/screens/location_permission/location_permission_checker_screen.dart';
import 'package:nightview/widgets/stateless/login_registration_button.dart';
import 'package:nightview/widgets/stateless/login_registration_layout.dart';
import 'package:provider/provider.dart';

class LocationPermissionServiceScreen extends StatefulWidget {
  static const id = 'location_permission_service_screen';

  const LocationPermissionServiceScreen({super.key});

  @override
  State<LocationPermissionServiceScreen> createState() =>
      _LocationPermissionServiceScreenState();
}

class _LocationPermissionServiceScreenState
    extends State<LocationPermissionServiceScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<NightMapProvider>(context, listen: false)
          .locationHelper
          .requestLocationPermission();

      checkPermission();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      checkPermission();
    }
  }

  void checkPermission() {
    Provider.of<NightMapProvider>(context, listen: false)
        .locationHelper
        .serviceEnabled
        .then((hasPermission) {
      if (hasPermission) {
        Navigator.of(context).pushReplacementNamed(LocationPermissionCheckerScreen.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoginRegistrationLayout(
      title: Text(
        'Slå lokation til',
        textAlign: TextAlign.center,
        style: kTextStyleH1,
      ),
      content: Column(
        children: [
          Text(
            'For at du kan bruge NightView, er du nødt til at slå lokationstjenesten til.',
            textAlign: TextAlign.center,
            style: kTextStyleP1,
          ),
          SizedBox(
            height: kNormalSpacerValue,
          ),
          LoginRegistrationButton(
            text: 'Refresh',
            type: LoginRegistrationButtonType.filled,
            onPressed: () {
              checkPermission();
            },
          ),
        ],
      ),
    );
  }
}
