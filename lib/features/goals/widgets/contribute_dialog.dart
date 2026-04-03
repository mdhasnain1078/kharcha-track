import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:finance_tracker/core/extensions/context_extensions.dart';
import 'package:finance_tracker/features/goals/bloc/goal_bloc.dart';
import 'package:finance_tracker/features/goals/bloc/goal_event.dart';
import 'package:finance_tracker/features/home/bloc/home_bloc.dart';
import 'package:finance_tracker/features/home/bloc/home_event.dart';

class ContributeDialog {
  static void show(BuildContext context, String goalId) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Savings'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Amount', prefixText: '₹ '),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(controller.text);
              if (amount != null && amount > 0) {
                final state = context.read<GoalBloc>().state;
                final goals = [...state.activeGoals, ...state.completedGoals];
                final goal = goals.firstWhere((g) => g.id == goalId);
                
                if (amount + goal.savedAmount > goal.targetAmount) {
                  context.showSnackBar('Cannot exceed target goal amount', isError: true);
                  return;
                }

                context.read<GoalBloc>().add(ContributeToGoal(goalId, amount));
                context.read<HomeBloc>().add(RefreshDashboard());
                Navigator.pop(ctx);
                context.showSuccessSnackBar('Savings added! 💰');
              } else {
                context.showSnackBar('Please enter a valid amount', isError: true);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
