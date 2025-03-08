import 'dart:io' show Platform;
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';

class TrackingInitializer extends StatefulWidget {
  final Widget child;

  const TrackingInitializer({Key? key, required this.child}) : super(key: key);

  @override
  _TrackingInitializerState createState() => _TrackingInitializerState();
}

class _TrackingInitializerState extends State<TrackingInitializer> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized && Platform.isIOS) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initAppTrackingTransparency();
      });
    }
  }

  Future<void> _initAppTrackingTransparency() async {
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      // Directly request the system prompt without a custom dialog.
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
