import 'package:flutter/material.dart';
import 'package:sound_flex/utils/colors.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.backgroundColor,
    backgroundColor: AppColors.backgroundColor,
    primaryColor: AppColors.primary,
    // primaryColorDark: Color(0xFF000000),
    // primaryColorLight: const Color(0xFFE2D5EE),
    dividerColor:AppColors.horizontalLineColor,
    textTheme: const TextTheme().copyWith(
      bodyText1: const TextStyle(
        color: Colors.black,
        fontSize: 16.0,
        fontFamily: "Inter",
      ),
      bodyText2: const TextStyle(
        color: Colors.black,
        fontSize: 18.0,
        fontFamily: "Inter",
      ),
      headline6: const TextStyle(
        color: Colors.black,
        fontFamily: "Poppins",
      ),
      headline5: const TextStyle(
        color: Colors.black,
        fontFamily: "Montserrat",
      ),
    ),
    iconTheme:
        const IconThemeData(color: AppColors.primary, opacity: 0.8, size: 24),
  );
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFFFAFAFD),
    backgroundColor: const Color(0xFFFAFAFD),
    primaryColor: const Color(0xFF6f2da8),
    // primaryColorDark: Color(0xFF000000),
    primaryColorLight: const Color(0xFFE2D5EE),
    dividerColor: const Color(0xFF607288),
    textTheme: const TextTheme().copyWith(
      bodyText1: const TextStyle(
        color: Color(0xFF20173D),
        fontSize: 14.0,
        fontFamily: "Product Sans",
      ),
      bodyText2: const TextStyle(
        color: Color(0xFF20173D),
        fontSize: 16.0,
        fontFamily: "Product Sans",
      ),
      headline6: const TextStyle(
        color: Color(0xFF20173D),
        fontFamily: "Product Sans",
      ),
      headline5: const TextStyle(
        color: Color(0xFF6f2da8),
        fontFamily: "Product Sans",
      ),
    ),
    iconTheme:
        const IconThemeData(color: Color(0xFF53227E), opacity: 0.8, size: 24),
    colorScheme:
        const ColorScheme.light().copyWith(secondary: const Color(0xFFF1EBF7)),
  );
}
