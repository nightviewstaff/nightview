import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/providers/login_registration_provider.dart';
import 'package:nightview/screens/login_registration/registration_authentication_screen.dart';
import 'package:nightview/widgets/stateless/date_picker_button.dart';
import 'package:nightview/widgets/stateless/login_registration_confirm_button.dart';
import 'package:nightview/widgets/stateless/login_registration_layout.dart';
import 'package:provider/provider.dart';

class RegistrationAgeScreen extends StatelessWidget {
  static const id = 'registration_age_screen';

  const RegistrationAgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginRegistrationProvider>(
      builder: (context, provider, child) => LoginRegistrationLayout(
        title: Text(
          'Hvornår er din fødselsdag?',
          textAlign: TextAlign.center,
          style: kTextStyleH1,
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            DatePickerButton(
              date: provider.birthDate,
              onPressed: () async {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.black,
                  isScrollControlled: true,
                  builder: (context) => Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 200.0,
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: provider.birthDate,
                          minimumYear: 1900,
                          maximumYear: DateTime.now().year,
                          onDateTimeChanged: (DateTime newDate) {
                            provider.setBirthDate(newDate);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: kNormalSpacerValue, right: kNormalSpacerValue),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Vælg',
                            style: TextStyle(color: primaryColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
                // showDialog(
                //   context: context,
                //   builder: (context) => AlertDialog(
                //     content: CupertinoDatePicker(
                //       mode: CupertinoDatePickerMode.date,
                //       initialDateTime: provider.birthDate,
                //       minimumYear: 1900,
                //       maximumYear: DateTime.now().year,
                //       backgroundColor: Colors.red,
                //       onDateTimeChanged: (DateTime date) {
                //         print(date);
                //       },
                //     ),
                //   ),
                // );

                // if (newBirthDate == null) {
                //   return;
                // }
                //
                // provider.setBirthDate(newBirthDate);
              },
            ),
            SizedBox(
              height: kNormalSpacerValue,
            ),
            SizedBox(
              width: double.maxFinite,
              child: Text(
                'Du skal være over 18.',
                textAlign: TextAlign.center,
                style: kTextStyleP1,
              ),
            ),
            SizedBox(
              height: kNormalSpacerValue,
            ),
            LoginRegistrationConfirmButton(
              onPressed: () async {
                final DateTime today = DateTime.now();
                final DateTime eighteenYearsAgo =
                    DateTime(today.year - 18, today.month, today.day);
                final bool isLegal =
                    provider.birthDate.isBefore(eighteenYearsAgo);

                if (isLegal) {
                  Navigator.of(context).pushReplacementNamed(
                      RegistrationAuthenticationScreen.id);
                } else {
                  await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      title: Text('Ikke gammel nok'),
                      content: SingleChildScrollView(
                        child:
                            Text('Du skal være mindst 18 år for at bruge NightView'),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Okay',
                            style: TextStyle(
                              color: primaryColor,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// DateTime? newBirthDate = await showDatePicker(
// context: context,
// initialDate: provider.birthDate,
// firstDate: DateTime(1900),
// lastDate: DateTime.now());
