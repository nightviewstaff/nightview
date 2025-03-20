import 'package:flutter/material.dart';
import 'package:nightview/providers/locale_provider.dart';
import 'package:provider/provider.dart';

class LanguageFlagDropdown extends StatelessWidget {
  final List<LocaleOption> localeOptions = const [
    LocaleOption(locale: Locale('en'), flagPath: 'images/flags/uk.png'),
    LocaleOption(locale: Locale('da'), flagPath: 'images/flags/dk.png'),
    // LocaleOption(locale: Locale('no'), flagPath: 'images/flags/no.png'),
    // LocaleOption(locale: Locale('sv'), flagPath: 'images/flags/se.png'),
    // Add more locales with their flag paths
  ];

  const LanguageFlagDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    final currentLocale = provider.locale ?? const Locale('en');

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Locale>(
              value: currentLocale,
              icon: const SizedBox.shrink(), // Remove default arrow
              dropdownColor: Colors.black.withOpacity(0.9),
              borderRadius: BorderRadius.circular(10),
              items: localeOptions.map((LocaleOption option) {
                return DropdownMenuItem<Locale>(
                  value: option.locale,
                  child: FlagInsertDefaultTopRight(
                    imagePath: option.flagPath,
                    width: 30,
                    height: 30,
                    borderRadius: 4,
                    right: 0,
                    left: 0,
                  ),
                );
              }).toList(),
              onChanged: (Locale? newLocale) {
                if (newLocale != null) {
                  provider.setLocale(newLocale);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

class LocaleOption {
  final Locale locale;
  final String flagPath;

  const LocaleOption({
    required this.locale,
    required this.flagPath,
  });
}

class FlagInsertDefaultTopRight extends StatelessWidget {
  final String imagePath;
  final double top;
  final double left;
  final double right;
  final double width;
  final double height;
  final double borderRadius;

  const FlagInsertDefaultTopRight({
    super.key,
    required this.imagePath,
    this.top = 0,
    this.left = 0,
    this.right = 0,
    this.width = 40,
    this.height = 40,
    this.borderRadius = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: top, left: left, right: right),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.asset(
          imagePath,
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
