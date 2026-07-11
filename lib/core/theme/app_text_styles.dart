import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Text styles used across the app.
///
/// NOTE on the "BiteRush" logo font:
/// If you have the exact script font file from Figma, drop it in
/// assets/fonts/ and register it in pubspec.yaml, then swap
/// `logoStyle` below to use `fontFamily: 'YourFontName'` instead of
/// GoogleFonts. Until then this uses a close Google Fonts match
/// (Pacifico) so the app is runnable immediately.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle logoStyle({double fontSize = 48, Color? color}) {
    return GoogleFonts.pacifico(
      fontSize: fontSize,
      color: color ?? AppColors.primaryOrange,
      height: 1.0,
    );
  }

  static const TextStyle heading = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryOrange,
  );

  static const TextStyle inputLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.labelText,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 13,
    color: AppColors.labelText,
  );

  static const TextStyle linkText = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryOrange,
  );
}
