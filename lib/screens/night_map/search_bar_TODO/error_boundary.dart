//
// import 'package:flutter/material.dart';
//
// class ErrorBoundary extends StatelessWidget {
//   final Widget child;
//
//   const ErrorBoundary({super.key, required this.child});
//
//   @override
//   Widget build(BuildContext context) {
//     return ErrorWidgetBuilder(builder: (error, stackTrace) { // ErrorWidgB doesnt exist.
//       return Column(
//         children: [
//           Icon(Icons.error, color: Colors.red),
//           Text('Something went wrong'),
//           Text(error.toString()),
//         ],
//       );
//     }).build(context, child);
//   }
// }