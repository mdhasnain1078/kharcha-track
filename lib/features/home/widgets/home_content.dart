import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:finance_tracker/features/home/bloc/home_state.dart';
import 'package:finance_tracker/features/home/widgets/balance_card.dart';
import 'package:finance_tracker/features/home/widgets/summary_cards.dart';
import 'package:finance_tracker/features/home/widgets/spending_chart.dart';
import 'package:finance_tracker/features/home/widgets/weekly_trend_chart.dart';
import 'package:finance_tracker/features/home/widgets/recent_transactions.dart';

class HomeContent extends StatelessWidget {
  final HomeState state;
  final String currencySymbol;

  const HomeContent({
    super.key,
    required this.state,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.all(20),
      children: [
        BalanceCard(
          balance: state.balance,
          savingsProgress: state.savingsProgress,
          totalSaved: state.totalSaved,
          totalTarget: state.totalTarget,
          activeGoalCount: state.activeGoalCount,
          currencySymbol: currencySymbol,
          onTap: () => context.go('/goals'),
        ),
        const SizedBox(height: 20),
        SummaryCards(
          income: state.totalIncome,
          expense: state.totalExpense,
          currencySymbol: currencySymbol,
        ),
        const SizedBox(height: 20),
        SpendingChart(weeklySpending: state.weeklySpending, currencySymbol: currencySymbol),
        const SizedBox(height: 20),
        WeeklyTrendChart(categoryBreakdown: state.categoryBreakdown),
        const SizedBox(height: 20),
        RecentTransactions(
          transactions: state.recentTransactions,
          currencySymbol: currencySymbol,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
