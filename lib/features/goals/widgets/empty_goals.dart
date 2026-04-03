import 'package:flutter/material.dart';
import 'package:finance_tracker/shared/widgets/empty_state_widget.dart';

class EmptyGoals extends StatelessWidget {
  final VoidCallback? onAdd;

  const EmptyGoals({super.key, this.onAdd});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.flag_rounded,
      title: 'No Goals Yet',
      subtitle: 'Set a savings goal and start your journey toward financial freedom.',
      buttonLabel: 'Create Goal',
      onAction: onAdd,
    );
  }
}
