import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finance_tracker/data/models/transaction_model.dart';
import 'package:finance_tracker/data/repositories/transaction_repository.dart';
import 'package:finance_tracker/data/repositories/goal_repository.dart';
import 'package:finance_tracker/core/utils/date_utils.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final TransactionRepository _transactionRepo;
  final GoalRepository _goalRepo;

  HomeBloc({
    required TransactionRepository transactionRepository,
    required GoalRepository goalRepository,
  })  : _transactionRepo = transactionRepository,
        _goalRepo = goalRepository,
        super(const HomeState()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<RefreshDashboard>(_onRefreshDashboard);
  }

  Future<void> _onLoadDashboard(LoadDashboard event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));
    await _loadData(emit);
  }

  Future<void> _onRefreshDashboard(RefreshDashboard event, Emitter<HomeState> emit) async {
    await _loadData(emit);
  }

  Future<void> _loadData(Emitter<HomeState> emit) async {
    try {
      final balance = await _transactionRepo.getBalance();
      final income = await _transactionRepo.getTotalIncome();
      final expense = await _transactionRepo.getTotalExpense();

      // Weekly spending
      final weekStart = AppDateUtils.startOfWeek;
      final weeklySpending = await _transactionRepo.getDailySpendingForWeek(weekStart);

      // Category breakdown for current month
      final categoryBreakdown = await _transactionRepo.getCategoryTotals(
        type: TransactionType.expense,
        start: AppDateUtils.startOfMonth,
        end: AppDateUtils.endOfMonth,
      );

      // Recent transactions
      final recentTransactions = await _transactionRepo.getRecentTransactions(limit: 5);

      // Savings progress
      final totalSaved = await _goalRepo.getTotalSaved();
      final totalTarget = await _goalRepo.getTotalTarget();
      final savingsProgress = totalTarget > 0 ? (totalSaved / totalTarget).clamp(0.0, 1.0) : 0.0;
      final activeGoalCount = await _goalRepo.getActiveGoalCount();

      emit(state.copyWith(
        status: HomeStatus.loaded,
        balance: balance,
        totalIncome: income,
        totalExpense: expense,
        weeklySpending: weeklySpending,
        categoryBreakdown: categoryBreakdown,
        recentTransactions: recentTransactions,
        savingsProgress: savingsProgress,
        totalSaved: totalSaved,
        totalTarget: totalTarget,
        activeGoalCount: activeGoalCount,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.error,
        error: 'Failed to load dashboard data',
      ));
    }
  }
}
