import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nightview/app_localization.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/providers/night_map_provider.dart';
import 'package:nightview/screens/location_permission/location_permission_checker_screen.dart';
import 'package:nightview/widgets/stateless/login_registration_button.dart';
import 'package:nightview/widgets/stateless/login_registration_layout.dart';
import 'package:provider/provider.dart';

class LocationPermissionPreciseScreen extends StatefulWidget {
  static const id = 'location_permission_precise_screen';

  const LocationPermissionPreciseScreen({super.key});

  @override
  State<LocationPermissionPreciseScreen> createState() =>
      _LocationPermissionPreciseScreenState();
}

class _LocationPermissionPreciseScreenState
    extends State<LocationPermissionPreciseScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
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
        .hasPermissionPrecise
        .then((hasPermission) async {
      if (hasPermission) {
        Navigator.of(context)
            .pushReplacementNamed(LocationPermissionCheckerScreen.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoginRegistrationLayout(
      title: Text(
        // AppLocalizations.of(context)!.allowExcactLocation,
        'Tillad præcis lokation',
        textAlign: TextAlign.center,
        style: kTextStyleH1,
      ),
      content: Column(
        children: [
          Text(
            // AppLocalizations.of(context)!.locationNessearyMessage,
            'For at levere den bedste oplevelse for NightViews brugere, er det nødvendigt at appen har adgang til telefonens præcise position.',
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
              Provider.of<NightMapProvider>(context, listen: false)
                  .locationHelper
                  .openAppSettings();
            },
          ),
        ],
      ),
    );
  }

  String get buttonText {
    // KAN KUN VÆRE ANDROID

    if (Platform.isAndroid) {
      return
          // AppLocalizations.of(context)!.openAppSettings,
          'Åbn app-indstillinger';
    }

    if (Platform.isIOS) {
      return
          // AppLocalizations.of(context)!.openAppSettings,
          'Åbn app-indstillinger';
    }

    return
        // AppLocalizations.of(context)!.notValidOS
        'IKKE GYLDIGT STYRESYSTEM';
  }

  String get guideText {
    // KAN KUN VÆRE ANDROID

    if (Platform.isAndroid) {
      return
          // AppLocalizations.of(context)!.appSettingsAllowLocationAlways,
          '> Åbn app-indstillinger\n> Tilladelser\n> Placering\n> Tillad altid';
    }

    if (Platform.isIOS) {
      // AppLocalizations.of(context)!.appSettingsAllowLocationInUse,
      return '> Åbn app-indstillinger\n> Lokalitet\n> Ved brug af appen';
    }

// AppLocalizations.of(context)!.notValidOS,
    return 'IKKE GYLDIGT STYRESYSTEM';
  }
}
