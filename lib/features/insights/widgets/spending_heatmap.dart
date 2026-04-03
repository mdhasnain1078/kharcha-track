import 'package:flutter/material.dart';
import 'package:finance_tracker/core/theme/app_colors.dart';
import 'package:finance_tracker/core/utils/date_utils.dart';

class SpendingHeatmap extends StatelessWidget {
  final List<Map<String, dynamic>> dailySpending;

  const SpendingHeatmap({super.key, required this.dailySpending});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final daysInMonth = AppDateUtils.getDaysInMonth(now);
    final firstWeekday = daysInMonth.first.weekday;

    final spendingMap = <String, double>{};
    for (final entry in dailySpending) {
      spendingMap[entry['date'] as String] = (entry['amount'] as num).toDouble();
    }

    final maxSpending = spendingMap.values.fold<double>(0, (a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Spending Heatmap',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppDateUtils.formatMonthYear(now),
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            // Weekday labels
            Row(
              children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((d) {
                return Expanded(
                  child: Center(
                    child: Text(
                      d,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            // Calendar grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: (firstWeekday - 1) + daysInMonth.length,
              itemBuilder: (context, index) {
                if (index < firstWeekday - 1) {
                  return const SizedBox();
                }

                final dayIndex = index - (firstWeekday - 1);
                if (dayIndex >= daysInMonth.length) return const SizedBox();

                final day = daysInMonth[dayIndex];
                final dateStr = '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
                final spending = spendingMap[dateStr] ?? 0;
                final intensity = maxSpending > 0 ? (spending / maxSpending).clamp(0.0, 1.0) : 0.0;
                final isToday = AppDateUtils.isToday(day);
                final isFuture = day.isAfter(DateTime.now());

                return Tooltip(
                  message: spending > 0 ? '₹${spending.toStringAsFixed(0)}' : 'No spending',
                  child: Container(
                    decoration: BoxDecoration(
                      color: isFuture
                          ? (isDark ? AppColors.darkCard.withOpacity(0.3) : AppColors.divider.withOpacity(0.5))
                          : spending > 0
                              ? AppColors.expense.withOpacity(0.15 + intensity * 0.7)
                              : (isDark ? AppColors.darkCard : AppColors.divider),
                      borderRadius: BorderRadius.circular(6),
                      border: isToday
                          ? Border.all(color: AppColors.primary, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                          color: isToday
                              ? AppColors.primary
                              : spending > 0
                                  ? (intensity > 0.5 ? Colors.white : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary))
                                  : (isDark ? AppColors.darkTextTertiary : AppColors.textTertiary),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Less',
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                  ),
                ),
                const SizedBox(width: 6),
                ...[0.1, 0.3, 0.5, 0.7, 0.9].map((i) => Container(
                      width: 16,
                      height: 16,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: AppColors.expense.withOpacity(0.15 + i * 0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )),
                const SizedBox(width: 6),
                Text(
                  'More',
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
