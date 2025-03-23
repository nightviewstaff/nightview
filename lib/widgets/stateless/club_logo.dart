// import 'package:flutter/material.dart';
// import 'package:nightview/models/clubs/club_data.dart';

// class ClubLogo extends StatelessWidget {
//   final ClubData club;
//   final String? imageUrl; // URL of the club logo
//   final Widget? fallbackWidget; // Widget to show if image fails or is absent
//   final Color backgroundColor; // Background color of the container
//   final Border? border; // Custom border (default: white, width 3)
//   final double borderRadius; // Corner radius (default: 22.0)
//   final double width; // Widget width
//   final double height; // Widget height
//   final EdgeInsets padding; // Padding inside the container
//   final BoxFit imageFit; // How the image fits (default: cover)
//   final Alignment imageAlignment; // Image alignment (default: center)
//   final String? text; // Optional text to display
//   final TextStyle? textStyle; // Style for the text
//   final bool showText; // Whether to show text (default: false)
//   final VoidCallback? onTap; // Optional tap callback

//   const ClubLogo(ClubData club, {
//     super.key,
//     this.imageUrl,
//     this.fallbackWidget,
//     this.backgroundColor = Colors.black,
//     this.border,
//     this.borderRadius = 22.0,
//     this.width = 50.0,
//     this.height = 50.0,
//     this.padding = const EdgeInsets.symmetric(vertical: 14.0, horizontal: 15.0),
//     this.imageFit = BoxFit.cover,
//     this.imageAlignment = Alignment.center,
//     this.text,
//     this.textStyle,
//     this.showText = false,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: width,
//         height: height,
//         padding: padding,
//         decoration: BoxDecoration(
//           color: backgroundColor,
//           border: border ?? Border.all(color: Colors.white, width: 3),
//           borderRadius: BorderRadius.circular(borderRadius),
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(borderRadius),
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               // Display image if URL is provided
//               if (imageUrl != null)
//                 Image.network(
//                   imageUrl!,
//                   fit: imageFit,
//                   alignment: imageAlignment,
//                   width: width,
//                   height: height,
//                   errorBuilder: (context, error, stackTrace) {
//                     return fallbackWidget ??
//                         const Icon(
//                           Icons.error,
//                           color: Colors.redAccent,
//                         );
//                   },
//                 )
//               // Display fallback if no image URL
//               else
//                 fallbackWidget ??
//                     const Icon(
//                       Icons.image_not_supported,
//                       color: sec,
//                     ),
//               // Display text overlay if enabled
//               if (showText && text != null)
//                 Center(
//                   child: Text(
//                     text!,
//                     style: textStyle ??
//                         const TextStyle(
//                           color: grey,
//                           fontSize: 14.0,
//                           fontWeight: FontWeight.w600,
//                         ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
