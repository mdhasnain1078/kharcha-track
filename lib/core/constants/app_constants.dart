import 'package:flutter/material.dart';
import 'package:finance_tracker/core/theme/app_colors.dart';

class AppConstants {
  AppConstants._();

  static const String appName = 'Kharch Tracker';
  static const String currencySymbol = '₹';
  static const String dateFormat = 'dd MMM yyyy';
  static const String timeFormat = 'hh:mm a';

  // ─── Default Categories ────────────────────────────────────────────
  static const List<Map<String, dynamic>> expenseCategories = [
    {'name': 'Food & Dining', 'icon': Icons.restaurant_rounded, 'color': AppColors.categoryFood},
    {'name': 'Transport', 'icon': Icons.directions_car_rounded, 'color': AppColors.categoryTransport},
    {'name': 'Shopping', 'icon': Icons.shopping_bag_rounded, 'color': AppColors.categoryShopping},
    {'name': 'Entertainment', 'icon': Icons.movie_rounded, 'color': AppColors.categoryEntertainment},
    {'name': 'Bills & Utilities', 'icon': Icons.receipt_long_rounded, 'color': AppColors.categoryBills},
    {'name': 'Health', 'icon': Icons.favorite_rounded, 'color': AppColors.categoryHealth},
    {'name': 'Education', 'icon': Icons.school_rounded, 'color': AppColors.categoryEducation},
    {'name': 'Groceries', 'icon': Icons.local_grocery_store_rounded, 'color': AppColors.categoryFood},
    {'name': 'Rent', 'icon': Icons.home_rounded, 'color': AppColors.categoryBills},
    {'name': 'Other', 'icon': Icons.more_horiz_rounded, 'color': AppColors.categoryOther},
  ];

  static const List<Map<String, dynamic>> incomeCategories = [
    {'name': 'Salary', 'icon': Icons.work_rounded, 'color': AppColors.categorySalary},
    {'name': 'Freelance', 'icon': Icons.laptop_mac_rounded, 'color': AppColors.categoryFreelance},
    {'name': 'Investment', 'icon': Icons.trending_up_rounded, 'color': AppColors.categoryInvestment},
    {'name': 'Gift', 'icon': Icons.card_giftcard_rounded, 'color': AppColors.categoryGift},
    {'name': 'Refund', 'icon': Icons.replay_rounded, 'color': AppColors.accent},
    {'name': 'Other', 'icon': Icons.more_horiz_rounded, 'color': AppColors.categoryOther},
  ];

  // ─── Goal Icons ────────────────────────────────────────────────────
  static const List<IconData> goalIcons = [
    Icons.savings_rounded,
    Icons.flight_rounded,
    Icons.home_rounded,
    Icons.directions_car_rounded,
    Icons.school_rounded,
    Icons.phone_iphone_rounded,
    Icons.laptop_mac_rounded,
    Icons.camera_alt_rounded,
    Icons.diamond_rounded,
    Icons.celebration_rounded,
    Icons.fitness_center_rounded,
    Icons.medical_services_rounded,
  ];

  static const List<Color> goalColors = [
    AppColors.primary,
    AppColors.accent,
    AppColors.categoryFood,
    AppColors.categoryTransport,
    AppColors.categoryShopping,
    AppColors.categoryEntertainment,
    AppColors.categoryHealth,
    AppColors.categoryEducation,
    AppColors.categoryGift,
    AppColors.categoryInvestment,
  ];

  // ─── Motivational Messages ─────────────────────────────────────────
  static const List<String> streakMessages = [
    'Great start! Keep going! 🌱',
    'You\'re on a roll! 🔥',
    'Impressive discipline! 💪',
    'Savings champion! 🏆',
    'Unstoppable! 🚀',
    'Financial wizard! ✨',
    'Legend in the making! 👑',
  ];

  static String getStreakMessage(int streak) {
    if (streak <= 0) return 'Start saving today! 💡';
    if (streak <= 3) return streakMessages[0];
    if (streak <= 7) return streakMessages[1];
    if (streak <= 14) return streakMessages[2];
    if (streak <= 21) return streakMessages[3];
    if (streak <= 30) return streakMessages[4];
    if (streak <= 60) return streakMessages[5];
    return streakMessages[6];
  }
}
