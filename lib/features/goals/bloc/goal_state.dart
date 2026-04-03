import 'package:equatable/equatable.dart';
import 'package:finance_tracker/data/models/goal_model.dart';

enum GoalStatus { initial, loading, loaded, error }

class GoalState extends Equatable {
  final GoalStatus status;
  final List<GoalModel> activeGoals;
  final List<GoalModel> completedGoals;
  final int currentStreak;
  final String? error;

  const GoalState({
    this.status = GoalStatus.initial,
    this.activeGoals = const [],
    this.completedGoals = const [],
    this.currentStreak = 0,
    this.error,
  });

  GoalState copyWith({
    GoalStatus? status,
    List<GoalModel>? activeGoals,
    List<GoalModel>? completedGoals,
    int? currentStreak,
    String? error,
  }) {
    return GoalState(
      status: status ?? this.status,
      activeGoals: activeGoals ?? this.activeGoals,
      completedGoals: completedGoals ?? this.completedGoals,
      currentStreak: currentStreak ?? this.currentStreak,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, activeGoals, completedGoals, currentStreak, error];
}
