import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';

/// The WebView screen to display Terms & Conditions
class TermsAndConditionsScreen extends StatefulWidget {
  static const id = 'terms_and_conditions_screen';

  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://night-view.dk/privacy-policy/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: black,
        title: Text('Terms & Conditions', style: kTextStyleH2),
      ),
      body: SafeArea(
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}

/// The reusable checkbox + link row
class TermsAndConditionsCheckbox extends StatelessWidget {
  final bool value;
  final void Function(bool?) onChanged;

  const TermsAndConditionsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: primaryColor,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const TermsAndConditionsScreen(),
              ));
            },
            child: const Text(
              'I agree to the Terms and Conditions',
              style: TextStyle(
                color: white,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget buildTermsDialog(BuildContext context, SharedPreferences prefs) {
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse('https://night-view.dk/privacy-policy/'));

  return AlertDialog(
    backgroundColor: black,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: white, width: 2),
    ),
    title: Text('Terms & Conditions', style: kTextStyleH2),
    content: SizedBox(
      height: 400,
      child: WebViewWidget(controller: controller),
    ),
    actions: [
      TextButton(
        onPressed: () async {
          await prefs.setBool('agreedToTerms', true);
          Navigator.of(context).pop();
        },
        child: const Text('I Agree', style: TextStyle(color: white)),
      ),
    ],
  );
}

class TermsFullScreenDialog extends StatefulWidget {
  const TermsFullScreenDialog({super.key});

  @override
  State<TermsFullScreenDialog> createState() => _TermsFullScreenDialogState();
}

class _TermsFullScreenDialogState extends State<TermsFullScreenDialog> {
  late final WebViewController _controller;
  bool _isWebViewReady = false;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) {
              setState(() {
                _isWebViewReady = true;
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse('https://night-view.dk/privacy-policy/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        title: Text('Terms & Conditions', style: kTextStyleH2),
        backgroundColor: black,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('agreedToTerms', true);
              if (context.mounted) Navigator.of(context).pop();
            },
            child: const Text('I Agree', style: TextStyle(color: white)),
          ),
        ],
      ),
      body: SafeArea(
        child: _isWebViewReady
            ? WebViewWidget(controller: _controller)
            : const Center(
                child: CircularProgressIndicator(color: white),
              ),
      ),
    );
  }
}
