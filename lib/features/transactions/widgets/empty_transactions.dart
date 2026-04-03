import 'package:flutter/material.dart';
import 'package:finance_tracker/shared/widgets/empty_state_widget.dart';

class EmptyTransactions extends StatelessWidget {
  final VoidCallback? onAdd;

  const EmptyTransactions({super.key, this.onAdd});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.receipt_long_rounded,
      title: 'No Transactions Yet',
      subtitle: 'Start tracking your spending by adding your first transaction.',
      buttonLabel: 'Add Transaction',
      onAction: onAdd,
    );
  }
}
