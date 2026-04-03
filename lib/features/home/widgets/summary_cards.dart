import 'package:flutter/material.dart';
import 'package:finance_tracker/core/theme/app_colors.dart';
import 'package:finance_tracker/core/utils/currency_utils.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SummaryCards extends StatelessWidget {
  final double income;
  final double expense;
  final String currencySymbol;

  const SummaryCards({
    super.key,
    required this.income,
    required this.expense,
    this.currencySymbol = '₹',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            title: 'Income',
            amount: income,
            icon: Icons.arrow_downward_rounded,
            gradient: AppColors.incomeGradient,
            iconBgColor: AppColors.income.withOpacity(0.15),
            iconColor: AppColors.income,
            isDark: isDark,
            currencySymbol: currencySymbol,
          ).animate(delay: 100.ms).fadeIn(duration: 400.ms).slideX(begin: -0.1, end: 0),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _SummaryCard(
            title: 'Expense',
            amount: expense,
            icon: Icons.arrow_upward_rounded,
            gradient: AppColors.expenseGradient,
            iconBgColor: AppColors.expense.withOpacity(0.15),
            iconColor: AppColors.expense,
            isDark: isDark,
            currencySymbol: currencySymbol,
          ).animate(delay: 200.ms).fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final IconData icon;
  final LinearGradient gradient;
  final Color iconBgColor;
  final Color iconColor;
  final bool isDark;
  final String currencySymbol;

  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.gradient,
    required this.iconBgColor,
    required this.iconColor,
    required this.isDark,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              CurrencyUtils.formatAmountCompact(amount, symbol: currencySymbol),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
