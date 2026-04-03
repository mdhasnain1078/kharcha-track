import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finance_tracker/core/theme/app_colors.dart';
import 'package:finance_tracker/core/extensions/context_extensions.dart';
import 'package:finance_tracker/data/models/goal_model.dart';
import 'package:finance_tracker/features/settings/bloc/settings_bloc.dart';
import 'package:finance_tracker/features/settings/bloc/settings_state.dart';
import 'package:finance_tracker/features/goals/widgets/goal_card.dart';

class GoalListSection extends StatelessWidget {
  final String title;
  final List<GoalModel> goals;
  final void Function(GoalModel goal) onTap;
  final void Function(String goalId)? onContribute;

  const GoalListSection({
    super.key,
    required this.title,
    required this.goals,
    required this.onTap,
    this.onContribute,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final goal = goals[index];
              return BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, settingsState) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    child: GoalCard(
                      goal: goal,
                      currencySymbol: settingsState.currencySymbol,
                      onTap: () => onTap(goal),
                      onContribute: onContribute != null ? () => onContribute!(goal.id) : null,
                    ),
                  );
                },
              );
            },
            childCount: goals.length,
          ),
        ),
      ],
    );
  }
}
