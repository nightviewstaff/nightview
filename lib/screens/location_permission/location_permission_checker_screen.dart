import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/helpers/users/misc/location_helper.dart';
import 'package:nightview/models/users/user_data.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/providers/night_map_provider.dart';
import 'package:nightview/screens/location_permission/location_permission_always_screen.dart';
import 'package:nightview/screens/location_permission/location_permission_whileinuse_screen.dart';
import 'package:nightview/screens/location_permission/location_permission_precise_screen.dart';
import 'package:nightview/screens/location_permission/location_permission_service_screen.dart';
import 'package:nightview/screens/main_screen.dart';
import 'package:nightview/screens/swipe/swipe_main_screen.dart';
import 'package:provider/provider.dart';

class LocationPermissionCheckerScreen extends StatefulWidget {
  static const id = 'location_permission_checker_screen';

  const LocationPermissionCheckerScreen({super.key});

  @override
  State<LocationPermissionCheckerScreen> createState() =>
      _LocationPermissionCheckerScreenState();
}

class _LocationPermissionCheckerScreenState
    extends State<LocationPermissionCheckerScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      LocationHelper locationHelper =
          Provider.of<NightMapProvider>(context, listen: false).locationHelper;

      if (backgroundLocationEnabled) {
        // Opt out not implemented
        if (Platform.isAndroid) {
          if (await locationHelper.serviceEnabled) {
            if (await locationHelper.hasPermissionAlways || Provider
                .of<GlobalProvider>(context, listen: false)
                .locationOptOut) {
              if (await locationHelper.hasPermissionPrecise || Provider
                  .of<GlobalProvider>(context, listen: false)
                  .locationOptOut) {
                if (!Provider
                    .of<GlobalProvider>(context, listen: false)
                    .locationOptOut) {
                  // await locationHelper.activateBackgroundLocation();
                  locationHelper.startLocationService();
                }
                UserData? currentUserData;
                do {
                  currentUserData = Provider
                      .of<GlobalProvider>(context, listen: false)
                      .userDataHelper
                      .currentUserData;
                  await Future.delayed(Duration(milliseconds: 100));
                } while (currentUserData == null);

                currentUserData.answeredStatusToday()
                    ? Navigator.of(context).pushReplacementNamed(MainScreen.id)
                    : Navigator.of(context).pushReplacementNamed(SwipeMainScreen.id);
              } else {
                Navigator.of(context).pushReplacementNamed(LocationPermissionPreciseScreen.id);
              }
            } else {
              Navigator.of(context).pushReplacementNamed(LocationPermissionAlwaysScreen.id);
            }
          } else {
            Navigator.of(context).pushReplacementNamed(LocationPermissionServiceScreen.id);
          }
        }

        if (Platform.isIOS) {
          if (await locationHelper.serviceEnabled) {
            if (await locationHelper.hasPermissionWhileInUse) {
              if (await locationHelper.hasPermissionPrecise) {
                // await locationHelper.activateBackgroundLocation();
                // locationHelper.startBackgroundLocationService();
                UserData? currentUserData;
                do {
                  currentUserData = Provider
                      .of<GlobalProvider>(context, listen: false)
                      .userDataHelper
                      .currentUserData;
                  await Future.delayed(Duration(milliseconds: 100));
                } while (currentUserData == null);

                currentUserData.answeredStatusToday()
                    ? Navigator.of(context).pushReplacementNamed(MainScreen.id)
                    : Navigator.of(context).pushReplacementNamed(SwipeMainScreen.id);
              } else {
                Navigator.of(context).pushReplacementNamed(LocationPermissionPreciseScreen.id);
              }
            } else {
              Navigator.of(context).pushReplacementNamed(LocationPermissionWhileInUseScreen.id);
            }
          } else {
            Navigator.of(context).pushReplacementNamed(LocationPermissionServiceScreen.id);
          }
        }
      } else { // backgroundLocationEnabled = false
        locationHelper.startLocationService();
        UserData? currentUserData;
        do {
          currentUserData = Provider
              .of<GlobalProvider>(context, listen: false)
              .userDataHelper
              .currentUserData;
          await Future.delayed(Duration(milliseconds: 100));
        } while (currentUserData == null);

        currentUserData.answeredStatusToday()
            ? Navigator.of(context).pushReplacementNamed(MainScreen.id)
            : Navigator.of(context).pushReplacementNamed(SwipeMainScreen.id);
      }


    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SpinKitPouringHourGlass(
            color: primaryColor,
            size: 150.0,
            strokeWidth: 2.0,
          ),
        ),
      ),
    );
  }
}
