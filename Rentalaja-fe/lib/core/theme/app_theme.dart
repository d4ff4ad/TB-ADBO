import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF448AFF), // Bright Blue like reference
        primary: const Color(0xFF448AFF),
        secondary: const Color(0xFFFFC107), // Amber/Yellow for buttons
        surface: const Color(0xFFF5F6FA), // Light greyish background
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: const Color(0xFFF5F6FA),
      textTheme: GoogleFonts.interTextTheme(),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFF448AFF),
        foregroundColor: Colors.white,
      ),
    );
  }
}
