import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nightview/api/firebase_api.dart';
import 'package:nightview/firebase_options.dart';
import 'package:nightview/firestore/firestore_updater.dart';
import 'package:nightview/models/chat_subscriber.dart';
import 'package:nightview/models/search_new_chat_helper.dart';
import 'package:nightview/models/search_friends_helper.dart';
import 'package:nightview/providers/balladefabrikken_provider.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/providers/login_registration_provider.dart';
import 'package:nightview/providers/main_navigation_provider.dart';
import 'package:nightview/screens/balladefabrikken/balladefabrikken_main_screen.dart';
import 'package:nightview/screens/balladefabrikken/shot_accumulation_screen.dart';
import 'package:nightview/screens/balladefabrikken/shot_redemption_screen.dart';
import 'package:nightview/screens/location_permission/location_permission_always_screen.dart';
import 'package:nightview/screens/location_permission/location_permission_whileinuse_screen.dart';
import 'package:nightview/screens/location_permission/location_permission_checker_screen.dart';
import 'package:nightview/screens/location_permission/location_permission_precise_screen.dart';
import 'package:nightview/screens/location_permission/location_permission_service_screen.dart';
import 'package:nightview/screens/login_registration/login_main_screen.dart';
import 'package:nightview/screens/login_registration/login_registration_option_screen.dart';
import 'package:nightview/screens/login_registration/registration_age_screen.dart';
import 'package:nightview/screens/login_registration/registration_authentication_screen.dart';
import 'package:nightview/screens/login_registration/registration_confirmation_screen.dart';
import 'package:nightview/screens/login_registration/registration_name_screen.dart';
import 'package:nightview/screens/login_registration/registration_password_screen.dart';
import 'package:nightview/screens/login_registration/registration_welcome_screen.dart';
import 'package:nightview/screens/main_screen.dart';
import 'package:nightview/screens/night_social/new_chat_screen.dart';
import 'package:nightview/screens/profile/my_profile_main_screen.dart';
import 'package:nightview/screens/night_map/night_map_main_offer_screen.dart';
import 'package:nightview/screens/night_social/find_new_friends_screen.dart';
import 'package:nightview/screens/night_social/friend_requests_screen.dart';
import 'package:nightview/screens/night_social/night_social_conversation_screen.dart';
import 'package:nightview/screens/preferences/preferences_main_screen.dart';
import 'package:nightview/screens/profile/other_profile_main_screen.dart';
import 'package:nightview/screens/swipe/swipe_main_screen.dart';
import 'package:nightview/screens/utility/waiting_for_login_screen.dart';
import 'package:provider/provider.dart';

import 'constants/Initializator.dart';
import 'constants/colors.dart';
import 'firestore/add_club.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await FirebaseApi().initNotifications();

  // FirestoreUpdater firestoreUpdater = FirestoreUpdater();
  // firestoreUpdater.updateFirestoreData(); // Updates Firestore.

  Initializator initializator = Initializator(); // Rename
  initializator.initializeNeededTasks();

   // AddClub addClub = AddClub(); addClub.addSpecificClub1(); // To add each new club manually.

  runApp(NightViewApp());

  // NotificationService().showNotification();
}


class NightViewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
        return MultiProvider(
      providers: [
        ChangeNotifierProvider<GlobalProvider>(
          create: (_) => GlobalProvider(), // When is an instance created?
        ),
        ChangeNotifierProvider<MainNavigationProvider>(
          create: (_) => MainNavigationProvider(),
        ),
        ChangeNotifierProvider<LoginRegistrationProvider>(
          create: (_) => LoginRegistrationProvider(),
        ),
        ChangeNotifierProvider<SearchFriendsHelper>(
          create: (_) => SearchFriendsHelper(),
        ),
        ChangeNotifierProvider<SearchNewChatHelper>(
          create: (_) => SearchNewChatHelper(),
        ),
        ChangeNotifierProvider<ChatSubscriber>(
          create: (_) => ChatSubscriber(),
        ),
        ChangeNotifierProvider<BalladefabrikkenProvider>(
          create: (_) => BalladefabrikkenProvider(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: black,
          appBarTheme: AppBarTheme(
            color: black,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: black,
            showUnselectedLabels: false,
          ),
        ),
        initialRoute:
        WaitingForLoginScreen.id,
         // SwipeMainScreen.id, // TEST swipescreen
        routes: {
          LoginMainScreen.id: (context) => const LoginMainScreen(),
          LoginRegistrationOptionScreen.id: (context) => const LoginRegistrationOptionScreen(),
          RegistrationAgeScreen.id: (context) => const RegistrationAgeScreen(),
          RegistrationAuthenticationScreen.id: (context) => const RegistrationAuthenticationScreen(),
          RegistrationConfirmationScreen.id: (context) => const RegistrationConfirmationScreen(),
          RegistrationNameScreen.id: (context) => const RegistrationNameScreen(),
          RegistrationPasswordScreen.id: (context) => const RegistrationPasswordScreen(),
          RegistrationWelcomeScreen.id: (context) => const RegistrationWelcomeScreen(),
          MyProfileMainScreen.id: (context) => const MyProfileMainScreen(),
          NightSocialConversationScreen.id: (context) => const NightSocialConversationScreen(),
          MainScreen.id: (context) => const MainScreen(),
          PreferencesMainScreen.id: (context) => const PreferencesMainScreen(),
          SwipeMainScreen.id: (context) => const SwipeMainScreen(),
          WaitingForLoginScreen.id: (context) => const WaitingForLoginScreen(),
          NightMapMainOfferScreen.id: (context) => const NightMapMainOfferScreen(),
          LocationPermissionWhileInUseScreen.id: (context) => const LocationPermissionWhileInUseScreen(),
          LocationPermissionAlwaysScreen.id: (context) => const LocationPermissionAlwaysScreen(),
          LocationPermissionPreciseScreen.id: (context) => const LocationPermissionPreciseScreen(),
          LocationPermissionServiceScreen.id: (context) => const LocationPermissionServiceScreen(),
          LocationPermissionCheckerScreen.id: (context) => const LocationPermissionCheckerScreen(),
          FriendRequestsScreen.id: (context) => const FriendRequestsScreen(),
          FindNewFriendsScreen.id: (context) => const FindNewFriendsScreen(),
          OtherProfileMainScreen.id: (context) => const OtherProfileMainScreen(),
          NewChatScreen.id: (context) => const NewChatScreen(),
          BalladefabrikkenMainScreen.id: (context) => const BalladefabrikkenMainScreen(),
          ShotAccumulationScreen.id: (context) => const ShotAccumulationScreen(),
          ShotRedemtionScreen.id: (context) => const ShotRedemtionScreen(),
        },
      ),
    );
  }

}
