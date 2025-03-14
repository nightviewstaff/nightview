// lib/providers/language_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('da'); // Default to Danish
  String _flagPath = 'images/flags/dk.png';

  LanguageProvider() {
    _loadLanguage();
  }

  Locale get locale => _locale;
  String get flagPath => _flagPath;

  final Map<String, Locale> _supportedLanguages = {
    'images/flags/dk.png': const Locale('da'),
    // 'images/flags/uk.png': const Locale('en'), // TODO When eng ready.
    //   'images/flags/de.png': const Locale('de'), // Add German flag
    // 'images/flags/sv.png': const Locale('sv'), // Add Swedish flag
    // 'images/flags/no.png': const Locale('no'),
    // Todo Add more flags when needed for translations
  };

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedFlag = prefs.getString('flagPath');
    if (savedFlag != null && _supportedLanguages.containsKey(savedFlag)) {
      _flagPath = savedFlag;
      _locale = _supportedLanguages[savedFlag]!;
      notifyListeners();
    }
  }

  Future<void> changeLanguage(String newFlagPath) async {
    if (_supportedLanguages.containsKey(newFlagPath) &&
        newFlagPath != _flagPath) {
      _flagPath = newFlagPath;
      _locale = _supportedLanguages[newFlagPath]!;
      // print('New locale: $_locale');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('flagPath', newFlagPath);
      notifyListeners();
    }
  }

  List<String> get availableFlags => _supportedLanguages.keys.toList();
}
