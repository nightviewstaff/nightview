import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:nightview/constants/colors.dart';
import 'package:nightview/generated/l10n.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/screens/location_permission/location_permission_checker_screen.dart';
import 'package:nightview/screens/login_registration/choice/login_or_create_account_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaitingForLoginScreen extends StatefulWidget {
  static const id = 'waiting_for_login_screen';
  const WaitingForLoginScreen({super.key});
  @override
  State<WaitingForLoginScreen> createState() => _WaitingForLoginScreenState();
}

class _WaitingForLoginScreenState extends State<WaitingForLoginScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // First check app tracking transparency
      await _initAppTrackingTransparency();

      // Then proceed with the login flow
      await _checkLoginStatus();
    });
  }

  Future<void> _initAppTrackingTransparency() async {
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;

    if (status == TrackingStatus.notDetermined) {
      // Show custom explainer dialog
      await _showCustomTrackingDialog();
      // Delay slightly before showing the system dialog
      await Future.delayed(const Duration(milliseconds: 1000));
      // Request tracking authorization
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }

  Future<void> _showCustomTrackingDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
              // AppLocalizations.of(context)!.locationTracking,
              'Location tracking'),
          content: const Text(
            // AppLocalizations.of(context)!.locationTrackingDescription,
            'We use your location data to improve the app for you and others. '
            'You can opt out at any time in your device settings.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(S.of(context).ok),
            ),
          ],
        );
      },
    );
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mail = prefs.getString('mail');
    String? password = prefs.getString('password');

    if (mail == null || password == null) {
      if (mounted) {
        Navigator.of(context)
            .pushReplacementNamed(LoginOrCreateAccountScreen.id);
      }
    } else {
      bool loginSuccess =
          await Provider.of<GlobalProvider>(context, listen: false)
              .userDataHelper
              .loginUser(mail: mail, password: password);

      if (loginSuccess) {
        if (mounted) {
          Navigator.of(context)
              .pushReplacementNamed(LocationPermissionCheckerScreen.id);
        }
      } else {
        if (mounted) {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(// TODO Center
                  // AppLocalizations.of(context)!.logInError),
                  S.of(context).login_error),
              content: SingleChildScrollView(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal:
                            16.0), // Optional: Adds padding for better readability
                    width: double
                        .infinity, // Ensures the container takes full width but centers the text
                    child: Text(
                      S.of(context).login_error_occurred,
                      textAlign: TextAlign
                          .center, // Centers the text within its bounds
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    S.of(context).ok,
                    style: TextStyle(
                      color: redAccent,
                    ),
                  ),
                ),
              ],
            ),
          );
          Navigator.of(context)
              .pushReplacementNamed(LoginOrCreateAccountScreen.id);
        }
      }
    }
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
