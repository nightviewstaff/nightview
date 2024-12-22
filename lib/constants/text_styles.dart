import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';

const kTextStyleH1 = TextStyle(
  fontSize: 36.0,
  fontWeight: FontWeight.w800,
  color: Colors.white,
);

const kTextStyleH2 = TextStyle(
  fontSize: 24.0,
  fontWeight: FontWeight.w600,
  color: Colors.white,
);

const kTextStyleH3 = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.w600,
  color: Colors.white,
);

const kTextStyleH3ToP1 = TextStyle(
  fontSize: 15.0,
  fontWeight: FontWeight.w600,
  color: Colors.white,
);

const kTextStyleP1 = TextStyle(
  fontSize: 14.0,
  color: Colors.white,
);

const kTextStyleP2 = TextStyle(
  fontSize: 12.0,
  color: Colors.white,
);

const kTextStyleP3 = TextStyle(
  fontSize: 10.0,
  color: Colors.white,
);

// TODO make a cool style with white and NV-Green combined.

// const kTextStyleLocation = TextStyle(
//   fontSize: 8.0,
//   color: primaryColor,
// );

const kTextStyleSwipeH2 = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: white,
  shadows: [
    Shadow(
      offset: Offset(-1, -1), // Top-left shadow
      blurRadius: 0,
      color: black,
    ),
    Shadow(
      offset: Offset(1, -1), // Top-right shadow
      blurRadius: 0,
      color: black,
    ),
    Shadow(
      offset: Offset(1, 1), // Bottom-right shadow
      blurRadius: 0,
      color: black,
    ),
    Shadow(
      offset: Offset(-1, 1), // Bottom-left shadow
      blurRadius: 0,
      color: black,
    ),
  ],
);

const kTextStyleSwipeH1 = TextStyle(
  fontSize: 44.0,
  fontWeight: FontWeight.w800,
  color: Colors.white, // Text color
  shadows: [
    // Multiple shadows for a thicker outline
    Shadow(
      offset: Offset(-2, -2), // Top-left
      blurRadius: 0,
      color: primaryColor,
    ),
    Shadow(
      offset: Offset(2, -2), // Top-right
      blurRadius: 0,
      color: primaryColor,
    ),
    Shadow(
      offset: Offset(-2, 2), // Bottom-left
      blurRadius: 0,
      color: primaryColor,
    ),
    Shadow(
      offset: Offset(2, 2), // Bottom-right
      blurRadius: 0,
      color: primaryColor,
    ),
    Shadow(
      offset: Offset(0, -3), // Top-center
      blurRadius: 0,
      color: primaryColor,
    ),
    Shadow(
      offset: Offset(0, 3), // Bottom-center
      blurRadius: 0,
      color: primaryColor,
    ),
    Shadow(
      offset: Offset(-3, 0), // Center-left
      blurRadius: 0,
      color: primaryColor,
    ),
    Shadow(
      offset: Offset(3, 0), // Center-right
      blurRadius: 0,
      color: primaryColor,
    ),
  ],
);

