// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:nightview/constants/colors.dart';
// import 'package:nightview/constants/text_styles.dart';
// import 'package:nightview/constants/values.dart';
// import 'package:nightview/widgets/stateless/icon_with_text.dart';
// import 'package:appinio_swiper/appinio_swiper.dart';

// class SwipeCardContent extends StatelessWidget {
//   final AppinioSwiperController controller;
//   final String imagePath;

//   SwipeCardContent(
//       {super.key, required this.controller, required this.imagePath});

//   static String getRandomMessage() {
//     Random random = Random();
//     List<String> messages = [
//       "Er du klar til at erobre dansegulvet i nat?",
//       "Har du planer om at tage på eventyr i byen i aften?",
//       "Skal vi ud og lave ballade i nat?",
//       "Bliver det en af de vilde aftener i byen i aften?",
//       "Er det en af de aftener, hvor vi slår os løs?",
//       "Skal vi ud og vise vores bedste moves i aften?",
//       "Er du på vej ud for at gøre byen usikker i nat?",
//       "Jeg kender en rigtig god bartender. Skal vi tage ud og få ham til at lave nogle specielle drinks til os?",
//       "Vil du være min date i aften og lade mig vise dig hvordan man har det sjovt?",
//       "Hvad siger du til at vi spilder ungdommen lidt i aften og ser hvor det bringer os hen?",
//       "Er du klar til at lyse dansegulvet op i aften?",
//       "Har du planer om at skabe minder i byen i nat?",
//       "Er det en af de aftener, hvor vi giver den max gas?",
//       "Skal vi ud og gøre natten vild og uforglemmelig?",
//       "Er du parat til at indtage byen med stil?",
//       "Bliver det en nat med masser af latter og dans?",
//       "Er du klar til at erobre byen og have det sjovt?",
//       "Skal vi ud og gøre natten til vores egen fest?",
//       "Er det en af de aftener, hvor vi slipper alle hæmninger?",
//       "Har du tænkt dig at tage på natteeventyr med os i aften?",
//       "Er det i aften, vi gør gaderne usikre?",
//       "Skal vi ud og skabe feststemning i nat?",
//       "Er du klar til at gøre natten til noget særligt?",
//       "Bliver det en af de aftener, hvor vi lever livet fuldt ud?",
//       "Skal vi ud og feste som aldrig før i nat?",
//       "Er du klar til at indtage nattelivet med os?",
//       "Har du tænkt dig at gøre natten vild og uforglemmelig?",
//       "Er du klar til at gøre dansegulvet til din scene i aften?",
//       "Skal vi ud og få byen til at lyse op i nat?",
//       "Er det i aften, vi går amok på dansegulvet?",
//       "Har du tænkt dig at være festens midtpunkt i nat?",
//       "Er du parat til en nat fyldt med grin og gode vibes?",
//       "Er du klar til at tage byen med storm i aften?",
//       "Er du klar til at skabe vilde minder i nat?",
//       "Er du parat til at gøre natten til en fest uden lige?",
//       "Skal vi ud og fyre den af på dansegulvet?",
//       "Er du klar til at gøre byen usikker med os i nat?",
//       "Har du planer om at tage på eventyr i nattelivet?",
//       "Skal vi ud og erobre nattelivet i aften?",
//       "Skal vi ud og lege rockstjerner i nat?",
//       "Er du klar til at danse, som om vi har to venstre fødder?",
//       "Er det i aften, vi laver nogle episke Snapchat-historier?",
//       "Er du klar til at være byens skøreste festabe i nat?",
//       "Skal vi ud og lave nogle legendariske fejltrin på dansegulvet?",
//       "Skal vi ud og se, hvor mange nye venner vi kan få i nat?",
//       "Er du klar til at tage en tur i festligaen i nat?",
//       "Ud i aften?",
//       "Skal vi?",
//       "Ud og fyre den af?",
//       "Druk?",
//       "Skal vi ud?",
//       "Klubben?",
//       "Er du klar til at skabe ravage i byen i aften?",
//       "Skal vi ud og skabe lidt festlig uro i byen?",
//       "Skal vi ud og ryste byen op?",
//       "Er det tid til at lave noget ballade i nat?",
//       "Bliver du en del af nattelivet i dag?",
//       "Har du planer om at gå ud i aften?",
//       "Er du klar til en bytur i dag?",
//     ];
//     return messages[random.nextInt(messages.length)];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // Background image
//         Container(
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage(imagePath),
//               fit: BoxFit.fitHeight,
//             ),
//             borderRadius: BorderRadius.circular(kMainBorderRadius),
//             border: Border.all(
//               color: primaryColor,
//               width: 1,
//             ),
//           ),
//           width: double.maxFinite,
//         ),
//         // Centered text
//         Positioned(
//           top: 350.0,
//           left: 0,
//           right: 0,
//           child: Center(
//             child: Text(
//               getRandomMessage(),
//               style: kTextStyleSwipeH2.copyWith(),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ),
//         // Bottom controls
//         Positioned(
//           bottom: kSwipeBottomPadding,
//           left: 0,
//           right: 0,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const SizedBox(height: kNormalSpacerValue),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Container(
//                     child: IconWithText(
//                       icon: FontAwesomeIcons.xmark,
//                       text: 'Ikke i dag',
//                       onTap: () {
//                         controller.swipeLeft();
//                       },
//                     ),
//                   ),
//                   IconWithText(
//                     icon: FontAwesomeIcons.solidHeart,
//                     text: 'Ja!',
//                     iconColor: primaryColor,
//                     showCircle: false,
//                     onTap: () {
//                       controller.swipeRight();
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
