import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:finance_tracker/core/theme/app_colors.dart';
import 'package:finance_tracker/core/utils/date_utils.dart';
import 'package:finance_tracker/core/utils/currency_utils.dart';
import 'package:finance_tracker/data/models/transaction_model.dart';
import 'package:finance_tracker/data/models/category_model.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RecentTransactions extends StatelessWidget {
  final List<TransactionModel> transactions;
  final String currencySymbol;

  const RecentTransactions({
    super.key,
    required this.transactions,
    this.currencySymbol = '₹',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
            ),
            if (transactions.isNotEmpty)
              GestureDetector(
                onTap: () => context.go('/transactions'),
                child: Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (transactions.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long_rounded,
                      size: 40,
                      color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No transactions yet',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap + to add your first transaction',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: transactions.asMap().entries.map((entry) {
                  final i = entry.key;
                  final t = entry.value;
                  final category = CategoryModel.getCategoryByName(t.category);
                  final isIncome = t.type == TransactionType.income;

                  return Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        leading: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: category.color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(category.icon, color: category.color, size: 22),
                        ),
                        title: Text(
                          t.category,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          AppDateUtils.getRelativeDate(t.date),
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                          ),
                        ),
                        trailing: Text(
                          '${isIncome ? '+' : '-'}${CurrencyUtils.formatAmountCompact(t.amount, symbol: currencySymbol)}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isIncome ? AppColors.income : AppColors.expense,
                          ),
                        ),
                        onTap: () => context.push('/transactions/edit/${t.id}'),
                      ),
                      if (i < transactions.length - 1)
                        Divider(
                          height: 1,
                          indent: 78,
                          color: isDark ? AppColors.darkBorder : AppColors.divider,
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    ).animate(delay: 500.ms).fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0);
  }
}
