// lib/widgets/language_switcher.dart
import 'package:flutter/material.dart';
import 'package:nightview/app_localization.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/providers/language_provider.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';

/// A widget that paints [text] using a gradient from two dominant colors.
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Gradient gradient;

  const GradientText({
    Key? key,
    required this.text,
    required this.style,
    required this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(bounds),
      child: Text(
        text,
        style: style.copyWith(color: Colors.white),
      ),
    );
  }
}

/// A language switcher that displays each language with a gradient using the two dominant colors of the flag.
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
    // Map flag image paths to their native names.
    const languageNames = {
      'images/flags/dk.png': 'Dansk',
      'images/flags/uk.png': 'English',
      // Uncomment and add others as needed:
      // 'images/flags/de.png': 'Deutsch',
      // 'images/flags/sv.png': 'Svenska',
      // 'images/flags/no.png': 'Norsk',
    };

    // Extract two dominant colors from the flag image.
    Future<List<Color>> getDominantColors(String flagPath) async {
      final PaletteGenerator palette =
          await PaletteGenerator.fromImageProvider(AssetImage(flagPath));
      Color? dominant = palette.dominantColor?.color;
      List<Color> colors = palette.colors.toList();
      if (dominant != null) {
        colors.removeWhere((c) => c == dominant);
      }
      Color secondary =
          colors.isNotEmpty ? colors.first : (dominant ?? primaryColor);
      return [dominant ?? primaryColor, secondary];
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            AppLocalizations.of(context)!.selectLanguage,
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: languageProvider.availableFlags.map((flagPath) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(flagPath),
                  radius: 15,
                ),
                title: FutureBuilder<List<Color>>(
                  future: getDominantColors(flagPath),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final color1 = snapshot.data![0];
                      final color2 = snapshot.data![1];
                      return GradientText(
                        text: languageNames[flagPath]!,
                        style:
                            kTextStyleH3.copyWith(fontWeight: FontWeight.bold),
                        gradient: LinearGradient(
                          colors: [color1, color1, color2, color2],
                          stops: [0.0, 0, 1, 0],
                        ),
                      );
                    } else {
                      return Text(
                        languageNames[flagPath]!,
                        style: kTextStyleH3.copyWith(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                  },
                ),
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
