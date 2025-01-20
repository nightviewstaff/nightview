import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/screens/location_permission/location_permission_checker_screen.dart';
import 'package:nightview/widgets/stateless/login_registration_button.dart';
import 'package:nightview/widgets/stateless/login_registration_layout.dart';
import 'package:provider/provider.dart';

class LocationPermissionAlwaysScreen extends StatefulWidget {
  static const id = 'location_permission_always_screen';

  const LocationPermissionAlwaysScreen({super.key});

  @override
  State<LocationPermissionAlwaysScreen> createState() =>
      _LocationPermissionAlwaysScreen();
}

class _LocationPermissionAlwaysScreen
    extends State<LocationPermissionAlwaysScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<GlobalProvider>(context, listen: false)
          .locationHelper
          .requestLocationPermission();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        checkPermission();
      });
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

  Future<void> checkPermission() async {
    bool hasPermission = await Provider.of<GlobalProvider>(context, listen: false)
    .locationHelper
    .requestLocationPermission();

    if(hasPermission){
      Navigator.of(context).pushReplacementNamed(LocationPermissionCheckerScreen.id);
    }

  }

  @override
  Widget build(BuildContext context) {
    return LoginRegistrationLayout(
      title: Text(
        'Tillad lokation altid',
        textAlign: TextAlign.center,
        style: kTextStyleH1,
      ),
      content: Column(
        children: [
          Text(
            'For at få den bedste oplevelse på NightView, er det nødvendigt at appen altid har adgang til din lokation.',
            textAlign: TextAlign.center,
            style: kTextStyleP1,
          ),
          SizedBox(
            height: kNormalSpacerValue,
          ),
          Text(
            guideText,
            textAlign: TextAlign.left,
            style: kTextStyleH3,
          ),
          SizedBox(
            height: kNormalSpacerValue,
          ),
          LoginRegistrationButton(
            text: buttonText,
            type: LoginRegistrationButtonType.filled,
            onPressed: () {
              Provider.of<GlobalProvider>(context, listen: false)
                  .locationHelper
                  .openAppSettings();
            },
          ),
          // TextButton(
          //   onPressed: () {},
          //   child: Text(
          //     'Vælg fra',
          //     style: TextStyle(color: Colors.grey),
          //   ),
          // )
        ],
      ),
    );
  }

  String get buttonText {
    // KAN KUN VÆRE ANDROID

    if (Platform.isAndroid) {
      return 'Åbn app-indstillinger';
    }

    if (Platform.isIOS) {
      return 'Åbn app-indstillinger';
    }

    return 'IKKE GYLDIGT STYRESYSTEM';
  }

  String get guideText {
    // KAN KUN VÆRE ANDROID

    if (Platform.isAndroid) {
      return '> Åbn app-indstillinger\n> Tilladelser\n> Lokation\n> Tillad altid';
    }

    if (Platform.isIOS) {
      return '> Åbn app-indstillinger\n> Lokalitet\n> Ved brug af appen';
    }

    return 'IKKE GYLDIGT STYRESYSTEM';
  }
}
