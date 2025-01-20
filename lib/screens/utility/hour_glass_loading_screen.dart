import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  final Color color;
  final double size;
  final double strokeWidth;

  const LoadingScreen({
    Key? key,
    required this.color,
    this.size = 150.0,
    this.strokeWidth = 2.0,
  }) : super(key: key);

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
