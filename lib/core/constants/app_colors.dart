import 'package:flutter/material.dart';

/// HadyPay brand palette — derived from the HadyPay logo
/// (deep navy "H" + teal/emerald gradient arrow).
class AppColors {
  AppColors._();

  // Brand core
  static const Color navy = Color(0xFF162A4E);
  static const Color navyDark = Color(0xFF0D1B34);
  static const Color teal = Color(0xFF19B38B);
  static const Color tealLight = Color(0xFF2ED9A6);
  static const Color mint = Color(0xFF6FE7C4);

  // Gradients
  static const LinearGradient brandGradient = LinearGradient(
    colors: [navy, teal, tealLight],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient tealGradient = LinearGradient(
    colors: [teal, tealLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient balanceCardGradient = LinearGradient(
    colors: [navy, Color(0xFF1B3A63), teal],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Neutrals — Light
  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE7EBF0);
  static const Color lightTextPrimary = Color(0xFF16213A);
  static const Color lightTextSecondary = Color(0xFF6B7688);

  // Neutrals — Dark
  static const Color darkBackground = Color(0xFF0B1220);
  static const Color darkSurface = Color(0xFF141C2E);
  static const Color darkCard = Color(0xFF1A2438);
  static const Color darkBorder = Color(0xFF263048);
  static const Color darkTextPrimary = Color(0xFFF2F5F9);
  static const Color darkTextSecondary = Color(0xFF9AA5B8);

  // Status
  static const Color success = Color(0xFF19B38B);
  static const Color warning = Color(0xFFF2A93B);
  static const Color error = Color(0xFFE6584F);
  static const Color pending = Color(0xFFF2A93B);
}
