import 'package:flutter/material.dart';
import 'package:modal_side_sheet/modal_side_sheet.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/models/profile_picture_helper.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/providers/main_navigation_provider.dart';
import 'package:nightview/screens/option_menu/side_sheet_main_screen.dart';
import 'package:nightview/widgets/main_bottom_navigation_bar.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  static const id = 'main_screen';

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      String currentUserId = Provider.of<GlobalProvider>(context, listen: false).userDataHelper.currentUserId;
      String? pbUrl = await ProfilePictureHelper.getProfilePicture(currentUserId);
      Provider.of<GlobalProvider>(context, listen: false).setProfilePicture(pbUrl);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(Provider.of<MainNavigationProvider>(context)
        //     .currentPageNameAsString),
        leading: Placeholder(
          color: Colors.transparent,
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
                      Provider.of<GlobalProvider>(context).profilePicture,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Provider.of<MainNavigationProvider>(context).currentScreen,
      bottomNavigationBar: MainBottomNavigationBar(),
    );
  }
}
