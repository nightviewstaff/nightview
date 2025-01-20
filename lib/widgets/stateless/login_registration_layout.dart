import 'package:flutter/material.dart';
import 'package:nightview/constants/values.dart';

class LoginRegistrationLayout extends StatelessWidget {

  final Widget title;
  final Widget content;
  final Widget? bottomContent;

  const LoginRegistrationLayout(
      {super.key, required this.title, required this.content, this.bottomContent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(kNormalSpacerValue),
                  child: title,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 50.0,
              ),
              child: content,
            ),
            SizedBox(
              height: MediaQuery.of(context).viewInsets.bottom == 0 ? kBottomSpacerValue : kNormalSpacerValue,
              child: Container(
                padding: EdgeInsets.all(10.0),
                alignment: Alignment.bottomCenter,
                child: bottomContent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
