import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nightview/constants/colors.dart';

class HourGlassLoadingScreen extends StatelessWidget {
  final Color color;
  final double size;
  final double strokeWidth;

  const HourGlassLoadingScreen({
    super.key,
    this.color = primaryColor,
    this.size = 150.0,
    this.strokeWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) { // TODO
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SpinKitPouringHourGlass(
            color: color,
            size: size,
            strokeWidth: strokeWidth,
          ),
        ),
      ),
    );
  }
}
