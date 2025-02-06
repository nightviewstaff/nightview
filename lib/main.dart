import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nightview/firebase_options.dart';
import 'package:nightview/helpers/clubs/club_data_helper.dart';
import 'package:nightview/helpers/users/chats/chat_subscriber.dart';
import 'package:nightview/helpers/users/chats/search_new_chat_helper.dart';
import 'package:nightview/helpers/users/friends/search_friends_helper.dart';
import 'package:nightview/providers/balladefabrikken_provider.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/providers/login_registration_provider.dart';
import 'package:nightview/providers/main_navigation_provider.dart';
import 'package:nightview/providers/night_map_provider.dart';
import 'package:nightview/screens/balladefabrikken/balladefabrikken_main_screen.dart';
import 'package:nightview/screens/balladefabrikken/shot_accumulation_screen.dart';
import 'package:nightview/screens/balladefabrikken/shot_redemption_screen.dart';
import 'package:nightview/screens/location_permission/location_permission_always_screen.dart';
import 'package:nightview/screens/location_permission/location_permission_whileinuse_screen.dart';
import 'package:nightview/screens/location_permission/location_permission_checker_screen.dart';
import 'package:nightview/screens/location_permission/location_permission_precise_screen.dart';
import 'package:nightview/screens/location_permission/location_permission_service_screen.dart';
import 'package:nightview/screens/login_registration/login/login_google_screen.dart';
import 'package:nightview/screens/login_registration/login/login_nightview_screen.dart';
import 'package:nightview/screens/login_registration/choice/login_or_create_account_screen.dart';
import 'package:nightview/screens/login_registration/creation/create_account_screen_two_contact.dart';
import 'package:nightview/screens/login_registration/todo/registration_confirmation_screen.dart';
import 'package:nightview/screens/login_registration/creation/create_account_screen_one_personal.dart';
import 'package:nightview/screens/login_registration/creation/create_account_screen_three_password.dart';
import 'package:nightview/screens/main_screen.dart';
import 'package:nightview/screens/night_social/new_chat_screen.dart';
import 'package:nightview/screens/profile/my_profile_main_screen.dart';
import 'package:nightview/screens/night_map/night_map_main_offer_screen.dart';
import 'package:nightview/screens/night_social/find_new_friends_screen.dart';
import 'package:nightview/screens/night_social/friend_requests_screen.dart';
import 'package:nightview/screens/night_social/night_social_conversation_screen.dart';

// import 'package:nightview/screens/preferences/preferences_main_screen.dart';
import 'package:nightview/screens/profile/other_profile_main_screen.dart';
import 'package:nightview/screens/swipe/swipe_main_screen.dart';
import 'package:nightview/screens/utility/waiting_for_login_screen.dart';
import 'package:provider/provider.dart';

import 'constants/Initializator.dart';
import 'constants/colors.dart';
import 'never_used/preferences/preferences_main_screen.dart';
import 'services/firestore/add_club.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // final notificationManager = NotificationManager();
  // await notificationManager.initLocalNotifications();
  // notificationManager.scheduleWeeklyNotifications();

  // FirestoreUpdater firestoreUpdater = FirestoreUpdater();
  // firestoreUpdater.updateFirestoreData(); // Updates Firestore.

  Initializator initializator = Initializator(); // Rename
  initializator.initializeNeededTasks();

  AddClub addClub = AddClub();
  // addClub.addSpecificClub122(); // To add each new club manually.
  // addClub.addSpecificClub123(); // To add each new club manually.
  // addClub.addSpecificClub124(); // To add each new club manually.
  // addClub.addSpecificClub125(); // To add each new club manually.
  // addClub.addSpecificClub126(); // To add each new club manually.
  // addClub.addSpecificClub127(); // To add each new club manually.
  // addClub.addSpecificClub128(); // To add each new club manually.
  // addClub.addSpecificClub129(); // To add each new club manually.
  // addClub.addSpecificClub130(); // To add each new club manually.
  // addClub.addSpecificClub131(); // To add each new club manually.

  // NotificationService().showNotification();
  // await FMTC.instance('mapCache').manage.createAsync();


  runApp(NightViewApp());
}

class NightViewApp extends StatefulWidget {
  const NightViewApp({super.key});

  @override
  State<NightViewApp> createState() => _NightViewAppState();
}

class _NightViewAppState extends State<NightViewApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initAppTrackingTransparency();
    });
  }

  Future<void> _initAppTrackingTransparency() async {
    // IOS needs to b moved TODO
    // Ensure tracking authorization is requested properly
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
          title: const Text('Location tracking'),
          content: const Text(
            'We use your location data to improve the app for you and others.'
            'You can opt out at any time in your device settings.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NightMapProvider>(
          create: (_) => NightMapProvider(),
        ),ChangeNotifierProvider<GlobalProvider>(
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
        initialRoute: WaitingForLoginScreen.id,
        // SwipeMainScreen.id, // TEST swipescreen
        routes: {
          LoginScreen.id: (context) => const LoginScreen(),
          LoginOrCreateAccountScreen.id: (context) =>
              const LoginOrCreateAccountScreen(),

          LoginGoogleScreen.id: (context) => const LoginGoogleScreen(),

          CreateAccountScreenTwoContact.id: (context) =>
              const CreateAccountScreenTwoContact(),
          RegistrationConfirmationScreen.id: (context) =>
              const RegistrationConfirmationScreen(),
          CreateAccountScreenOnePersonal.id: (context) =>
              const CreateAccountScreenOnePersonal(),
          CreateAccountScreenThreePassword.id: (context) =>
              const CreateAccountScreenThreePassword(),
          MyProfileMainScreen.id: (context) => const MyProfileMainScreen(),
          NightSocialConversationScreen.id: (context) =>
              const NightSocialConversationScreen(),
          MainScreen.id: (context) => const MainScreen(),
          PreferencesMainScreen.id: (context) => const PreferencesMainScreen(),
          // NUserd
          SwipeMainScreen.id: (context) => const SwipeMainScreen(),
          WaitingForLoginScreen.id: (context) => const WaitingForLoginScreen(),
          NightMapMainOfferScreen.id: (context) =>
              const NightMapMainOfferScreen(),
          LocationPermissionWhileInUseScreen.id: (context) =>
              const LocationPermissionWhileInUseScreen(),
          LocationPermissionAlwaysScreen.id: (context) =>
              const LocationPermissionAlwaysScreen(),
          LocationPermissionPreciseScreen.id: (context) =>
              const LocationPermissionPreciseScreen(),
          LocationPermissionServiceScreen.id: (context) =>
              const LocationPermissionServiceScreen(),
          LocationPermissionCheckerScreen.id: (context) =>
              const LocationPermissionCheckerScreen(),
          FriendRequestsScreen.id: (context) => const FriendRequestsScreen(),
          FindNewFriendsScreen.id: (context) => const FindNewFriendsScreen(),
          OtherProfileMainScreen.id: (context) =>
              const OtherProfileMainScreen(),
          NewChatScreen.id: (context) => const NewChatScreen(),
          BalladefabrikkenMainScreen.id: (context) =>
              const BalladefabrikkenMainScreen(),
          ShotAccumulationScreen.id: (context) =>
              const ShotAccumulationScreen(),
          ShotRedemtionScreen.id: (context) => const ShotRedemtionScreen(),
        },
      ),
    );
  }
}
