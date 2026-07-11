import 'package:flutter/material.dart';

/// Central color palette for Bite Rush.
/// Pulled from the Figma design — adjust these 3-4 values and the
/// whole app's brand color updates everywhere.
class AppColors {
  AppColors._();

  // Brand oranges
  static const Color primaryOrange = Color(0xFFF1732A); // buttons, headings, links
  static const Color headerOrange = Color(0xFFF0A075);  // the curved header shape
  static const Color logoBrown = Color(0xFF6B3A2C);     // "BiteRush" script text

  // Neutrals
  static const Color background = Color(0xFFFFFFFF);
  static const Color inputBorder = Color(0xFFF1732A);
  static const Color hintText = Color(0xFF9E9E9E);
  static const Color labelText = Color(0xFF2E2E2E);
  static const Color splashIcon = Color(0xFFF4D35E); // fork/knife outline

  // Status (used later for order tracking etc.)
  static const Color success = Color(0xFF2ECC71);
  static const Color error = Color(0xFFE74C3C);
}
