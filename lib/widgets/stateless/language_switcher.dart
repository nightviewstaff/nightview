// lib/widgets/language_switcher.dart
import 'package:flutter/material.dart';
import 'package:nightview/app_localization.dart';

import 'package:nightview/providers/language_provider.dart';
import 'package:provider/provider.dart';

class LanguageSwitcher extends StatelessWidget {
  final double radius;
  final double borderRadius;

  const LanguageSwitcher({
    super.key,
    this.radius = 15.0,
    this.borderRadius = 25.0,
  });

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return GestureDetector(
      onTap: () => _showLanguageDialog(context),
      child: CircleAvatar(
        backgroundImage: AssetImage(languageProvider.flagPath),
        radius: radius,
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    const languageNames = {
      'images/flags/dk.png': 'Dansk',
      'images/flags/uk.png': 'English',
      //     'images/flags/de.png': 'Deutsch',
      // 'images/flags/sv.png': 'Svenska',
      // 'images/flags/no.png': 'Norsk',
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.selectLanguage),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: languageProvider.availableFlags.map((flagPath) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(flagPath),
                  radius: 15,
                ),
                title: Text(languageNames[flagPath]!), // Native language name
                onTap: () {
                  languageProvider.changeLanguage(flagPath);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
