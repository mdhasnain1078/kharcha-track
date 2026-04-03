import 'package:flutter/material.dart';
import 'package:finance_tracker/core/theme/app_colors.dart';
import 'package:finance_tracker/core/utils/currency_utils.dart';
import 'package:finance_tracker/features/insights/bloc/insights_state.dart';
import 'package:finance_tracker/features/insights/widgets/category_breakdown_chart.dart';
import 'package:finance_tracker/features/insights/widgets/weekly_comparison.dart';
import 'package:finance_tracker/features/insights/widgets/monthly_trend_chart.dart';
import 'package:finance_tracker/features/insights/widgets/top_spending_card.dart';
import 'package:finance_tracker/features/insights/widgets/spending_heatmap.dart';
import 'package:finance_tracker/features/insights/widgets/frequent_category_card.dart';
import 'package:finance_tracker/shared/widgets/stat_card.dart';
import 'package:flutter_animate/flutter_animate.dart';

class InsightsContent extends StatelessWidget {
  final InsightsState state;
  final String currencySymbol;

  const InsightsContent({
    super.key,
    required this.state,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Transactions',
                value: state.totalTransactions.toString(),
                icon: Icons.receipt_rounded,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: 'Avg. Expense',
                value: CurrencyUtils.formatAmountCompact(
                  state.averageTransaction,
                  symbol: currencySymbol,
                ),
                icon: Icons.analytics_rounded,
                color: AppColors.accent,
              ),
            ),
          ],
        ).animate().fadeIn(duration: 300.ms),
        const SizedBox(height: 16),
        TopSpendingCard(
          categoryName: state.topCategory,
          amount: state.topCategoryAmount,
          currencySymbol: currencySymbol,
        ),
        const SizedBox(height: 16),
        WeeklyComparison(
          thisWeek: state.thisWeekTotal,
          lastWeek: state.lastWeekTotal,
          currencySymbol: currencySymbol,
        ).animate(delay: 100.ms).fadeIn(duration: 400.ms),
        const SizedBox(height: 16),
        CategoryBreakdownChart(
          breakdown: state.categoryBreakdown,
          currencySymbol: currencySymbol,
        ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
        const SizedBox(height: 16),
        MonthlyTrendChart(
          monthlyTrend: state.monthlyTrend,
          currencySymbol: currencySymbol,
        ).animate(delay: 300.ms).fadeIn(duration: 400.ms),
        const SizedBox(height: 16),
        SpendingHeatmap(
          dailySpending: state.dailySpending,
        ).animate(delay: 400.ms).fadeIn(duration: 400.ms),
        if (state.frequentType != null) ...[
          const SizedBox(height: 16),
          FrequentCategoryCard(categoryName: state.frequentType!),
        ],
        const SizedBox(height: 40),
      ],
    );
  }
}
