import 'package:flutter/material.dart';
import 'package:finance_tracker/core/theme/app_colors.dart';
import 'package:finance_tracker/core/utils/currency_utils.dart';

class WeeklyComparison extends StatelessWidget {
  final double thisWeek;
  final double lastWeek;
  final String currencySymbol;

  const WeeklyComparison({
    super.key,
    required this.thisWeek,
    required this.lastWeek,
    this.currencySymbol = '₹',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final change = lastWeek > 0 ? ((thisWeek - lastWeek) / lastWeek * 100) : 0.0;
    final isDown = change <= 0;
    final maxVal = thisWeek > lastWeek ? thisWeek : lastWeek;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Weekly Comparison',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: (isDown ? AppColors.income : AppColors.expense).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isDown ? Icons.trending_down_rounded : Icons.trending_up_rounded,
                        size: 14,
                        color: isDown ? AppColors.income : AppColors.expense,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${change.abs().toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isDown ? AppColors.income : AppColors.expense,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _ComparisonBar(
              label: 'This Week',
              amount: thisWeek,
              maxValue: maxVal,
              color: AppColors.primary,
              isDark: isDark,
              currencySymbol: currencySymbol,
            ),
            const SizedBox(height: 14),
            _ComparisonBar(
              label: 'Last Week',
              amount: lastWeek,
              maxValue: maxVal,
              color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
              isDark: isDark,
              currencySymbol: currencySymbol,
            ),
          ],
        ),
      ),
    );
  }
}

class _ComparisonBar extends StatelessWidget {
  final String label;
  final double amount;
  final double maxValue;
  final Color color;
  final bool isDark;
  final String currencySymbol;

  const _ComparisonBar({
    required this.label,
    required this.amount,
    required this.maxValue,
    required this.color,
    required this.isDark,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = maxValue > 0 ? (amount / maxValue).clamp(0.0, 1.0) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
            Text(
              CurrencyUtils.formatAmountCompact(amount, symbol: currencySymbol),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: ratio),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutCubic,
          builder: (context, value, _) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: value,
                backgroundColor: isDark ? AppColors.darkBorder : AppColors.divider,
                valueColor: AlwaysStoppedAnimation(color),
                minHeight: 10,
              ),
            );
          },
        ),
      ],
    );
  }
}
