import 'package:flutter/material.dart';
import 'package:finance_tracker/core/theme/app_colors.dart';
import 'package:finance_tracker/core/utils/currency_utils.dart';
import 'package:finance_tracker/data/models/goal_model.dart';
import 'package:finance_tracker/core/constants/app_constants.dart';
import 'package:finance_tracker/features/goals/widgets/goal_progress_ring.dart';

class GoalCard extends StatelessWidget {
  final GoalModel goal;
  final VoidCallback? onTap;
  final VoidCallback? onContribute;
  final String currencySymbol;

  const GoalCard({
    super.key,
    required this.goal,
    this.onTap,
    this.onContribute,
    this.currencySymbol = '₹',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goalColor = Color(goal.color);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: goalColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      AppConstants.goalIcons.firstWhere(
                        (i) => i.codePoint == goal.iconCodePoint,
                        orElse: () => Icons.savings_rounded,
                      ),
                      color: goalColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          goal.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          goal.isCompleted
                              ? 'Completed! 🎉'
                              : goal.isOverdue
                                  ? 'Overdue'
                                  : '${goal.daysRemaining} days left',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: goal.isCompleted
                                ? AppColors.income
                                : goal.isOverdue
                                    ? AppColors.expense
                                    : (isDark ? AppColors.darkTextTertiary : AppColors.textTertiary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GoalProgressRing(
                    progress: goal.progress,
                    color: goalColor,
                    size: 56,
                    strokeWidth: 6,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Saved',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                        ),
                      ),
                      Text(
                        CurrencyUtils.formatAmountCompact(goal.savedAmount, symbol: currencySymbol),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Target',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                        ),
                      ),
                      Text(
                        CurrencyUtils.formatAmountCompact(goal.targetAmount, symbol: currencySymbol),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: goalColor,
                        ),
                      ),
                    ],
                  ),
                  if (!goal.isCompleted)
                    ElevatedButton(
                      onPressed: onContribute,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: goalColor,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        minimumSize: Size.zero,
                      ),
                      child: const Text(
                        'Add',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
