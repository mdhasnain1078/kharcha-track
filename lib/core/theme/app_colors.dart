import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ─── Primary Palette ───────────────────────────────────────────────
  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryLight = Color(0xFF9B8FFF);
  static const Color primaryDark = Color(0xFF4834D4);
  static const Color primarySurface = Color(0xFFF0EDFF);

  // ─── Accent ────────────────────────────────────────────────────────
  static const Color accent = Color(0xFF00B894);
  static const Color accentLight = Color(0xFF55EFC4);
  static const Color accentDark = Color(0xFF00896B);

  // ─── Income / Expense ──────────────────────────────────────────────
  static const Color income = Color(0xFF00B894);
  static const Color incomeLight = Color(0xFFE8FFF6);
  static const Color expense = Color(0xFFFF6B6B);
  static const Color expenseLight = Color(0xFFFFF0F0);

  // ─── Neutral ───────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textTertiary = Color(0xFFB2BEC3);
  static const Color border = Color(0xFFE8ECF0);
  static const Color divider = Color(0xFFF5F6F8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF8F9FD);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // ─── Dark Theme ────────────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF0D1117);
  static const Color darkSurface = Color(0xFF161B22);
  static const Color darkCard = Color(0xFF1C2333);
  static const Color darkBorder = Color(0xFF30363D);
  static const Color darkTextPrimary = Color(0xFFF0F6FC);
  static const Color darkTextSecondary = Color(0xFF8B949E);
  static const Color darkTextTertiary = Color(0xFF484F58);
  static const Color darkPrimarySurface = Color(0xFF1A1530);

  // ─── Category Colors ───────────────────────────────────────────────
  static const Color categoryFood = Color(0xFFFF9F43);
  static const Color categoryTransport = Color(0xFF54A0FF);
  static const Color categoryShopping = Color(0xFFFF6B81);
  static const Color categoryEntertainment = Color(0xFFA29BFE);
  static const Color categoryBills = Color(0xFFFECA57);
  static const Color categoryHealth = Color(0xFF00D2D3);
  static const Color categoryEducation = Color(0xFF5F27CD);
  static const Color categorySalary = Color(0xFF10AC84);
  static const Color categoryFreelance = Color(0xFF2ED573);
  static const Color categoryInvestment = Color(0xFF1289A7);
  static const Color categoryGift = Color(0xFFE056A0);
  static const Color categoryOther = Color(0xFF95A5A6);

  // ─── Chart Colors ──────────────────────────────────────────────────
  static const List<Color> chartColors = [
    Color(0xFF6C5CE7),
    Color(0xFF00B894),
    Color(0xFFFF9F43),
    Color(0xFF54A0FF),
    Color(0xFFFF6B81),
    Color(0xFFFECA57),
    Color(0xFF00D2D3),
    Color(0xFF5F27CD),
  ];

  // ─── Gradients ─────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C5CE7), Color(0xFF9B8FFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient incomeGradient = LinearGradient(
    colors: [Color(0xFF00B894), Color(0xFF55EFC4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient expenseGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFFF9F9F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF1C2333), Color(0xFF232D3F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
