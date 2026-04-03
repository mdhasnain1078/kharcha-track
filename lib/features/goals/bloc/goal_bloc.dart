import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finance_tracker/data/repositories/goal_repository.dart';
import 'goal_event.dart';
import 'goal_state.dart';

class GoalBloc extends Bloc<GoalEvent, GoalState> {
  final GoalRepository _repo;

  GoalBloc({required GoalRepository goalRepository})
      : _repo = goalRepository,
        super(const GoalState()) {
    on<LoadGoals>(_onLoadGoals);
    on<AddGoal>(_onAddGoal);
    on<UpdateGoal>(_onUpdateGoal);
    on<DeleteGoal>(_onDeleteGoal);
    on<ContributeToGoal>(_onContributeToGoal);
    on<MarkDayAsSaved>(_onMarkDayAsSaved);
  }

  Future<void> _onLoadGoals(LoadGoals event, Emitter<GoalState> emit) async {
    emit(state.copyWith(status: GoalStatus.loading));
    try {
      final active = await _repo.getActiveGoals();
      final completed = await _repo.getCompletedGoals();
      final streak = await _repo.getCurrentStreak();

      emit(state.copyWith(
        status: GoalStatus.loaded,
        activeGoals: active,
        completedGoals: completed,
        currentStreak: streak,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: GoalStatus.error,
        error: 'Failed to load goals',
      ));
    }
  }

  Future<void> _onAddGoal(AddGoal event, Emitter<GoalState> emit) async {
    try {
      await _repo.insertGoal(event.goal);
      add(LoadGoals());
    } catch (e) {
      emit(state.copyWith(error: 'Failed to add goal'));
    }
  }

  Future<void> _onUpdateGoal(UpdateGoal event, Emitter<GoalState> emit) async {
    try {
      await _repo.updateGoal(event.goal);
      add(LoadGoals());
    } catch (e) {
      emit(state.copyWith(error: 'Failed to update goal'));
    }
  }

  Future<void> _onDeleteGoal(DeleteGoal event, Emitter<GoalState> emit) async {
    try {
      await _repo.deleteGoal(event.id);
      add(LoadGoals());
    } catch (e) {
      emit(state.copyWith(error: 'Failed to delete goal'));
    }
  }

  Future<void> _onContributeToGoal(ContributeToGoal event, Emitter<GoalState> emit) async {
    try {
      await _repo.contributeToGoal(event.id, event.amount);
      add(LoadGoals());
    } catch (e) {
      emit(state.copyWith(error: 'Failed to contribute'));
    }
  }

  Future<void> _onMarkDayAsSaved(MarkDayAsSaved event, Emitter<GoalState> emit) async {
    try {
      await _repo.markDayAsSaved(DateTime.now());
      final streak = await _repo.getCurrentStreak();
      emit(state.copyWith(currentStreak: streak));
    } catch (e) {
      // silently fail
    }
  }
}
