import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/utilities/messages/custom_modal_message.dart';

class LoadingIndicatorWithTick extends StatefulWidget {
  final ValueListenable<int> remainingItemsNotifier; // ✅ Custom ValueListenable
  final String messageOnTap; // ✅ Custom tap message

  const LoadingIndicatorWithTick({
    super.key,
    required this.remainingItemsNotifier,
    required this.messageOnTap,
  });

  @override
  _LoadingIndicatorWithTickState createState() =>
      _LoadingIndicatorWithTickState();
}

class _LoadingIndicatorWithTickState extends State<LoadingIndicatorWithTick> {
  bool _showTick = false; //TODO SHOWS WHEN OPEN
  bool _hasShownTick = false; // ✅ New flag to track if tick was shown

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: widget.remainingItemsNotifier, // ✅ Use provided notifier
      builder: (context, remaining, child) {
        if (remaining > 1) {          _hasShownTick = false; // ✅ Reset tick flag when fetching starts again

          // ✅ Show loader while fetching
          return GestureDetector(
            onTap: () {
              CustomModalMessage.showCustomBottomSheetOneSecond(
                autoDismissDurationSeconds: 2,
                context: context,
                message: widget.messageOnTap
                    .replaceAll("{count}", remaining.toString()),
                textStyle: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1), // ✅ Subtle background
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(8),
              child: const SizedBox(
                width: 14, // ✅ Small size
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2, // ✅ Thin indicator
                  valueColor: AlwaysStoppedAnimation<Color>(
                      secondaryColor), // ✅ Subtle color
                ),
              ),
            ),
          );
        }

        // ✅ If loading just finished and tick hasn't been shown yet
        if (!_showTick && !_hasShownTick) {
          _hasShownTick = true; // ✅ Mark tick as shown
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() => _showTick = true);
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) setState(() => _showTick = false);
            });
          });
        }

        return AnimatedOpacity(
          opacity: _showTick ? 1.0 : 0.0,
          // ✅ Fade in and out
          duration: const Duration(milliseconds: 300),
          // ✅ Matches scale duration
          child: AnimatedScale(
            scale: _showTick ? 2.5 : 1.0, // ✅ Pop up to 2.5x size // TODO Tick not working
            duration: const Duration(milliseconds: 300), // ✅ Animation duration
            curve: Curves.easeOut, // ✅ Smooth easing
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(6),
              child: const Icon(
                Icons.check_sharp, // ✅ Small tick icon
                size: 10,
                color: primaryColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
