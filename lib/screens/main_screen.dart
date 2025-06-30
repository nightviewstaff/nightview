import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_side_sheet/modal_side_sheet.dart';
import 'package:nightview/constants/button_styles.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/constants/icons.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/helpers/users/misc/profile_picture_helper.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/providers/main_navigation_provider.dart';
import 'package:nightview/screens/balladefabrikken/balladefabrikken_main_screen.dart';
import 'package:nightview/screens/login_registration/creation/terms_and_conditions_screen.dart';
import 'package:nightview/screens/night_map/night_map_main_screen.dart';
import 'package:nightview/screens/night_social/night_social_main_screen.dart';
import 'package:nightview/screens/option_menu/side_sheet_main_screen.dart';
import 'package:nightview/widgets/stateless/language_switcher.dart';
import 'package:nightview/widgets/stateless/main_bottom_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  static const id = 'main_screen';

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();

      String? currentUserId;
      do {
        currentUserId = Provider.of<GlobalProvider>(context, listen: false)
            .userDataHelper
            .currentUserId;
        await Future.delayed(Duration(milliseconds: 10));
      } while (currentUserId == null);

      String? pbUrl =
          await ProfilePictureHelper.getProfilePicture(currentUserId);
      Provider.of<GlobalProvider>(context, listen: false)
          .setProfilePicture(pbUrl);

      final bool justCreated = prefs.getBool('justCreatedAccount') ?? false;
      final bool agreedToTerms = prefs.getBool('agreedToTerms') ?? false;
      final bool askedToBeTester = prefs.getBool('askedToBeTester') ?? false;

      if (!agreedToTerms) {
        await showGeneralDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: black,
          pageBuilder: (context, anim1, anim2) {
            return const TermsFullScreenDialog();
          },
        );
      } else if (justCreated) {
        await prefs.remove('justCreatedAccount');
        return;
      } else {
        final gender = await _checkGenderPrompt(currentUserId);
        if (gender != null && !askedToBeTester) {
          prefs.setBool('askedToBeTester', true);
          await _askToBeTester(currentUserId);
        }
      }
    });

    //TODO MAIN OFFER OF THE DAY HERE!
  }

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<MainNavigationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: navigationProvider.currentScreenIndex == 4
            ? nightviewOrange
            : black,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(BalladefabrikkenMainScreen.id);
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: kSmallSpacerValue),
              child: const CircleAvatar(
                backgroundImage: AssetImage('images/bolt_icon.jpg'),
              ),
            ),
          ),
        ),
        title: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 150,
              child: Image.asset('images/logo_text.png'),
            ),
          ],
        ),
        actions: [
          const LanguageSwitcher(),
          const SizedBox(width: 12.0),
          GestureDetector(
            onTap: () {
              showModalSideSheet(
                context: context,
                barrierDismissible: true,
                withCloseControll: false,
                body: const SideSheetMainScreen(),
              );
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(right: kSmallSpacerValue),
                child: CircleAvatar(
                  backgroundImage:
                      context.watch<GlobalProvider>().profilePicture,
                ),
              ),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: IndexedStack(
        index: navigationProvider.currentScreenIndex,
        children: navigationProvider.screens,
      ),
      bottomNavigationBar: MainBottomNavigationBar(),
    );
  }

  Future<String?> _checkGenderPrompt(String userId) async {
    final userDocRef =
        FirebaseFirestore.instance.collection('user_data').doc(userId);
    final userDoc = await userDocRef.get();

    if (!userDoc.exists) return null;

    final data = userDoc.data() ?? {};
    String? gender = data['gender'];

    if (gender == null || gender.isEmpty) {
      _showGenderDialog(userDocRef);
      return null;
    }

    return gender;
  }

  void _showGenderDialog(DocumentReference userDocRef) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kMainBorderRadius),
          side: const BorderSide(color: white, width: kMainStrokeWidth),
        ),
        title: Row(
          children: const [
            Icon(defaultMaleFemaleIcon, color: secondaryColor),
            SizedBox(width: 10),
            Text(
              'Select Your Gender',
              style: TextStyle(color: white),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child: ElevatedButton.icon(
                icon: const Icon(defaultFemaleIcon, color: white),
                label: const Text('Female'),
                onPressed: () async {
                  await userDocRef.update({'gender': 'F'});
                  Navigator.of(context).pop();
                },
                style: kFilledButtonStyle,
              ),
            ),
            const SizedBox(height: 16.0),
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child: ElevatedButton.icon(
                icon: const Icon(defaultMaleIcon, color: white),
                label: const Text('Male'),
                onPressed: () async {
                  await userDocRef.update({'gender': 'M'});
                  Navigator.of(context).pop();
                },
                style: kFilledButtonStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _askToBeTester(String userId) async {
    final String inviteMessage = '🟣 You’ve been selected!\n\n'
        'Join our invite-only Testing Program and get early access to powerful new features — before the public.\n\n'
        'Spots are limited.';

    final testUsersRef = FirebaseFirestore.instance.collection('test_users');
    final existingTester =
        await testUsersRef.where('user_id', isEqualTo: userId).get();

    if (existingTester.docs.isNotEmpty) return; // Already a tester

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kMainBorderRadius),
          side: const BorderSide(color: white, width: kMainStrokeWidth),
        ),
        title: const Text('Become a tester?', style: kTextStyleH2),
        content: Text(
          inviteMessage,
          style: TextStyle(color: white),
        ),
        actions: [
          TextButton(
            child: const Text('No thanks', style: TextStyle(color: white)),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          ElevatedButton(
            child: const Text('Yes!'),
            onPressed: () => Navigator.of(context).pop(true),
            style: kFilledButtonStyle,
          ),
        ],
      ),
    );

    if (result == true) {
      await testUsersRef.add({
        'user_id': userId,
        'started_testing': Timestamp.now(),
        'platform': Theme.of(context).platform == TargetPlatform.iOS
            ? PlatformType.ios
            : PlatformType.android,
      });

      await showDialog(
        context: context,
        barrierDismissible: false, // Prevents closing by tapping outside
        builder: (context) => AlertDialog(
          backgroundColor: black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kMainBorderRadius),
            side: const BorderSide(color: white, width: 1.5),
          ),
          contentPadding: const EdgeInsets.only(
            top: 16,
            right: 16,
            left: 24,
            bottom: 24,
          ),
          content: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Join our Discord to stay updated!',
                      style: kTextStyleH3,
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () async {
                        Navigator.of(context).pop();

                        final url =
                            Uri.parse('https://discord.com/invite/5zSXxakF35');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url,
                              mode: LaunchMode.externalApplication);
                        }
                      },
                      child: const Text(
                        'https://discord.com/invite/5zSXxakF35',
                        style: TextStyle(
                          color: primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
