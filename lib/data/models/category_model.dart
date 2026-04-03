import 'package:flutter/material.dart';
import 'package:finance_tracker/core/constants/app_constants.dart';
import 'package:finance_tracker/core/theme/app_colors.dart';

class CategoryModel {
  final String name;
  final IconData icon;
  final Color color;

  const CategoryModel({
    required this.name,
    required this.icon,
    required this.color,
  });

  static List<CategoryModel> get expenseCategories {
    return AppConstants.expenseCategories.map((c) {
      return CategoryModel(
        name: c['name'] as String,
        icon: c['icon'] as IconData,
        color: c['color'] as Color,
      );
    }).toList();
  }

  static List<CategoryModel> get incomeCategories {
    return AppConstants.incomeCategories.map((c) {
      return CategoryModel(
        name: c['name'] as String,
        icon: c['icon'] as IconData,
        color: c['color'] as Color,
      );
    }).toList();
  }

  static CategoryModel getCategoryByName(String name) {
    final allCategories = [...expenseCategories, ...incomeCategories];
    return allCategories.firstWhere(
      (c) => c.name == name,
      orElse: () => CategoryModel(
        name: name,
        icon: Icons.category_rounded,
        color: AppColors.categoryOther,
      ),
    );
  }

  static Color getColorForCategory(String name) {
    return getCategoryByName(name).color;
  }

  static IconData getIconForCategory(String name) {
    return getCategoryByName(name).icon;
  }
}
