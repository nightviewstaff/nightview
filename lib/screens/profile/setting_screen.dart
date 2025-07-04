import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/icons.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/helpers/users/misc/user_data_helper.dart';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/models/users/user_data.dart';
import 'package:nightview/utility/utility.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  static const id = 'settings_screen';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user =
        Provider.of<GlobalProvider>(context).userDataHelper.currentUserData!;

    if (user == null) {
      return Center(child: Text("User not logged in"));
    }
    String birthday =
        "${user.birthdayDay.toString().padLeft(2, '0')}-${user.birthdayMonth.toString().padLeft(2, '0')}-${user.birthdayYear}";
    IconData? genderIcon;
    if (user.gender?.toLowerCase() == "m") {
      genderIcon = defaultMaleIcon;
    } else if (user.gender?.toLowerCase() == "f") {
      genderIcon = defaultFemaleIcon;
    } else {
      // genderIcon = defaultMaleFemaleIcon;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings", style: kTextStyleH3),
        backgroundColor: black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          sectionHeader("Personal"),
          userTile("Email", user.mail,
              onTap: () => _editField(context, "Email", user.mail, 'Email')),
          Row(
            children: [
              Expanded(
                child: userTile("First Name", user.firstName,
                    onTap: () => _editField(
                        context, "First Name", user.firstName, 'First Name')),
              ),
              SizedBox(width: 16),
              Expanded(
                  child: userTile("Last Name", user.lastName,
                      onTap: () => _editField(
                          context, "Last Name", user.lastName, 'Last Name'))),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: userTile(
                  "Birthday",
                  birthday,
                  onTap: () => _editField(
                      context, "Birthday", birthday, 'birthdate_day'),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: userTile(
                  "Phone",
                  user.phone != null && user.phone!.length > 3
                      ? '${user.phone!.substring(0, 3)} ${_formatPhoneNumber(user.phone!.substring(3))}'
                      : user.phone,
                  onTap: () => _editField(
                    context,
                    "Phone",
                    user.phone,
                    'phone',
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: userTile("Gender", "",
                    icon: genderIcon,
                    onTap: () => _editField(
                        context, "Gender", user.gender ?? '', 'gender')),
              ),
            ],
          ),
          Divider(
            color: white,
            thickness: 0.2,
            height: 30,
          ),
          sectionHeader("Location"),
          SwitchListTile(
            value: true, // Always on for visual purposes
            onChanged: (_) {}, // No-op for now
            title: Text(
              "Share location with friends",
              style: kTextStyleP1,
            ),
            activeColor: primaryColor,
            inactiveThumbColor: grey,
            inactiveTrackColor: grey.withOpacity(0.3),
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
          ),
          Divider(
            color: white,
            thickness: 0.2,
            height: 30,
          ),
          sectionHeader("Notifications"),
          Consumer<GlobalProvider>(
            builder: (context, provider, child) {
              return FutureBuilder<List<ClubData>>(
                future: provider.getFavoriteClubs(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    );
                  }

                  final clubs = snapshot.data ?? [];

                  final sortedClubs = [
                    ...clubs
                  ]; // clone list to avoid modifying original
                  sortedClubs
                      .sort((a, b) => a.name.length.compareTo(b.name.length));

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "You are receiving notifications from these ${sortedClubs.length} venue${sortedClubs.length == 1 ? '' : 's'}",
                        style: kTextStyleP1,
                      ),
                      const SizedBox(height: 8),
                      ...sortedClubs.map(
                        (club) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            "• ${Utility.formatString(club.name)}",
                            style: kTextStyleP1.copyWith(color: white),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          SizedBox(height: 8),
          Divider(
            color: white,
            thickness: 0.2,
            height: 30,
          ),
        ],
      ),
    );
  }

  Widget sectionHeader(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(text, style: kTextStyleH3.copyWith(color: primaryColor)),
      );

  Widget userTile(
    String label,
    String value, {
    IconData? icon,
    required VoidCallback onTap,
  }) =>
      ListTile(
        onTap: onTap,
        title: Text(label, style: kTextStyleH3ToP1),
        subtitle: Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: grey, width: 0.7),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: Icon(icon, size: 16, color: white),
                ),
              Flexible(
                child: Text(
                  value.isEmpty && value != '' ? 'Tap to set' : value,
                  style: kTextStyleP1.copyWith(
                    color: value.isEmpty ? grey : white,
                  ),
                  textAlign: TextAlign.center,
                  overflow:
                      TextOverflow.ellipsis, // Handles overflow gracefully
                  softWrap: false,
                ),
              ),
            ],
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      );

  Future<void> _editField(
    BuildContext context,
    String fieldLabel,
    String currentValue,
    String helperKey,
  ) async {
    final controller = TextEditingController(text: currentValue);
    final helper = Provider.of<UserDataHelper>(context, listen: false);
    final userId = helper.currentUserId!;

    final success = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Edit $fieldLabel'),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: fieldLabel),
              autofocus: true,
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(_, false),
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () => Navigator.pop(_, true), child: Text('Save')),
            ],
          ),
        ) ??
        false;

    if (success) {
      // TODO await helper.updateUserField(userId, helperKey, controller.text.trim());
      // Optionally show a Snackbar or update local cache
    }
  }
}

String _formatPhoneNumber(String number) {
  final buffer = StringBuffer();
  for (int i = 0; i < number.length; i++) {
    if (i != 0 && i % 2 == 0) buffer.write(' ');
    buffer.write(number[i]);
  }
  return buffer.toString();
}
