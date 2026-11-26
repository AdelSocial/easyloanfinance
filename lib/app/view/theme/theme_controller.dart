import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  var isDarkMode = true.obs; // Default to dark mode

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF00D4FF),
    scaffoldBackgroundColor: Color(0xFFF5F5F5),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF00D4FF),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Color(0xFF0C192E),
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF0C192E),
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: Color(0xFF666666),
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        color: Color(0xFF888888),
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: Color(0xFF00D4FF),
      secondary: Color(0xFF00D4FF),
      surface: Color(0xFFF5F5F5),
    ),
  );

  ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF00D4FF),
    scaffoldBackgroundColor: Color(0xFF0C192E),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF0C192E),
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: Color(0xFF1E2E3D),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: Colors.white70,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        color: Colors.white60,
      ),
    ),
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF00D4FF),
      secondary: Color(0xFF00D4FF),
      surface: Color(0xFF0C192E),
    ),
  );
}