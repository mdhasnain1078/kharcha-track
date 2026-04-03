import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:finance_tracker/core/extensions/context_extensions.dart';
import 'package:finance_tracker/features/goals/bloc/goal_bloc.dart';
import 'package:finance_tracker/features/goals/bloc/goal_event.dart';
import 'package:finance_tracker/features/goals/bloc/goal_state.dart';
import 'package:finance_tracker/features/goals/widgets/goals_header.dart';
import 'package:finance_tracker/features/goals/widgets/goal_list_section.dart';
import 'package:finance_tracker/features/goals/widgets/savings_streak.dart';
import 'package:finance_tracker/features/goals/widgets/contribute_dialog.dart';
import 'package:finance_tracker/features/goals/widgets/empty_goals.dart';
import 'package:finance_tracker/shared/widgets/shimmer_loading.dart';
import 'package:finance_tracker/shared/widgets/error_widget.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GoalBloc>().add(LoadGoals());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<GoalBloc, GoalState>(
          builder: (context, state) {
            if (state.status == GoalStatus.error) {
              return AppErrorWidget(
                message: state.error ?? 'Failed to load',
                onRetry: () => context.read<GoalBloc>().add(LoadGoals()),
              );
            }
            return Column(
              children: [
                GoalsHeader(
                  onMarkSaved: () {
                    context.read<GoalBloc>().add(MarkDayAsSaved());
                    context.showSuccessSnackBar('Day marked as saved! 🔥');
                  },
                ),
                Expanded(child: _buildBody(state)),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/goals/add'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Goal'),
      ),
    );
  }

  Widget _buildBody(GoalState state) {
    if (state.status == GoalStatus.loading) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Column(children: [
          ShimmerCard(height: 80), SizedBox(height: 16),
          ShimmerCard(height: 140), SizedBox(height: 12),
          ShimmerCard(height: 140),
        ]),
      );
    }
    if (state.activeGoals.isEmpty && state.completedGoals.isEmpty) {
      return EmptyGoals(onAdd: () => context.push('/goals/add'));
    }
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: SavingsStreak(streak: state.currentStreak),
          ),
        ),
        if (state.activeGoals.isNotEmpty)
          GoalListSection(
            title: 'Active Goals (${state.activeGoals.length})',
            goals: state.activeGoals,
            onTap: (goal) => context.push('/goals/edit/${goal.id}'),
            onContribute: (id) => ContributeDialog.show(context, id),
          ),
        if (state.completedGoals.isNotEmpty)
          GoalListSection(
            title: 'Completed (${state.completedGoals.length}) 🎉',
            goals: state.completedGoals,
            onTap: (goal) => context.push('/goals/edit/${goal.id}'),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}
