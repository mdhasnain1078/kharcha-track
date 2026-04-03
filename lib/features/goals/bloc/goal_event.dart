import 'package:equatable/equatable.dart';
import 'package:finance_tracker/data/models/goal_model.dart';

abstract class GoalEvent extends Equatable {
  const GoalEvent();

  @override
  List<Object?> get props => [];
}

class LoadGoals extends GoalEvent {}

class AddGoal extends GoalEvent {
  final GoalModel goal;
  const AddGoal(this.goal);
  @override
  List<Object?> get props => [goal];
}

class UpdateGoal extends GoalEvent {
  final GoalModel goal;
  const UpdateGoal(this.goal);
  @override
  List<Object?> get props => [goal];
}

class DeleteGoal extends GoalEvent {
  final String id;
  const DeleteGoal(this.id);
  @override
  List<Object?> get props => [id];
}

class ContributeToGoal extends GoalEvent {
  final String id;
  final double amount;
  const ContributeToGoal(this.id, this.amount);
  @override
  List<Object?> get props => [id, amount];
}

class MarkDayAsSaved extends GoalEvent {}
