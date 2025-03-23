import 'package:flutter/material.dart';
import 'package:nightview/widgets/stateless/misc/progress_bar.dart';
import 'package:nightview/widgets/icons/back_button_top_left.dart';
import 'package:nightview/widgets/icons/logo_top_right.dart';

class SignUpPageBasic extends StatelessWidget {
  final Widget title;
  final List<Widget> formFields;
  final Widget? bottomContent;
  final VoidCallback onBack;
  final bool showProgressBar;
  final int currentStep;
  final int totalSteps;

  const SignUpPageBasic({
    super.key,
    required this.title,
    required this.formFields,
    this.bottomContent,
    required this.onBack,
    this.showProgressBar = true,
    this.currentStep = 1,
    this.totalSteps = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Progress Bar for totalSteps > 2
            if (showProgressBar && totalSteps > 2)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ProgressBar(
                  currentStep: currentStep,
                  totalSteps: totalSteps,
                ),
              ),
            // Progress Bar for totalSteps < 3
            if (totalSteps < 3)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ProgressBar(
                  currentStep: currentStep,
                  totalSteps: totalSteps,
                  marginHorizontal: 35,
                ),
              ),
            // Other UI elements
            BackButtonTopLeft(onPressed: onBack),
            ImageInsertDefaultTopRight(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 60), // Minimum space from the top
                  Align(
                    alignment: Alignment.topCenter,
                    child: title,
                  ),
                  Form(
                    child: Column(
                      children: formFields,
                    ),
                  ),
                  if (bottomContent != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: bottomContent!,
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
