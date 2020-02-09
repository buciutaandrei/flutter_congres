import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  //
  ThemeMode themeMode = ThemeMode.system;

  void updateTheme(ThemeMode themeMode) {
    this.themeMode = themeMode;
    notifyListeners();
  }

  String get themeModeName {
    switch (themeMode) {
      case ThemeMode.system:
        return 'Auto';
        break;
      case ThemeMode.dark:
        return 'Dark Theme';
        break;
      case ThemeMode.light:
        return 'Light Theme';
        break;
      default:
        return 'Select Theme Mode';
    }
  }
}
