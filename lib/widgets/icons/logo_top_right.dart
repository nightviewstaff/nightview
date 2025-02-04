import 'package:flutter/material.dart';

class ImageInsertDefaultTopRight extends StatelessWidget {
  final String imagePath;
  final double top;
  final double left;
  final double right;
  final double width;
  final double height;
  final double borderRadius;

  const ImageInsertDefaultTopRight({
    Key? key,
    this.imagePath = 'images/logo_text.png',
    this.top = 10.0,
    this.left = 0.0,
    this.right = 10.0,
    this.width = 50.0,
    this.height = 50.0,
    this.borderRadius = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left > 0 ? left : null,
      right: right > 0 ? right : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.asset(
          imagePath,
          width: width,
          height: height,
        ),
      ),
    );
  }
}
