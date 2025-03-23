import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';

class ProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final double marginHorizontal;

  const ProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.marginHorizontal = 20,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      // Prevents user interaction with the progress bar
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(totalSteps, (index) {
          bool isCompleted = index < currentStep - 1;
          bool isActive = index == currentStep - 1;

          return Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: marginHorizontal, vertical: 0),
              height: 5, // Adjust thickness if needed
              decoration: BoxDecoration(
                color: isCompleted
                    ? primaryColor // Completed
                    : isActive
                        ? secondaryColor // Active
                        : grey, // Inactive
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        }),
      ),
    );
  }
}
