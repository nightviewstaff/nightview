import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_side_sheet/modal_side_sheet.dart';
import 'package:nightview/constants/button_styles.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/icons.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/helpers/users/misc/profile_picture_helper.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/providers/main_navigation_provider.dart';
import 'package:nightview/screens/balladefabrikken/balladefabrikken_main_screen.dart';
import 'package:nightview/screens/login_registration/creation/terms_and_conditions_screen.dart';
import 'package:nightview/screens/night_map/night_map_main_screen.dart';
import 'package:nightview/screens/night_social/night_social_main_screen.dart';
import 'package:nightview/screens/option_menu/side_sheet_main_screen.dart';
import 'package:nightview/widgets/stateless/main_bottom_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        await _checkGenderPrompt(currentUserId);
      }
    });

    //TODO MAIN OFFER OF THE DAY HERE!
  }

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<MainNavigationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        // title: Text(Provider.of<MainNavigationProvider>(context)
        //     .currentPageNameAsString),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(BalladefabrikkenMainScreen.id);
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: kSmallSpacerValue),
              child: CircleAvatar(
                backgroundImage: AssetImage('images/bolt_icon.jpg'),
              ),
            ),
          ),
        ),
        title: Center(
          child: SizedBox(
            height: 200.0,
            child: Image.asset('images/logo_text.png'),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showModalSideSheet(
                context: context,
                barrierDismissible: true,
                withCloseControll: false,
                body: SideSheetMainScreen(),
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
      ),
      body: IndexedStack(
        index: navigationProvider.currentScreenIndex,
        children: navigationProvider.screens,
      ),
      bottomNavigationBar: MainBottomNavigationBar(),
    );
  }

  Future<void> _checkGenderPrompt(String userId) async {
    final userDocRef =
        FirebaseFirestore.instance.collection('user_data').doc(userId);
    final userDoc = await userDocRef.get();

    if (!userDoc.exists) {
      return;
    }

    final data = userDoc.data() ?? {};
    String? gender = data['gender'];

    // If gender is null or empty, show prompt
    if (gender == null || gender.isEmpty) {
      _showGenderDialog(userDocRef);
    }
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
}
